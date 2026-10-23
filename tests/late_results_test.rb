# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'openssl'
require 'socket'
require 'uri'
require 'noresponse'

# A local HTTP/1.1 server standing in for a provider's admin API. It records
# each request and answers from the route block: [status, body] or nil (404).
class MockProvider
  Call = Struct.new(:verb, :path, :query, :auth, :accept, :content_type, :body, keyword_init: true)

  attr_reader :calls

  def initialize(&route)
    @route = route
    @calls = []
    @server = TCPServer.new('127.0.0.1', 0)
    @thread = Thread.new { serve }
  end

  def url = "http://127.0.0.1:#{@server.addr[1]}"

  def close
    @server.close
    @thread.join(2)
  end

  private

  def serve
    loop do
      socket = @server.accept
      Thread.new(socket) { |s| handle(s) }
    end
  rescue IOError, Errno::EBADF
    nil
  end

  def handle(socket)
    method, target, = socket.gets.split(' ')
    headers = {}
    while (line = socket.gets) && line != "\r\n"
      name, value = line.chomp.split(': ', 2)
      headers[name.downcase] = value
    end
    text = socket.read(headers['content-length'].to_i).to_s
    uri = URI.parse(target)
    call = Call.new(verb: method, path: uri.path, query: URI.decode_www_form(uri.query.to_s).to_h,
                    auth: headers['authorization'], accept: headers['accept'],
                    content_type: headers['content-type'], body: text.empty? ? nil : JSON.parse(text))
    @calls << call
    status, body = @route.call(call) || [404, { 'error' => 'not found' }]
    payload = body.nil? ? '' : JSON.generate(body)
    socket.write("HTTP/1.1 #{status} X\r\nContent-Type: application/json\r\nContent-Length: #{payload.bytesize}\r\n" \
                 "Connection: close\r\n\r\n#{payload}")
  ensure
    socket.close
  end
end

