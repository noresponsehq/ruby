# typed: ignore
# frozen_string_literal: true

# The shared late enforcement vectors through LateResults.handle_risk_change,
# plus what the vectors cannot say in JSON: verification and the custom provider.

require 'minitest/autorun'
require 'json'
require 'faraday'
require 'openssl'
require 'uri'
require 'noresponse'

# A Faraday adapter that serves a case's exchanges in order and fails on anything else.
class Transcript
  class << self
    attr_accessor :current
  end

  attr_reader :served

  def initialize(exchanges)
    @exchanges = exchanges
    @served = 0
  end

  def self.normalize(method, url)
    uri = URI.parse(url.to_s)
    query = URI.decode_www_form(uri.query.to_s).map { |k, v| "#{k}=#{v}" }.sort
    "#{method.to_s.upcase} #{uri.scheme}://#{uri.host}#{uri.path}?#{query.join('&')}"
  end

  def answer(env)
    got = self.class.normalize(env.method, env.url)
    raise Minitest::Assertion, "unexpected request #{got}" if @served >= @exchanges.length

    expected = @exchanges[@served]
    want = self.class.normalize(expected['request']['method'], expected['request']['url'])
    raise Minitest::Assertion, "request #{@served}: #{got} != #{want}" unless got == want

    if expected['request'].key?('body') && JSON.parse(env.request_body.to_s) != expected['request']['body']
      raise Minitest::Assertion, "body of request #{@served}: #{env.request_body}"
    end

    @served += 1
    response = expected['response']
    body = response['body'].nil? || response['status'] == 204 ? '' : JSON.generate(response['body'])
    [response['status'], response['headers'] || {}, body]
  end

  def done? = @served == @exchanges.length

  # The adapter instance Faraday builds per request delegates to the case's transcript.
  class Handler < Faraday::Adapter
    def call(env)
      super
      status, headers, body = Transcript.current.answer(env)
      save_response(env, status, body, headers)
      @app.call(env)
    end
  end
end

class LateResultsTest < Minitest::Test
  LateResults = NoResponse::LateResults
  VerificationError = NoResponse::WebhookVerification::VerificationError
  VECTORS = JSON.parse(File.read(File.join(__dir__, 'fixtures', 'late-results-vectors.json')))
  SECRETS = { VECTORS['key_id'] => VECTORS['secret_utf8'] }.freeze

  def sign(event)
    raw = JSON.generate(event)
    stamp = VECTORS['now'].to_s
    digest = OpenSSL::HMAC.hexdigest('SHA256', VECTORS['secret_utf8'], "#{stamp}.#{raw}")
    headers = { 'NR-Webhook-Id' => event['id'], 'NR-Webhook-Timestamp' => stamp,
                'NR-Webhook-Key-Id' => VECTORS['key_id'], 'NR-Webhook-Signature' => "v1=#{digest}" }
    [raw, headers]
  end

  def connection = Faraday.new { |f| f.adapter(Transcript::Handler) }

  def client(http)
    NoResponse::NoResponseClient.new(client: http, api_key: VECTORS['api_key'], server_url: VECTORS['api_base_url'])
  end

  VECTORS['cases'].each do |vector|
    define_method("test_vector_#{vector['name']}") do
      Transcript.current = Transcript.new(vector['exchanges'])
      http = connection
      provider = LateResults.identity_provider(vector['provider'], token: VECTORS['provider_token'],
                                                                   domain: vector['domain'], http: http)
      raw, headers = sign(vector['event'])
      get_account_state = lambda do |account|
        assert_equal vector['event']['data']['account']['id'], account.id
        state = vector['state']
        next nil if state.nil?

        LateResults::AccountStateAnswer.new(state: state['state'], user_id: state['user_id'],
                                            enforced_risk_version: state['enforced_risk_version'])
      end
      flows = (vector['flows'] || {}).transform_values { |policy| LateResults::FlowPolicy.new(reinstate: policy['reinstate']) }
      run = lambda do
        options = { provider: provider, get_account_state: get_account_state, flows: flows, now: VECTORS['now'] }
        LateResults.handle_risk_change(client(http), raw, headers, SECRETS, **options)
      end
      if vector['error']
        error = assert_raises(LateResults::ProviderActionError) { run.call }
        assert Transcript.current.done?, 'every exchange was requested'
        assert_equal vector['error'], { 'provider' => error.provider, 'status' => error.status, 'code' => error.code }
        next
      end
      result = run.call
      assert Transcript.current.done?, 'every exchange was requested'
      if vector['result']['skipped'].nil?
        assert_nil result.skipped
      else
        assert_equal vector['result']['skipped'], result.skipped
      end
      got = result.enforcements.map do |e|
        { 'flow' => e.flow, 'action' => e.action, 'status' => e.status }.merge(e.error_code ? { 'error_code' => e.error_code } : {})
      end
      assert_equal vector['result']['enforcements'], got
    end
  end

  def test_a_delivery_that_fails_verification_reads_and_acts_on_nothing
    Transcript.current = Transcript.new([])
    raw, headers = sign(VECTORS['cases'].first['event'])
    assert_raises(VerificationError) do
      options = { provider: LateResults.custom_provider({}), get_account_state: ->(_) { flunk 'not called' }, now: VECTORS['now'] }
      LateResults.handle_risk_change(client(connection), "#{raw} ", headers, SECRETS, **options)
    end
    assert Transcript.current.done?
  end

  def test_a_custom_provider_runs_your_functions_and_a_missing_one_fails_the_action
    decisions = Struct.new(:account_creation, :login, :purchase).new('block', 'block', 'block')
    account = Struct.new(:id, :risk_version, :decisions_by_flow).new('acct_7f3a9c', 9, decisions)
    recorded = []
    accounts = Object.new
    accounts.define_singleton_method(:record_enforcement) { |body:, **| recorded << body }
    client = Struct.new(:accounts).new(accounts)
    ran = []
    provider = LateResults.custom_provider(restrict: lambda { |user_id|
      ran << ['restrict', user_id]
      true # an implicit return value is not a list of actions
    })
    assert_raises(ArgumentError) do
      answer = LateResults::AccountStateAnswer.new(state: 'active', user_id: 'u_1')
      LateResults.enforce_account(client, account, provider: provider, get_account_state: ->(_) { answer })
    end
    assert_equal [['restrict', 'u_1']], ran
    got = recorded.map { |b| [b.action.serialize, b.status.serialize, b.error_code, b.provider.serialize] }
    assert_equal [['restrict', 'applied', nil, 'custom'], ['revoke_sessions', 'failed', 'custom.error', 'custom']], got
  end

  def test_identity_provider_needs_its_credentials
    assert_raises(ArgumentError) { LateResults.identity_provider('clerk', token: '') }
    assert_raises(ArgumentError) { LateResults.identity_provider('auth0', token: 't') }
    assert_raises(ArgumentError) { LateResults.identity_provider('okta', token: 't') }
  end
end
