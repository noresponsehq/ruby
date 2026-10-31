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

  class Reviews
    extend T::Sig

    # Collaborative review cases, comments and linked subjects.

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
        request: Models::Operations::ListReviewsRequest,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListReviewsResponse)
    }
    def list(request:, retries: nil, timeout_ms: nil, http_headers: nil)
      # list - List retained account reviews.
      # List retained investigation reviews using filters and an authenticated cursor. Use reviews.query to filter by account_id in a JSON body. All filters are bound into the cursor.
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListReviewsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListReviewsRequest, request, nil)
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
        operation_id: "listReviews",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewList)
          result = obj
          response = Models::Operations::ListReviewsResponse.new(
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

            sdk.list(
              request: Models::Operations::ListReviewsRequest.new(
                workspace_id: request.workspace_id,
                environment: request.environment,
                limit: request.limit,
                cursor: next_cursor,
                status: request.status,
                priority: request.priority,
                assignee: request.assignee,
                unassigned: request.unassigned,
                assignee_principal_id: request.assignee_principal_id
              ),
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
        body: Models::Shared::ReviewCreateRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::CreateReviewResponse)
    }
    def create(body:, workspace_id:, environment:, timeout_ms: nil, http_headers: nil)
      # create - Open a review for a retained account.
      # Open a review for one account. An account can have one active review in its environment.
      request = Models::Operations::CreateReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::CreateReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}",
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
        operation_id: "createReview",
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
      if Utils.match_status_code(http_response.status, ["201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Review)
          result = obj
          response = Models::Operations::CreateReviewResponse.new(
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
        review_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::GetReviewResponse)
    }
    def get(workspace_id:, environment:, review_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # get - Read an account review.
      # Read a retained review and its current version.
      request = Models::Operations::GetReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::GetReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}",
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
        operation_id: "getReview",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Review)
          result = obj
          response = Models::Operations::GetReviewResponse.new(
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
        body: Models::Shared::ReviewUpdateRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        review_id: ::String,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::UpdateReviewResponse)
    }
    def update(body:, workspace_id:, environment:, review_id:, timeout_ms: nil, http_headers: nil)
      # update - Assign, prioritize or reopen a guarded review.
      # Change review status, priority or assignment after checking the expected version.
      request = Models::Operations::UpdateReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::UpdateReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}",
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
        operation_id: "updateReview",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Review)
          result = obj
          response = Models::Operations::UpdateReviewResponse.new(
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
        body: Models::Shared::ReviewResolveRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        review_id: ::String,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ResolveReviewResponse)
    }
    def resolve(body:, workspace_id:, environment:, review_id:, timeout_ms: nil, http_headers: nil)
      # resolve - Resolve a review against an exact account risk version.
      # Resolve a review against the exact current review and account decision versions. A resolution does not report a factual outcome or execute enforcement.
      request = Models::Operations::ResolveReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ResolveReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/resolve",
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
        operation_id: "resolveReview",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Review)
          result = obj
          response = Models::Operations::ResolveReviewResponse.new(
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
        review_id: ::String,
        limit: T.nilable(::Integer),
        cursor: T.nilable(::String),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListReviewCommentsResponse)
    }
    def list_comments(
      workspace_id:,
      environment:,
      review_id:,
      limit: nil,
      cursor: nil,
      retries: nil,
      timeout_ms: nil,
      http_headers: nil
    )
      # list_comments - Read retained review comments.
      # Page through retained review comments.
      request = Models::Operations::ListReviewCommentsRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        limit: limit,
        cursor: cursor
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListReviewCommentsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/comments",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListReviewCommentsRequest, request, nil)
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
        operation_id: "listReviewComments",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewCommentList)
          result = obj
          response = Models::Operations::ListReviewCommentsResponse.new(
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

            sdk.list_comments(
              workspace_id: request.workspace_id,
              environment: request.environment,
              review_id: request.review_id,
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
        body: Models::Shared::ReviewCommentRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        review_id: ::String,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::CommentReviewResponse)
    }
    def comment(body:, workspace_id:, environment:, review_id:, timeout_ms: nil, http_headers: nil)
      # comment - Append a comment against the current review version.
      # Append a comment after checking the expected review version.
      request = Models::Operations::CommentReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::CommentReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/comments",
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
        operation_id: "commentReview",
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
      if Utils.match_status_code(http_response.status, ["201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewComment)
          result = obj
          response = Models::Operations::CommentReviewResponse.new(
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
        review_id: ::String,
        limit: T.nilable(::Integer),
        before_version: T.nilable(::Integer),
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListReviewResolutionsResponse)
    }
    def list_resolutions(
      workspace_id:,
      environment:,
      review_id:,
      limit: nil,
      before_version: nil,
      retries: nil,
      timeout_ms: nil,
      http_headers: nil
    )
      # list_resolutions - Read immutable review resolution history.
      # Page through immutable review resolutions.
      request = Models::Operations::ListReviewResolutionsRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        limit: limit,
        before_version: before_version
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListReviewResolutionsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/resolutions",
        request
      )
      headers = {}
      headers = T.cast(headers, T::Hash[String, String])
      query_params = Utils.get_query_params(Models::Operations::ListReviewResolutionsRequest, request, nil)
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
        operation_id: "listReviewResolutions",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewResolutionList)
          result = obj
          response = Models::Operations::ListReviewResolutionsResponse.new(
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
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListReviewViewsResponse)
    }
    def list_views(workspace_id:, environment:, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_views - List your private and shared review filters.
      # List private and shared saved review filters visible to you.
      request = Models::Operations::ListReviewViewsRequest.new(
        workspace_id: workspace_id,
        environment: environment
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListReviewViewsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/review_views/{environment}",
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
        operation_id: "listReviewViews",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewViewList)
          result = obj
          response = Models::Operations::ListReviewViewsResponse.new(
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
        body: Models::Shared::ReviewViewRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::CreateReviewViewResponse)
    }
    def create_view(body:, workspace_id:, environment:, timeout_ms: nil, http_headers: nil)
      # create_view - Save a tenant-local review filter.
      # Save a private or shared review filter.
      request = Models::Operations::CreateReviewViewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::CreateReviewViewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/review_views/{environment}",
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
        operation_id: "createReviewView",
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
      if Utils.match_status_code(http_response.status, ["201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewView)
          result = obj
          response = Models::Operations::CreateReviewViewResponse.new(
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
        body: Models::Shared::ReviewViewRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        view_id: ::String,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::UpdateReviewViewResponse)
    }
    def update_view(body:, workspace_id:, environment:, view_id:, timeout_ms: nil, http_headers: nil)
      # update_view - Replace your saved filter with optimistic concurrency.
      # Update your saved review filter after checking its expected version.
      request = Models::Operations::UpdateReviewViewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        view_id: view_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::UpdateReviewViewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/review_views/{environment}/{view_id}",
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
        operation_id: "updateReviewView",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewView)
          result = obj
          response = Models::Operations::UpdateReviewViewResponse.new(
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
        body: Models::Shared::ReviewViewDeleteRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        view_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::DeleteReviewViewResponse)
    }
    def delete_view(body:, workspace_id:, environment:, view_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # delete_view - Delete your saved filter with optimistic concurrency.
      # Delete your saved review filter after checking its expected version.
      request = Models::Operations::DeleteReviewViewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        view_id: view_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::DeleteReviewViewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/review_views/{environment}/{view_id}",
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

      headers["Accept"] = "application/problem+json"
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
        operation_id: "deleteReviewView",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).delete(url) do |req|
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
      if Utils.match_status_code(http_response.status, ["204"])
        @sdk_configuration.hooks.after_success(
          hook_ctx: SDKHooks::AfterSuccessHookContext.new(
            hook_ctx: hook_ctx
          ),
          response: http_response
        )
        return Models::Operations::DeleteReviewViewResponse.new(
          headers: http_response.headers
        )
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
        review_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ExportReviewResponse)
    }
    def export(workspace_id:, environment:, review_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # export - Export an account review
      # Export retained review details, comments, resolutions and linked subjects. Requires current reviews.read and exports.read; API keys need management together with exports, history or audit_manage. The audit event commits before any bytes are returned. Oversized exports are refused without truncation; use the bounded collection APIs.
      request = Models::Operations::ExportReviewRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ExportReviewRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/export",
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
        operation_id: "exportReview",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Export)
          result = obj
          response = Models::Operations::ExportReviewResponse.new(
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
        review_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::ListReviewSubjectsResponse)
    }
    def list_subjects(workspace_id:, environment:, review_id:, retries: nil, timeout_ms: nil, http_headers: nil)
      # list_subjects - List retained subjects linked to a review.
      # List retained subjects linked to this review. A link supplies investigation context and does not prove a relationship or change account risk.
      request = Models::Operations::ListReviewSubjectsRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::ListReviewSubjectsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects",
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
        operation_id: "listReviewSubjects",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewSubjectList)
          result = obj
          response = Models::Operations::ListReviewSubjectsResponse.new(
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
        body: Models::Shared::ReviewSubjectRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        review_id: ::String,
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::AddReviewSubjectResponse)
    }
    def add_subject(body:, workspace_id:, environment:, review_id:, timeout_ms: nil, http_headers: nil)
      # add_subject - Link retained tenant-local evidence to an investigation.
      # Link an account, exact assessment revision or issued-key association within this environment. Supply the expected review version. A review permits 100 links. Erasure removes links to erased subjects. This action records context without creating feedback or enforcement.
      request = Models::Operations::AddReviewSubjectRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::AddReviewSubjectRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects",
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
        operation_id: "addReviewSubject",
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
      if Utils.match_status_code(http_response.status, ["201"])
        if Utils.match_content_type(content_type, "application/json")
          @sdk_configuration.hooks.after_success(
            hook_ctx: SDKHooks::AfterSuccessHookContext.new(
              hook_ctx: hook_ctx
            ),
            response: http_response
          )
          response_data = http_response.env.response_body
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewSubjectChange)
          result = obj
          response = Models::Operations::AddReviewSubjectResponse.new(
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
        body: Models::Shared::ReviewViewDeleteRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        review_id: ::String,
        subject_id: ::String,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::DeleteReviewSubjectResponse)
    }
    def delete_subject(
      body:,
      workspace_id:,
      environment:,
      review_id:,
      subject_id:,
      retries: nil,
      timeout_ms: nil,
      http_headers: nil
    )
      # delete_subject - Remove a linked subject using the current review version.
      # Remove a subject link with the expected review version. The linked account, assessment or key association remains unchanged.
      request = Models::Operations::DeleteReviewSubjectRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        review_id: review_id,
        subject_id: subject_id,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::DeleteReviewSubjectRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects/{subject_id}",
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
        operation_id: "deleteReviewSubject",
        security_source: @sdk_configuration.security_source
      )

      error = T.let(nil, T.nilable(StandardError))
      http_response = T.let(nil, T.nilable(Faraday::Response))

      begin
        http_response = T.must(connection).delete(url) do |req|
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::Review)
          result = obj
          response = Models::Operations::DeleteReviewSubjectResponse.new(
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
        body: Models::Shared::ReviewQueryRequest,
        workspace_id: ::String,
        environment: Models::Shared::KeyEnvironment,
        retries: T.nilable(Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        http_headers: T.nilable(T::Hash[T.any(String, Symbol), String])
      )
        .returns(Models::Operations::QueryReviewsResponse)
    }
    def query(body:, workspace_id:, environment:, retries: nil, timeout_ms: nil, http_headers: nil)
      # query - Query retained reviews without identifiers in URLs.
      # Query retained investigation reviews using a JSON body, including an exact account_id filter. All filters are bound into the cursor.
      request = Models::Operations::QueryReviewsRequest.new(
        workspace_id: workspace_id,
        environment: environment,
        body: body
      )
      url, params = @sdk_configuration.get_server_details
      base_url = Utils.template_url(url, params)
      url = Utils.generate_url(
        Models::Operations::QueryReviewsRequest,
        base_url,
        "/v1/workspaces/{workspace_id}/reviews/{environment}/query",
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
        operation_id: "queryReviews",
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
          obj = Crystalline.unmarshal_json(JSON.parse(response_data), Models::Shared::ReviewList)
          result = obj
          response = Models::Operations::QueryReviewsResponse.new(
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