class LateResultsTest < Minitest::Test
  LateResults = NoResponse::LateResults
  Webhooks = NoResponse::Webhooks
  FIXTURES = File.join(__dir__, 'fixtures')
  SECRET = 'late-result-secret'
  KEY = 'whk_sdktest01'
  NOW = 1_791_968_402
  SECRETS = { KEY => SECRET }.freeze

  def fixture(name) = JSON.parse(File.read(File.join(FIXTURES, name)))

  def review = fixture('valid/assessment-phone-uncovered-complete.json')
  def step_up = fixture('valid/assessment-complete.json')
  def pending = fixture('valid/assessment-pending.json')
  def expired = fixture('valid/webhook-assessment-expired.json')['data']

  def delivery(data, account_id = nil, test: false)
    id = 'evt_01JA2ZB4N5P6Q7R8S9T0VWXYZ2'
    data = data.merge('account_id' => account_id) if account_id
    envelope = { 'id' => id, 'type' => 'assessment.updated', 'created_at' => '2026-10-18T11:00:04Z' }
    envelope['test'] = true if test
    raw = JSON.generate(envelope.merge('data' => data))
    stamp = NOW.to_s
    digest = OpenSSL::HMAC.hexdigest('SHA256', SECRET, "#{stamp}.#{raw}")
    [raw, { 'NR-Webhook-Id' => id, 'NR-Webhook-Timestamp' => stamp, 'NR-Webhook-Key-Id' => KEY,
            'NR-Webhook-Signature' => "v1=#{digest}" }]
  end

  def with_mock(route, &block)
    mock = MockProvider.new(&route)
    block.call(mock)
  ensure
    mock&.close
  end

  def lines(mock) = mock.calls.map { |c| "#{c.verb} #{c.path}" }

  def event(data)
    Webhooks::Event.new(id: 'evt_x', type: 'assessment.updated', created_at: '2026-10-18T11:00:04Z', data: data)
  end

  def assessment(status, recommendation = nil)
    body = status == 'expired' ? expired : step_up.merge('status' => status)
    if recommendation
      body['recommendation'] = recommendation
      body['risk'] = (body['risk'] || {}).merge('recommendation' => recommendation) if body['risk']
    end
    event(Webhooks.send(:event_data, 'assessment.updated', body))
  end

  def test_default_policy_revokes_on_review_and_does_nothing_otherwise
    assert_equal 'revoke_sessions', LateResults.action_for(assessment('complete', 'review'))
    assert_equal 'none', LateResults.action_for(assessment('complete', 'step_up'))
    assert_equal 'none', LateResults.action_for(assessment('partial', 'allow'))
    assert_equal 'none', LateResults.action_for(event(Webhooks::AssessmentExpired.new(assessment_id: 'asm_x', account_id: 'a', assessment_version: 1)))
    verification = Webhooks::Event.new(id: 'evt_x', type: 'endpoint.verification', created_at: 'x', data: nil)
    assert_equal 'none', LateResults.action_for(verification)
    assert_equal 'ban', LateResults.action_for(assessment('complete', 'step_up'), { step_up: 'ban' })
    assert_equal 'none', LateResults.action_for(assessment('complete', 'review'), { 'step_up' => 'ban' })
    assert_raises(ArgumentError) { LateResults.action_for(assessment('complete', 'review'), { review: 'delete' }) }
    assert_equal({ 'allow' => 'none', 'step_up' => 'none', 'review' => 'revoke_sessions' }, LateResults::DEFAULT_POLICY)
  end

  def test_pending_and_expired_deliveries_do_nothing
    mock_free = Object.new
    def mock_free.revoke_sessions(_id) = raise('called')
    def mock_free.ban(_id) = raise('called')
    [pending, expired].each do |data|
      raw, headers = delivery(data)
      result = LateResults.handle(raw, headers, SECRETS, mock_free, now: NOW)
      assert_equal 'none', result.action
      assert_nil result.user_id
    end
  end

  def test_clerk_review_revokes_each_active_session_and_ban_policy_bans
    route = lambda do |c|
      if c.verb == 'GET' && c.path == '/v1/sessions'
        [200, c.query['offset'] == '0' ? [{ 'id' => 'sess_1', 'status' => 'active' }, { 'id' => 'sess_2', 'status' => 'active' }] : []]
      elsif c.verb == 'POST' && c.path =~ %r{\A/v1/sessions/sess_\d/revoke\z}
        [200, { 'id' => c.path.split('/')[3], 'status' => 'revoked' }]
      elsif c.verb == 'POST' && c.path == '/v1/users/user_2EXAMPLE/ban'
        [200, { 'id' => 'user_2EXAMPLE', 'banned' => true }]
      end
    end
    with_mock(route) do |mock|
      clerk = LateResults.clerk(secret_key: 'sk_test_mock', base_url: "#{mock.url}/v1")
      raw, headers = delivery(review, 'user_2EXAMPLE')
      result = LateResults.handle(raw, headers, SECRETS, clerk, now: NOW)
      assert_equal 'revoke_sessions', result.action
      assert_equal 'user_2EXAMPLE', result.user_id
      assert_equal review['assessment_id'], result.event.data.assessment_id
      assert_equal ['GET /v1/sessions', 'POST /v1/sessions/sess_1/revoke', 'POST /v1/sessions/sess_2/revoke'], lines(mock)
      assert_equal({ 'user_id' => 'user_2EXAMPLE', 'status' => 'active', 'limit' => '100', 'offset' => '0' },
                   mock.calls[0].query)
      assert(mock.calls.all? { |c| c.auth == 'Bearer sk_test_mock' && c.accept == 'application/json' })

      mock.calls.clear
      banned = LateResults.handle(raw, headers, SECRETS, clerk, now: NOW, policy: { review: 'ban' })
      assert_equal 'ban', banned.action
      assert_equal ['POST /v1/users/user_2EXAMPLE/ban'], lines(mock)
    end
  end

  def test_workos_revoke_pages_through_sessions_and_ban_revokes_then_deletes
    route = lambda do |c|
      if c.verb == 'GET' && c.path == '/user_management/users/user_01WORKOS/sessions'
        if c.query['after'].nil?
          [200, { 'object' => 'list', 'data' => [{ 'id' => 'session_A', 'status' => 'active' }, { 'id' => 'session_X', 'status' => 'revoked' }],
                  'list_metadata' => { 'before' => nil, 'after' => 'session_X' } }]
        else
          [200, { 'object' => 'list', 'data' => [{ 'id' => 'session_B', 'status' => 'active' }],
                  'list_metadata' => { 'before' => 'session_B', 'after' => nil } }]
        end
      elsif c.verb == 'POST' && c.path == '/user_management/sessions/revoke'
        [200, { 'id' => c.body['session_id'], 'status' => 'revoked' }]
      elsif c.verb == 'DELETE' && c.path == '/user_management/users/user_01WORKOS'
        [202, nil]
      end
    end
    with_mock(route) do |mock|
      workos = LateResults.workos(api_key: 'sk_test_workos', base_url: mock.url)
      raw, headers = delivery(step_up, 'acct_7f3a9c')
      resolver = ->(account_id, _event) { account_id == 'acct_7f3a9c' ? 'user_01WORKOS' : nil }
      result = LateResults.handle(raw, headers, SECRETS, workos, now: NOW, policy: { step_up: 'ban' },
                                                                 user_id: resolver)
      assert_equal 'ban', result.action
      assert_equal 'user_01WORKOS', result.user_id
      seen = mock.calls.map { |c| "#{c.verb} #{c.path} #{JSON.generate(c.body || c.query)}" }
      assert_equal [
        'GET /user_management/users/user_01WORKOS/sessions {"limit":"100"}',
        'GET /user_management/users/user_01WORKOS/sessions {"limit":"100","after":"session_X"}',
        'POST /user_management/sessions/revoke {"session_id":"session_A"}',
        'POST /user_management/sessions/revoke {"session_id":"session_B"}',
        'DELETE /user_management/users/user_01WORKOS {}'
      ], seen
      assert(mock.calls.all? { |c| c.auth == 'Bearer sk_test_workos' })
      assert_equal 'application/json', mock.calls[2].content_type
    end
  end

  def test_workos_delete_of_a_missing_user_counts_as_done
    route = lambda do |c|
      if c.verb == 'GET' then [200, { 'data' => [], 'list_metadata' => { 'after' => nil } }]
      elsif c.verb == 'DELETE' then [404, { 'error' => 'gone' }]
      end
    end
    with_mock(route) do |mock|
      workos = LateResults.workos(api_key: 'sk_test_workos', base_url: mock.url)
      workos.ban('user_01GONE')
      assert_equal ['GET /user_management/users/user_01GONE/sessions', 'DELETE /user_management/users/user_01GONE'],
                   lines(mock)
    end
  end

  def test_auth0_review_deletes_sessions_and_tokens_ban_blocks_first_and_pipe_is_escaped
    id = 'auth0|64abc0de1234567890abcdef'
    escaped = 'auth0%7C64abc0de1234567890abcdef'
    route = lambda do |c|
      if c.path == "/api/v2/users/#{escaped}/sessions" && c.verb == 'DELETE' then [202, nil]
      elsif c.path == "/api/v2/users/#{escaped}/refresh-tokens" && c.verb == 'DELETE' then [202, nil]
      elsif c.path == "/api/v2/users/#{escaped}" && c.verb == 'PATCH' then [200, { 'user_id' => id, 'blocked' => c.body['blocked'] }]
      end
    end
    with_mock(route) do |mock|
      auth0 = LateResults.auth0(base_url: "#{mock.url}/api/v2", token: 'mgmt_token')
      raw, headers = delivery(review, id)
      result = LateResults.handle(raw, headers, SECRETS, auth0, now: NOW)
      assert_equal 'revoke_sessions', result.action
      assert_equal ["DELETE /api/v2/users/#{escaped}/sessions", "DELETE /api/v2/users/#{escaped}/refresh-tokens"], lines(mock)

      mock.calls.clear
      LateResults.handle(raw, headers, SECRETS, auth0, now: NOW, policy: { review: 'ban' })
      seen = mock.calls.map { |c| "#{c.verb} #{c.path} #{JSON.generate(c.body)}" }
      assert_equal [
        "PATCH /api/v2/users/#{escaped} {\"blocked\":true}",
        "DELETE /api/v2/users/#{escaped}/sessions null",
        "DELETE /api/v2/users/#{escaped}/refresh-tokens null"
      ], seen
      assert(mock.calls.all? { |c| c.auth == 'Bearer mgmt_token' })
    end
  end

  def test_auth0_domain_builds_the_management_base_url
    seen = []
    client = lambda do |method, uri, headers, body|
      seen << [method, uri.to_s, headers['Authorization'], body]
      [204, '']
    end
    LateResults.auth0(domain: 'example.eu.auth0.com', token: 't', http_client: client).revoke_sessions('u1')
    assert_equal [['DELETE', 'https://example.eu.auth0.com/api/v2/users/u1/sessions', 'Bearer t', nil],
                  ['DELETE', 'https://example.eu.auth0.com/api/v2/users/u1/refresh-tokens', 'Bearer t', nil]], seen
  end

  def test_unverified_quiet_or_unmapped_events_make_no_provider_call_and_a_refusal_raises
    route = ->(c) { c.verb == 'DELETE' ? [403, { 'error' => 'insufficient_scope' }] : nil }
    with_mock(route) do |mock|
      auth0 = LateResults.auth0(base_url: "#{mock.url}/api/v2", token: 'mgmt_token')
      raw, headers = delivery(review, 'auth0|abc')
      error = assert_raises(Webhooks::VerificationError) do
        LateResults.handle(raw, headers, { KEY => 'wrong' }, auth0, now: NOW)
      end
      assert_equal :invalid_signature, error.code
      assert_raises(Webhooks::VerificationError) { LateResults.handle("#{raw} ", headers, SECRETS, auth0, now: NOW) }
      error = assert_raises(Webhooks::VerificationError) do
        LateResults.handle(raw, headers, SECRETS, auth0, now: NOW + 301)
      end
      assert_equal :invalid_timestamp, error.code
      [step_up, pending, expired].each do |data|
        body, hdrs = delivery(data)
        assert_equal 'none', LateResults.handle(body, hdrs, SECRETS, auth0, now: NOW).action
      end
      assert_equal 'none', LateResults.handle(raw, headers, SECRETS, auth0, now: NOW, user_id: ->(*) {}).action
      assert_empty mock.calls
      error = assert_raises(LateResults::ProviderActionError) { LateResults.handle(raw, headers, SECRETS, auth0, now: NOW) }
      assert_equal 403, error.status
      assert_equal 'auth0', error.provider
      refute_includes error.message, 'mgmt_token'
      refute_includes error.message, 'insufficient_scope'
      assert_equal 1, mock.calls.length
    end
  end

  def test_a_test_event_is_flagged_and_makes_no_provider_call_even_under_a_ban_policy_with_a_resolver
    sample = fixture('valid/webhook-assessment-updated-test.json')['data']
    ban_all = { allow: 'ban', step_up: 'ban', review: 'ban' }
    resolver = ->(_account_id, _event) { 'user_2EXAMPLE' }
    with_mock(->(_c) { [200, []] }) do |mock|
      clerk = LateResults.clerk(secret_key: 'sk_test_mock', base_url: "#{mock.url}/v1")
      raw, headers = delivery(sample, test: true)
      result = LateResults.handle(raw, headers, SECRETS, clerk, now: NOW, policy: ban_all, user_id: resolver)
      assert_equal 'none', result.action
      assert result.event.test?
      assert_nil result.user_id
      assert_empty mock.calls

      # The same body without the flag would ban, and an ordinary delivery is not a test.
      raw, headers = delivery(sample)
      real = LateResults.handle(raw, headers, SECRETS, clerk, now: NOW, policy: ban_all, user_id: resolver)
      refute real.event.test?
      assert_equal 'ban', real.action
      assert_equal ['POST /v1/users/user_2EXAMPLE/ban'], lines(mock)
    end
  end

  def test_a_repeated_ban_after_the_user_is_gone_completes_and_a_500_still_raises
    # Every user-scoped endpoint answers 404: the first delivery already removed the user.
    with_mock(->(_c) { [404, { 'message' => 'not found' }] }) do |mock|
      providers = [
        LateResults.workos(api_key: 'sk_test_workos', base_url: mock.url),
        LateResults.clerk(secret_key: 'sk_test_mock', base_url: "#{mock.url}/v1"),
        LateResults.auth0(base_url: "#{mock.url}/api/v2", token: 'mgmt_token')
      ]
      raw, headers = delivery(review, 'user_GONE')
      2.times do
        providers.each do |provider|
          assert_equal 'ban', LateResults.handle(raw, headers, SECRETS, provider, now: NOW, policy: { review: 'ban' }).action
          assert_equal 'revoke_sessions', LateResults.handle(raw, headers, SECRETS, provider, now: NOW).action
        end
      end
      seen = lines(mock)
      ['GET /user_management/users/user_GONE/sessions', 'DELETE /user_management/users/user_GONE',
       'GET /v1/sessions', 'POST /v1/users/user_GONE/ban', 'PATCH /api/v2/users/user_GONE',
       'DELETE /api/v2/users/user_GONE/refresh-tokens'].each { |line| assert_includes seen, line }
    end
    # A session that ends between the list and its revoke also counts as done.
    vanish = ->(c) { c.verb == 'GET' ? [200, [{ 'id' => 'sess_1', 'status' => 'active' }]] : [404, nil] }
    with_mock(vanish) do |mock|
      LateResults.clerk(secret_key: 'sk_test_mock', base_url: "#{mock.url}/v1").revoke_sessions('user_2EXAMPLE')
      assert_equal ['GET /v1/sessions', 'POST /v1/sessions/sess_1/revoke'], lines(mock)
    end
    with_mock(->(_c) { [500, { 'error' => 'boom' }] }) do |mock|
      [LateResults.workos(api_key: 'k', base_url: mock.url),
       LateResults.clerk(secret_key: 'k', base_url: "#{mock.url}/v1"),
       LateResults.auth0(base_url: "#{mock.url}/api/v2", token: 't')].each do |provider|
        error = assert_raises(LateResults::ProviderActionError) { provider.ban('user_X') }
        assert_equal 500, error.status
      end
    end
  end

  def test_argument_errors
    assert_raises(ArgumentError) { LateResults.clerk(secret_key: '') }
    assert_raises(ArgumentError) { LateResults.workos(api_key: '') }
    assert_raises(ArgumentError) { LateResults.auth0(token: 't') }
    assert_raises(ArgumentError) { LateResults.clerk(secret_key: 'k').ban('') }
    assert_raises(ArgumentError) { LateResults.workos(api_key: 'k').revoke_sessions('') }
  end
end
