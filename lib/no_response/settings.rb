# typed: true
# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "faraday/retry"
require "sorbet-runtime"

require_relative "sdk_hooks/hooks"
require_relative "utils/retries"

module NoResponse
  extend T::Sig

  class Settings
    extend T::Sig

    # Environment policy, history and previews.

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
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::GetSettingsResponse)
    }
    def get(workspace_id:, environment:, retries: nil, timeout_ms: nil, http_headers: nil)
      # get - Read an environment's settings.
      # Read this environment retention, source selection and effective flow policies. A flow without its own thresholds inherits account_creation. Requires settings or management. Another environment answers404. Read-only and safe to retry.
      request = Models::Operations::GetSettingsRequest.new(
        workspace_id: workspace_id,
        environment: environment
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::GetSettingsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/settings/{environment}",
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
        operation_id: "getSettings",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Settings)
          result = obj
          response = Models::Operations::GetSettingsResponse.new(
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
        body: Models::Shared::SettingsRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::UpdateSettingsResponse)
    }
    def update(body:, workspace_id:, environment:, retries: nil, timeout_ms: nil, http_headers: nil)
      # update - Change an environment's settings.
      # Change named retention, source or flow settings in one transaction. Requires settings or management; changes to active policy also require policy_publish, which legacy management includes. Use expected_policy_version to reject concurrent changes and record a change_reason. Each accepted change creates a fresh version and an atomic audit event. Retention-only edits do not require policy publication authority. Flow thresholds preserve their declared ordering and bounds.
      request = Models::Operations::UpdateSettingsRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::UpdateSettingsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/settings/{environment}",
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
        operation_id: "updateSettings",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).patch(url) do |req|
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
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Settings)
          result = obj
          response = Models::Operations::UpdateSettingsResponse.new(
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
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        before_version: T.nilable(::Integer),
        limit: T.nilable(::Integer),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListPolicyHistoryResponse)
    }
    def list_history(
      workspace_id:,
      environment:,
      before_version: nil,
      limit: nil,
      retries: nil,
      timeout_ms: nil,
      http_headers: nil
    )
      # list_history - Read immutable configuration versions.
      # Read immutable configuration versions in one environment with settings or management. Follow before_version for older records.
      request = Models::Operations::ListPolicyHistoryRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        before_version: before_version,
        limit: limit
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListPolicyHistoryRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/settings/{environment}/history",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListPolicyHistoryRequest, request, nil)
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
        operation_id: "listPolicyHistory",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::PolicyHistory)
          result = obj
          response = Models::Operations::ListPolicyHistoryResponse.new(
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
        body: Models::Shared::PolicyRestoreRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::RestorePolicyResponse)
    }
    def restore(body:, workspace_id:, environment:, timeout_ms: nil, http_headers: nil)
      # restore - Restore captured settings as a new guarded version.
      # Restore a retained configuration as a fresh version with the expected current version and a change reason. Requires settings plus policy_publish, or legacy management. Restore preserves the historical record and does not undo customer enforcement.
      request = Models::Operations::RestorePolicyRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::RestorePolicyRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/settings/{environment}/restore",
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

      security = @sdk_configuration.security_source&.call

      timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      timeout ||= @sdk_configuration.timeout

      connection = @sdk_configuration.client

      hook_ctx = SDKHooks::HookContext.new(
        config: @sdk_configuration,
        base_url: base_url,
        oauth2_scopes: nil,
        operation_id: "restorePolicy",
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
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Settings)
          result = obj
          response = Models::Operations::RestorePolicyResponse.new(
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
        body: Models::Shared::PolicyPreviewRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::PreviewPolicyResponse)
    }
    def preview(body:, workspace_id:, environment:, retries: nil, timeout_ms: nil, http_headers: nil)
      # preview - Preview exact retained-score threshold transitions without side effects.
      # Compare proposed policy with bounded retained first answers, including baseline, coverage and uncertainty. Requires settings or management. This read starts no provider work and publishes no changes.
      request = Models::Operations::PreviewPolicyRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::PreviewPolicyRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/settings/{environment}/preview",
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
        operation_id: "previewPolicy",
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
      if Utils.match_status_code(http_response.status, ["200"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::PolicyPreview)
          result = obj
          response = Models::Operations::PreviewPolicyResponse.new(
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
  end
end
