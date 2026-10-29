# typed: true
# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "faraday/retry"
require "sorbet-runtime"
require "janeway"

require_relative "sdk_hooks/hooks"
require_relative "utils/retries"

module NoResponse
  extend T::Sig

  class Accounts
    extend T::Sig

    # Your accounts, each with one current risk, and their assessment history.

    sig { params(sdk_config: SDKConfiguration).void }
    def initialize(sdk_config)
      @sdk_configuration = sdk_config
    end

    sig { params(base_url: String, url_variables: T.nilable(T::Hash[Symbol, T.any(String, T::Enum)])).returns(String) }
    def get_url(base_url:, url_variables: nil)
      sd_base_url, sd_options = @sdk_configuration.get_server_details

      if base_url.nil?
        base_url = sd_base_url
      end

      if url_variables.nil?
        url_variables = sd_options
      end

      return Utils.template_url(base_url, url_variables)
    end

    sig {
      params(
        changed_since: T.nilable(::String),
        limit: T.nilable(::Integer),
        unenforced: T.nilable(T::Boolean),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountsResponse)
    }
    def list_changed(changed_since: nil, limit: nil, unenforced: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_changed - Poll the accounts whose risk changed.
      # Your accounts whose risk changed, oldest change first, each as accounts.get answers it. Every page carries next_cursor: pass it back as changed_since to read the changes made after that page; without changed_since the list starts from the oldest change. When nothing changed, items is empty and next_cursor is the cursor you sent, so poll by calling again with the latest next_cursor. An account appears again each time its risk changes, with a higher risk_version; keep the copy with the highest. unenforced=true lists only accounts with a decision other than allow for some flow and no applied enforcement at their current risk_version; such a page can hold fewer than limit items, or none, while later changes exist, so keep polling with next_cursor. Requires the history scope. Read-only and safe to retry. A tampered or foreign cursor answers 400 invalid_cursor.
      request = Models::Operations::ListAccountsRequest.new(
        changed_since: changed_since,
        limit: limit,
        unenforced: unenforced
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = "#{base_url}/v1/accounts"
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountsRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccounts",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountList)
          result = obj
          response = Models::Operations::ListAccountsResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::GetAccountResponse)
    }
    def get(account_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # get - Read an account's one current risk.
      # An account is the account_id you send with your assessments. Its current risk is the risk of its latest assessment with a decision (status complete or partial), scored as GET /v1/assessments/{assessment_id} scores that assessment, with a decision for each flow; risk.decision is the decision for the flow of that assessment. Every assessment answers with this same account. Every assessment updates its account: once an assessment completes, the account carries its risk. Requires the history scope. Read-only and safe to retry. An account with no unexpired assessment that has a decision answers 404 not_found, and a malformed account_id answers 400 invalid_request.
      request = Models::Operations::GetAccountRequest.new(
        account_id: account_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::GetAccountRequest,
        base_url,
        "/v1/accounts/{account_id}",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "getAccount",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Account)
          result = obj
          response = Models::Operations::GetAccountResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::DeleteAccountResponse)
    }
    def delete(account_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # delete - Erase an account and its history.
      # Erases the account in the environment of your key, for an erasure request from your user: every assessment of it, with its revisions, evidence and outcomes, and the identity-graph marks its outcomes set. An assessment of the account begun before the call is refused or stopped. Afterwards the account and each erased assessment answer 404 and the history is empty. When the call deleted at least one assessment, an account.deleted event goes to your verified webhook endpoints. Requires the history scope. Idempotent and safe to retry: a repeat, or an account with nothing to erase, answers 200 with assessments_deleted 0 and sends no event. The account_id can be assessed again later, as a new account.
      request = Models::Operations::DeleteAccountRequest.new(
        account_id: account_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::DeleteAccountRequest,
        base_url,
        "/v1/accounts/{account_id}",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "deleteAccount",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).delete(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountDeletion)
          result = obj
          response = Models::Operations::DeleteAccountResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        response_mode: T.nilable(Models::Shared::ResponseMode),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountAssessmentsResponse)
    }
    def list_assessments(
      account_id:,
      limit: nil,
      cursor: nil,
      response_mode: nil,
      retries: nil,
      timeout_ms: nil,
      http_headers: nil
    )
      # list_assessments - Page through one account's unexpired assessments.
      # The account's history: the same page as POST /v1/assessments/query for this account_id, newest first, each at its latest assessment_version. Requires the history scope. Read-only and safe to retry. An account with no assessments answers 200 with empty items. The cursor is opaque and bound to your workspace and the account; a tampered or expired cursor answers 400 invalid_cursor. response_mode=detailed needs the detailed scope. Each item's identifiers holds the identifiers its assessment was sent, exactly as received. The account_id travels in the URL; use POST /v1/assessments/query to keep it out of access logs.
      request = Models::Operations::ListAccountAssessmentsRequest.new(
        account_id: account_id,
        limit: limit,
        cursor: cursor,
        response_mode: response_mode
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListAccountAssessmentsRequest,
        base_url,
        "/v1/accounts/{account_id}/assessments",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountAssessmentsRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccountAssessments",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AssessmentList)
          result = obj
          response = Models::Operations::ListAccountAssessmentsResponse.new(
            result: result,
            headers: http_response.headers
          )
          sdk = self

          response.next_page = proc do
            next_cursor = Janeway.enum_for("$.next_cursor", JSON.parse(response_data)).search
            if next_cursor.nil?
              next nil
            else
              next_cursor = next_cursor[0]
              if next_cursor.nil?
                next nil
              end
            end

            sdk.list_assessments(
              account_id: request.account_id,
              limit: request.limit,
              cursor: next_cursor,
              response_mode: request.response_mode,
              http_headers: http_headers
            )
          end

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        body: Models::Shared::EnforcementRequest,
        account_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::RecordEnforcementResponse)
    }
    def record_enforcement(body:, account_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # record_enforcement - Record what you did to an account in your identity provider.
      # Records what you did to the account in your identity provider for one flow's decision at one risk_version: the action (or none), the account's state before it, the provider and whether it was applied or failed. It is your action, not an outcome, and it leaves the account's risk unchanged. A record is kept once per account, risk_version, flow and action: the first report answers 201, and a repeat answers 200 with the stored record unchanged, so retries are safe without an Idempotency-Key. An applied report after a failed one replaces the failed record, keeping its id and created_at, and answers 201. A risk_version older than the account's current one is accepted and stored, but only an applied record at the current risk_version takes the account out of listChanged with unenforced=true; a newer one answers 409 risk_version_ahead. An account with no current risk answers 404 not_found. error_code is allowed only with status failed. Requires the history scope.
      request = Models::Operations::RecordEnforcementRequest.new(
        account_id: account_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::RecordEnforcementRequest,
        base_url,
        "/v1/accounts/{account_id}/enforcements",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      req_content_type, data, form = Utils.serialize_request_body(request, false, false, :body, :json)
      headers["content-type"] = req_content_type
      raise StandardError, "request body is required" if data.nil? && form.nil?

      if form && !form.empty?
        body = Utils.encode_form(form)
      elsif Utils.match_content_type(req_content_type, "application/x-www-form-urlencoded")
        body = URI.encode_www_form(T.cast(data, T::Hash[Symbol, Object]))
      else
        body = data
      end

      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "recordEnforcement",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).post(url) do |req|
          req.body = body
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200", "201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Enforcement)
          result = obj
          response = Models::Operations::RecordEnforcementResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountEnforcementsResponse)
    }
    def list_enforcements(account_id:, limit: nil, cursor: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_enforcements - Page through account enforcements
      # List retained enforcement reports for one account with an authenticated cursor.
      request = Models::Operations::ListAccountEnforcementsRequest.new(
        account_id: account_id,
        limit: limit,
        cursor: cursor
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListAccountEnforcementsRequest,
        base_url,
        "/v1/accounts/{account_id}/enforcements",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountEnforcementsRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccountEnforcements",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountEnforcementList)
          result = obj
          response = Models::Operations::ListAccountEnforcementsResponse.new(
            result: result,
            headers: http_response.headers
          )
          sdk = self

          response.next_page = proc do
            next_cursor = Janeway.enum_for("$.next_cursor", JSON.parse(response_data)).search
            if next_cursor.nil?
              next nil
            else
              next_cursor = next_cursor[0]
              if next_cursor.nil?
                next nil
              end
            end

            sdk.list_enforcements(
              account_id: request.account_id,
              limit: request.limit,
              cursor: next_cursor,
              http_headers: http_headers
            )
          end

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        body: Models::Shared::AccountOutcomeRequest,
        account_id: ::String,
        idempotency_key: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::RecordAccountOutcomeResponse)
    }
    def record_outcome(body:, account_id:, idempotency_key: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # record_outcome - Record or correct an account outcome
      # Record a factual report, not an enforcement action. A known outcome replaces the effective report. unknown alone records uncertainty without changing it; unknown with supersedes explicitly retracts it. supersedes must name the current effective report or the request answers 409 outcome_conflict. Reports remain append-only. Idempotency-Key is required. observed_at defaults to receipt time and cannot be over five minutes ahead.
      request = Models::Operations::RecordAccountOutcomeRequest.new(
        account_id: account_id,
        body: body,
        idempotency_key: idempotency_key
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::RecordAccountOutcomeRequest,
        base_url,
        "/v1/accounts/{account_id}/outcomes",
        request
      )
      headers = Utils.get_headers(request)
      headers = T.cast(headers, T::Hash[String, String])
      req_content_type, data, form = Utils.serialize_request_body(request, false, false, :body, :json)
      headers["content-type"] = req_content_type
      raise StandardError, "request body is required" if data.nil? && form.nil?

      if form && !form.empty?
        body = Utils.encode_form(form)
      elsif Utils.match_content_type(req_content_type, "application/x-www-form-urlencoded")
        body = URI.encode_www_form(T.cast(data, T::Hash[Symbol, Object]))
      else
        body = data
      end

      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "recordAccountOutcome",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).post(url) do |req|
          req.body = body
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["202"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountOutcome)
          result = obj
          response = Models::Operations::RecordAccountOutcomeResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountOutcomesResponse)
    }
    def list_outcomes(account_id:, limit: nil, cursor: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_outcomes - List retained account feedback
      # List retained account reports, newest first. The page-level effective outcome id names the current report. Each receipt preserves the effective report and risk version from its original write. Page with the returned cursor.
      request = Models::Operations::ListAccountOutcomesRequest.new(
        account_id: account_id,
        limit: limit,
        cursor: cursor
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListAccountOutcomesRequest,
        base_url,
        "/v1/accounts/{account_id}/outcomes",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountOutcomesRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccountOutcomes",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountOutcomePage)
          result = obj
          response = Models::Operations::ListAccountOutcomesResponse.new(
            result: result,
            headers: http_response.headers
          )
          sdk = self

          response.next_page = proc do
            next_cursor = Janeway.enum_for("$.next_cursor", JSON.parse(response_data)).search
            if next_cursor.nil?
              next nil
            else
              next_cursor = next_cursor[0]
              if next_cursor.nil?
                next nil
              end
            end

            sdk.list_outcomes(
              account_id: request.account_id,
              limit: request.limit,
              cursor: next_cursor,
              http_headers: http_headers
            )
          end

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        risk_version: ::Integer,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::GetAccountDecisionResponse)
    }
    def retrieve_decision(account_id:, risk_version:, retries: nil, timeout_ms: nil, http_headers: nil)
      # retrieve_decision - Retrieve an exact historical account decision
      # Retrieve the account decision at one recorded risk version. The answer uses the original assessment and account-specific risk inputs. Earlier versions that were not captured return 404. The assessment version, policy version and account calculation version identify the decision.
      request = Models::Operations::GetAccountDecisionRequest.new(
        account_id: account_id,
        risk_version: risk_version
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::GetAccountDecisionRequest,
        base_url,
        "/v1/accounts/{account_id}/decisions/{risk_version}",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "getAccountDecision",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountDecisionSnapshot)
          result = obj
          response = Models::Operations::GetAccountDecisionResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        body: Models::Shared::CredentialRequest,
        account_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::AssociateCredentialResponse)
    }
    def associate_credential(body:, account_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # associate_credential - Associate a customer-issued API key
      # Associate the SHA-256 of a high-entropy key issued by your service. Send the hash instead of the key. Repeating a hash returns its original association, including its retirement state. A hash associated with another account returns a conflict.
      request = Models::Operations::AssociateCredentialRequest.new(
        account_id: account_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::AssociateCredentialRequest,
        base_url,
        "/v1/accounts/{account_id}/credentials",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      req_content_type, data, form = Utils.serialize_request_body(request, false, false, :body, :json)
      headers["content-type"] = req_content_type
      raise StandardError, "request body is required" if data.nil? && form.nil?

      if form && !form.empty?
        body = Utils.encode_form(form)
      elsif Utils.match_content_type(req_content_type, "application/x-www-form-urlencoded")
        body = URI.encode_www_form(T.cast(data, T::Hash[Symbol, Object]))
      else
        body = data
      end

      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "associateCredential",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).post(url) do |req|
          req.body = body
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200", "201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::CredentialAssociation)
          result = obj
          response = Models::Operations::AssociateCredentialResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountCredentialsResponse)
    }
    def list_credentials(account_id:, limit: nil, cursor: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_credentials - List issued credential associations
      # Retained credential associations, ordered by id. Page with the authenticated cursor. Associations are removed on account erasure.
      request = Models::Operations::ListAccountCredentialsRequest.new(
        account_id: account_id,
        limit: limit,
        cursor: cursor
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListAccountCredentialsRequest,
        base_url,
        "/v1/accounts/{account_id}/credentials",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountCredentialsRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccountCredentials",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::CredentialPage)
          result = obj
          response = Models::Operations::ListAccountCredentialsResponse.new(
            result: result,
            headers: http_response.headers
          )
          sdk = self

          response.next_page = proc do
            next_cursor = Janeway.enum_for("$.next_cursor", JSON.parse(response_data)).search
            if next_cursor.nil?
              next nil
            else
              next_cursor = next_cursor[0]
              if next_cursor.nil?
                next nil
              end
            end

            sdk.list_credentials(
              account_id: request.account_id,
              limit: request.limit,
              cursor: next_cursor,
              http_headers: http_headers
            )
          end

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        credential_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::RetireAccountCredentialResponse)
    }
    def retire_credential(account_id:, credential_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # retire_credential - Retire an issued credential association
      # Mark this association retired, idempotently. This does not revoke the actual key. Requires delete scope.
      request = Models::Operations::RetireAccountCredentialRequest.new(
        account_id: account_id,
        credential_id: credential_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::RetireAccountCredentialRequest,
        base_url,
        "/v1/accounts/{account_id}/credentials/{credential_id}",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "retireAccountCredential",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).delete(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::CredentialAssociation)
          result = obj
          response = Models::Operations::RetireAccountCredentialResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        response_mode: T.nilable(Models::Shared::ResponseMode),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ExportAccountResponse)
    }
    def export(account_id:, response_mode: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # export - Export an account
      # Retrieve one consistent snapshot of retained customer-accessible records, including assessment revisions, account decisions, feedback, key associations, enforcements and request diagnostics. Each assessment revision's detail.identifiers holds the identifiers that assessment was sent, exactly as received. Secrets, restricted source information, other customers' data and legacy free-text notes are excluded. The same standard/detailed permissions apply. An export exceeding 10000 records or 8 MiB returns export_too_large without a partial result. Historical decisions that were not captured are identified as an exclusion.
      request = Models::Operations::ExportAccountRequest.new(
        account_id: account_id,
        response_mode: response_mode
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ExportAccountRequest,
        base_url,
        "/v1/accounts/{account_id}/export",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ExportAccountRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "exportAccount",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountExport)
          result = obj
          response = Models::Operations::ExportAccountResponse.new(
            result: result,
            headers: http_response.headers
          )

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end

    sig {
      params(
        account_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListAccountDecisionsResponse)
    }
    def list_decisions(account_id:, limit: nil, cursor: nil, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_decisions - Page through recorded account decisions
      # List retained immutable risk decisions for one account with an authenticated cursor.
      request = Models::Operations::ListAccountDecisionsRequest.new(
        account_id: account_id,
        limit: limit,
        cursor: cursor
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListAccountDecisionsRequest,
        base_url,
        "/v1/accounts/{account_id}/decisions",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListAccountDecisionsRequest, request, nil)
      headers["Accept"] = "application/json"
      headers["user-agent"] = @sdk_configuration.user_agent
      retries ||= @sdk_configuration.retry_config
      retries ||= Utils::RetryConfig.new(
        backoff: Utils::BackoffStrategy.new(
          exponent: 2.0,
          initial_interval: 500,
          max_elapsed_time: 30_000,
          max_interval: 8000
        ),
        retry_connection_errors: true,
        strategy: "backoff"
      )
      retry_options = retries.to_faraday_retry_options(initial_time: Time.now)
      retry_options[:retry_statuses] = [408, 429, 500, 501, 502, 503, 504, 505]

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client.dup
      connection.use(Utils::RetryMiddleware, retry_options)

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "listAccountDecisions",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).get(url) do |req|
          req.headers.merge!(headers)
          req.options.timeout = timeout unless timeout.nil?
          req.params = query_params
          Utils.configure_request_security(req, security)
          http_headers&.each do |key, value|
            req.headers[key.to_s] = value
          end

          @sdk_configuration.hooks.before_request(
            hook_ctx: SDKHooks::BeforeRequestHookContext.new(
              hook_ctx: hook_ctx
            ),
            request: req
          )
        end

      rescue StandardError => e
        error = e
      ensure
        if http_response.nil? || Utils.error_status?(http_response.status)
          http_response = @sdk_configuration.hooks.after_error(
            error: error,
            hook_ctx: SDKHooks::AfterErrorHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        else
          http_response = @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
        end

        if http_response.nil?
          raise error if !error.nil?
          raise "no response"
        end
      end

      content_type = http_response.headers.fetch("Content-Type", "application/octet-stream")
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::AccountDecisionList)
          result = obj
          response = Models::Operations::ListAccountDecisionsResponse.new(
            result: result,
            headers: http_response.headers
          )
          sdk = self

          response.next_page = proc do
            next_cursor = Janeway.enum_for("$.next_cursor", JSON.parse(response_data)).search
            if next_cursor.nil?
              next nil
            else
              next_cursor = next_cursor[0]
              if next_cursor.nil?
                next nil
              end
            end

            sdk.list_decisions(
              account_id: request.account_id,
              limit: request.limit,
              cursor: next_cursor,
              http_headers: http_headers
            )
          end

          return response
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["400"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::BadRequestError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["401"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::AuthenticationError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["403"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::PermissionDeniedError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["404"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::NotFoundError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["409"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::ConflictError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["429"])
        if Utils.match_content_type(content_type, "application/problem+json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Errors::RateLimitError)
          raise obj
        else
          raise(
            ::NoResponse::Models::Errors::APIStatusError.new(
              status_code: http_response.status,
              body: http_response.env.response_body,
              raw_response: http_response
            ),
            "Unknown content type received"
          )
        end
      elsif Utils.match_status_code(http_response.status, ["4XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      elsif Utils.match_status_code(http_response.status, ["5XX"])
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "API error occurred"
        )
      else
        raise(
          ::NoResponse::Models::Errors::APIStatusError.new(
            status_code: http_response.status,
            body: http_response.env.response_body,
            raw_response: http_response
          ),
          "Unknown status code received"
        )

      end
    end
  end
end
