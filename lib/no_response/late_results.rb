# typed: true
# frozen_string_literal: true

# Late-result handlers. Hand-written beside the generated client.
#
# An assessment can be revised after the signup was allowed: a slow source
# settles and the account's decision rises. NoResponse sends the new version as a
# signed assessment.updated webhook. LateResults.handle verifies that delivery
# with Webhooks.construct_event, picks an action from your policy, and acts
# through the auth provider's admin API: revoke the user's sessions or ban the
# user.
#
# The handler verifies the delivery itself, so it never acts on an unverified
# event, and it never acts on a test event from the send-test-event call. Every
# provider call treats a 404 (user or session already gone) as done, so a
# repeated delivery is safe. The provider calls are thin: you pass the credentials, and each
# action is the provider's documented admin endpoint.

require 'erb'
require 'json'
require 'net/http'
require 'uri'
require_relative 'webhooks'

module NoResponse
  module LateResults
    # What to do to the user. BAN also ends every session.
    NONE = 'none'
    REVOKE_SESSIONS = 'revoke_sessions'
    BAN = 'ban'
    ACTIONS = [NONE, REVOKE_SESSIONS, BAN].freeze

    # Revoke sessions on review and block; do nothing on allow or step_up.
    # Banning is opt-in.
    DEFAULT_POLICY = { 'allow' => NONE, 'step_up' => NONE, 'review' => REVOKE_SESSIONS,
                       'block' => REVOKE_SESSIONS }.freeze

    DECISIONS = %w[allow step_up review block].freeze

    # Raised when the provider's admin API refuses a call. Answer the webhook
    # with a 5xx so NoResponse retries it. The message holds no response body
    # and no credentials.
    class ProviderActionError < StandardError
      # code is the provider's error code from the response body, such as
      # Auth0's errorCode "insufficient_scope", when it sent one.
      attr_reader :provider, :status, :code

      def initialize(provider, status, message, code = nil)
        super(message)
        @provider = provider
        @status = status
        @code = code
      end
    end

    # event is the verified Webhooks::Event. action is the action that ran:
    # NONE when the policy, the event or the user id called for nothing. It can
    # be stronger than the policy's action when the provider had to fall back:
    # the auth0 provider reports BAN when it blocked the user because the
    # tenant's plan cannot end sessions. user_id is
    # the provider user id acted on, set only when an action was taken. Answer
    # an endpoint.verification with Webhooks.verification_response(event).
    Result = Struct.new(:event, :action, :user_id, keyword_init: true)

    class << self
      # The action your policy names for a verified event, from the account's
      # decision (data.account.risk.decision). Only a served assessment whose
      # account has a decision can act; a pending assessment, an expiry and a
      # test event never do. policy maps allow, step_up, review and block (as
      # strings or symbols) to NONE, REVOKE_SESSIONS or BAN; a decision you
      # leave out does nothing. An unknown action raises ArgumentError.
      def action_for(event, policy = DEFAULT_POLICY)
        return NONE if event.type != 'assessment.updated' || event.test? || event.expired?

        data = event.data
        return NONE if data.status == Models::Shared::Status::PENDING || data.account.nil?

        decision = data.account.risk.decision.to_s
        return NONE unless DECISIONS.include?(decision)

        table = policy.to_h.transform_keys(&:to_s)
        return NONE unless table.key?(decision)

        action = table[decision]
        return NONE if action.nil?

        action = action.to_s
        raise ArgumentError, "unknown late result action #{action}" unless ACTIONS.include?(action)

        action
      end

      # Verify a webhook delivery and apply your policy to it.
      #
      # payload, headers and secrets, plus tolerance_seconds and now, are
      # exactly what Webhooks.construct_event takes; a delivery that fails
      # verification raises Webhooks::VerificationError before any provider
      # call. Deduplicate on result.event.id and ignore versions older than one
      # you have acted on.
      #
      # policy defaults to DEFAULT_POLICY. user_id is an optional callable
      # (account_id, event) returning the provider user id for the assessment's
      # account_id; it defaults to the account_id itself, as when you assess
      # with the provider's user id. Return nil or "" to take no action.
      def handle(payload, headers, secrets, provider, policy: DEFAULT_POLICY, user_id: nil, **verify)
        event = Webhooks.construct_event(payload, headers, secrets, **verify)
        action = action_for(event, policy)
        return Result.new(event: event, action: NONE) if action == NONE || event.type != 'assessment.updated'

        account_id = event.data.detail.account_id
        resolved = user_id ? user_id.call(account_id, event) : account_id
        return Result.new(event: event, action: NONE) if resolved.nil? || resolved.to_s.empty?

        resolved = resolved.to_s
        # A provider may define act(action, user_id), returning the action that
        # ran; the auth0 provider does, to report a block it had to fall back to.
        ran = action
        if provider.respond_to?(:act)
          ran = provider.act(action, resolved)
        elsif action == BAN
          provider.ban(resolved)
        else
          provider.revoke_sessions(resolved)
        end
        Result.new(event: event, action: ACTIONS.include?(ran) ? ran : action, user_id: resolved)
      end

      # Clerk Backend API. revoke_sessions lists the user's active sessions
      # (GET /sessions?user_id&status=active) and revokes each
      # (POST /sessions/{id}/revoke). ban is POST /users/{id}/ban, which
      # revokes every session and blocks sign-in. A 404 on any call (user or
      # session already gone) counts as done, so a repeated delivery is safe.
      #
      # base_url defaults to https://api.clerk.com/v1. http_client is an
      # optional callable (method, uri, headers, body) returning
      # [status, body]; the default uses Net::HTTP.
      def clerk(secret_key:, base_url: 'https://api.clerk.com/v1', http_client: nil)
        raise ArgumentError, 'clerk needs secret_key' if secret_key.to_s.empty?

        Clerk.new(Caller.new('clerk', base_url, "Bearer #{secret_key}", http_client))
      end

      # WorkOS User Management. revoke_sessions pages through
      # GET /user_management/users/{id}/sessions and revokes each active one
      # with POST /user_management/sessions/revoke. WorkOS has no block or ban,
      # so ban revokes the sessions and then deletes the user
      # (DELETE /user_management/users/{id}); deletion is permanent. A 404 on
      # any call (user or session already gone) counts as done, so a repeated
      # delivery is safe.
      #
      # base_url defaults to https://api.workos.com.
      def workos(api_key:, base_url: 'https://api.workos.com', http_client: nil)
        raise ArgumentError, 'workos needs api_key' if api_key.to_s.empty?

        WorkOS.new(Caller.new('workos', base_url, "Bearer #{api_key}", http_client))
      end

      # Auth0 Management API. revoke_sessions deletes every session
      # (DELETE /users/{id}/sessions) and refresh token
      # (DELETE /users/{id}/refresh-tokens). ban first sets blocked: true
      # (PATCH /users/{id}), then does the same. Pass domain (such as
      # example.eu.auth0.com; the API is https://{domain}/api/v2) or base_url.
      # token is a Management API access token with update:users,
      # delete:sessions, delete:refresh_tokens, read:device_credentials and
      # delete:device_credentials. A 404 on any call (user already gone)
      # counts as done, so a repeated delivery is safe.
      #
      # Auth0 offers the sessions and refresh-token endpoints on Enterprise
      # plans only; on other plans they answer 403 feature_not_enabled. Then
      # refresh tokens are deleted one by one through /device-credentials
      # (types refresh_token and rotating_refresh_token), which every plan
      # has. A login session cannot be ended, so revoke_sessions blocks the
      # user before deleting the refresh tokens, and act reports BAN. Unblock
      # the user in the dashboard to undo it. Any other refusal, such as 403
      # insufficient_scope, raises.
      def auth0(token:, domain: nil, base_url: nil, http_client: nil)
        raise ArgumentError, 'auth0 needs token' if token.to_s.empty?

        base = base_url || (domain.to_s.empty? ? nil : "https://#{domain}/api/v2")
        raise ArgumentError, 'auth0 needs domain or base_url' if base.nil?

        Auth0.new(Caller.new('auth0', base, "Bearer #{token}", http_client))
      end

      # A provider for an app with its own login, or for trying the handler
      # before you wire up a real one. revoke_sessions and ban each log one
      # line saying what they would do and call nothing: no request leaves
      # your process. log is any callable that takes the line; the default
      # writes it to standard error with Kernel#warn. Replace it with your own
      # provider (name, revoke_sessions and ban) once you know what revoking
      # and banning mean in your app.
      def log_only(log: nil)
        LogOnly.new(log || ->(line) { Kernel.warn(line) })
      end
    end

    # One provider HTTP client: base URL, Authorization header, error mapping.
    class Caller
      def initialize(name, base_url, authorization, http_client)
        @name = name
        @base = base_url.to_s.sub(%r{/+\z}, '')
        @authorization = authorization
        @http_client = http_client
      end

      attr_reader :name

      def call(method, path, query: nil, body: nil, allow_404: false)
        uri = URI.parse(@base + path)
        uri.query = URI.encode_www_form(query) if query && !query.empty?
        headers = { 'Authorization' => @authorization, 'Accept' => 'application/json' }
        payload = nil
        unless body.nil?
          headers['Content-Type'] = 'application/json'
          payload = JSON.generate(body)
        end
        status, text = perform(method, uri, headers, payload)
        return nil if allow_404 && status == 404
        unless status.between?(200, 299)
          raise ProviderActionError.new(@name, status, "#{@name} #{method} #{path} answered #{status}", error_code(text))
        end
        return nil if text.nil? || text.empty?

        begin
          JSON.parse(text)
        rescue JSON::ParserError
          nil
        end
      end

      private

      # The error code in a provider's error body: Auth0's errorCode, or a top-level code.
      def error_code(text)
        body = JSON.parse(text.to_s)
        return nil unless body.is_a?(Hash)

        code = body['errorCode'] || body['code']
        code.is_a?(String) && !code.empty? ? code : nil
      rescue JSON::ParserError
        nil
      end

      def perform(method, uri, headers, payload)
        return @http_client.call(method, uri, headers, payload) if @http_client

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.open_timeout = 10
        http.read_timeout = 30
        request = Net::HTTPGenericRequest.new(method, !payload.nil?, true, uri.request_uri, headers)
        request.body = payload unless payload.nil?
        response = http.start { |connection| connection.request(request) }
        [response.code.to_i, response.body.to_s]
      end
    end

    module Segment
      def self.encode(id)
        raise ArgumentError, 'user id must be a non-empty string' unless id.is_a?(String) && !id.empty?

        ERB::Util.url_encode(id)
      end

      def self.sessions(body)
        list = body.is_a?(Hash) ? body['data'] : body
        list.is_a?(Array) ? list.grep(Hash) : []
      end

      def self.active_ids(list)
        list.select { |s| s['status'] == 'active' && s['id'].is_a?(String) && !s['id'].empty? }.map { |s| s['id'] }
      end
    end

    class Clerk
      PAGE = 100

      def initialize(caller_)
        @call = caller_
      end

      def name = 'clerk'

      def revoke_sessions(user_id)
        Segment.encode(user_id)
        active = []
        (0...1000).each do |round|
          page = Segment.sessions(@call.call('GET', '/sessions', query: [['user_id', user_id], %w[status active],
                                                                         ['limit', PAGE.to_s],
                                                                         ['offset', (round * PAGE).to_s]], allow_404: true))
          active.concat(Segment.active_ids(page))
          break if page.length < PAGE
        end
        active.each { |id| @call.call('POST', "/sessions/#{ERB::Util.url_encode(id)}/revoke", allow_404: true) }
        nil
      end

      def ban(user_id)
        @call.call('POST', "/users/#{Segment.encode(user_id)}/ban", allow_404: true)
        nil
      end
    end

    class WorkOS
      def initialize(caller_)
        @call = caller_
      end

      def name = 'workos'

      def revoke_sessions(user_id)
        user = Segment.encode(user_id)
        active = []
        after = T.let(nil, T.nilable(String))
        1000.times do
          query = T.let([%w[limit 100]], T::Array[T::Array[String]])
          query << ['after', after] if after
          body = @call.call('GET', "/user_management/users/#{user}/sessions", query: query, allow_404: true)
          active.concat(Segment.active_ids(Segment.sessions(body)))
          nxt = body.is_a?(Hash) && body['list_metadata'].is_a?(Hash) ? body['list_metadata']['after'] : nil
          break unless nxt.is_a?(String) && !nxt.empty?

          after = nxt
        end
        active.each { |id| @call.call('POST', '/user_management/sessions/revoke', body: { 'session_id' => id }, allow_404: true) }
        nil
      end

      def ban(user_id)
        revoke_sessions(user_id)
        @call.call('DELETE', "/user_management/users/#{Segment.encode(user_id)}", allow_404: true)
        nil
      end
    end

    class Auth0
      PAGE = 100

      def initialize(caller_)
        @call = caller_
      end

      def name = 'auth0'

      def revoke_sessions(user_id)
        revoke(user_id)
        nil
      end

      def ban(user_id)
        user = Segment.encode(user_id)
        block(user)
        # The block already ends a session the plan cannot delete.
        delete_sessions(user)
        delete_refresh_tokens(user_id, user)
        nil
      end

      # Bans or revokes and returns the action that ran: BAN when revoking had
      # to block the user.
      def act(action, user_id)
        if action == BAN
          ban(user_id)
          return BAN
        end
        revoke(user_id)
      end

      private

      def revoke(user_id)
        user = Segment.encode(user_id)
        ended = delete_sessions(user)
        # Without the sessions API a login session survives; blocking is the only way to end it.
        block(user) unless ended
        delete_refresh_tokens(user_id, user)
        ended ? REVOKE_SESSIONS : BAN
      end

      # Auth0 answers 403 feature_not_enabled when the tenant's plan does not include an endpoint.
      def not_on_plan?(error)
        error.status == 403 && error.code == 'feature_not_enabled'
      end

      def block(user)
        @call.call('PATCH', "/users/#{user}", body: { 'blocked' => true }, allow_404: true)
      end

      # Ends every session; false when the plan has no sessions API.
      def delete_sessions(user)
        @call.call('DELETE', "/users/#{user}/sessions", allow_404: true)
        true
      rescue ProviderActionError => e
        raise unless not_on_plan?(e)

        false
      end

      def delete_refresh_tokens(user_id, user)
        begin
          @call.call('DELETE', "/users/#{user}/refresh-tokens", allow_404: true)
          return
        rescue ProviderActionError => e
          raise unless not_on_plan?(e)
        end
        # Collect every id before deleting any, so the pages do not shift underneath.
        ids = []
        %w[refresh_token rotating_refresh_token].each do |type|
          10.times do |page|
            body = @call.call('GET', '/device-credentials',
                              query: [['user_id', user_id], ['type', type], ['page', page.to_s], ['per_page', PAGE.to_s]],
                              allow_404: true)
            listed = body.is_a?(Array) ? body.grep(Hash) : []
            ids.concat(listed.map { |c| c['id'] }.select { |id| id.is_a?(String) && !id.empty? })
            break if listed.length < PAGE
          end
        end
        ids.each { |id| @call.call('DELETE', "/device-credentials/#{ERB::Util.url_encode(id)}", allow_404: true) }
      end
    end

    class LogOnly
      def initialize(log)
        @log = log
      end

      def name = 'log_only'

      def revoke_sessions(user_id)
        Segment.encode(user_id)
        @log.call("NoResponse late result (log only): would revoke every session of user #{user_id}")
        nil
      end

      def ban(user_id)
        Segment.encode(user_id)
        @log.call("NoResponse late result (log only): would ban user #{user_id} and end their sessions")
        nil
      end
    end
  end
end
