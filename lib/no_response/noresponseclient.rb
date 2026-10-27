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

  class NoResponseClient
    extend T::Sig

    attr_accessor :assessments, :accounts, :key_usage, :keys, :integrations, :webhook_endpoints, :settings, :lists

    # Instantiates the SDK, configuring it with the provided parameters.
    #
    # @param client [Faraday::Connection, nil] The faraday HTTP client to use for all operations
    # @param retry_config [::NoResponse::Utils::RetryConfig, nil] The retry configuration to use for all operations
    # @param timeout_ms [Integer, nil] Request timeout in milliseconds for all operations
    # @param security [Models::Shared::Security, nil] The security details required for authentication
    # @param security_source [Proc{|| Models::Shared::Security, nil}] A function that returns security details required for authentication
    # @param server_idx [Integer, nil] The index of the server to use for all operations
    # @param server_url [String, nil] The server URL to use for all operations
    # @param url_params [Hash{Symbol => String}, nil] Parameters to optionally template the server URL with
    sig do
      params(
        client: T.nilable(Faraday::Connection),
        retry_config: T.nilable(::NoResponse::Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        api_key: T.nilable(::String),
        security_source: T.nilable(T.proc.returns(Models::Shared::Security)),
        server_idx: T.nilable(Integer),
        server_url: T.nilable(String),
        url_params: T.nilable(T::Hash[Symbol, String])
      )
        .void
    end
    def initialize(
      client: nil,
      retry_config: nil,
      timeout_ms: nil,
      api_key: nil,
      security_source: nil,
      server_idx: nil,
      server_url: nil,
      url_params: nil
    )

      connection_options = {
        request: {
          params_encoder: Faraday::FlatParamsEncoder
        }
      }
      connection_options[:request][:timeout] = (timeout_ms.to_f / 1000) unless timeout_ms.nil?

      client ||= Faraday.new(**connection_options) do |f|
        f.request(:multipart, {flat_encode: true})
        # f.response :logger, nil, { headers: true, bodies: true, errors: true }
      end

      if !server_url.nil?
        if !url_params.nil?
          server_url = Utils.template_url(server_url, url_params)
        end
      end

      server_idx = 0 if server_idx.nil?
      hooks = SDKHooks::Hooks.new
      @sdk_configuration = SDKConfiguration.new(
        client,
        hooks,
        retry_config,
        timeout_ms,
        api_key,
        security_source,
        server_url,
        server_idx
      )
      @sdk_configuration = hooks.sdk_init(config: @sdk_configuration)
      init_sdks
    end

    sig { void }
    def init_sdks
      @assessments = Assessments.new(@sdk_configuration)
      @accounts = Accounts.new(@sdk_configuration)
      @key_usage = KeyUsage.new(@sdk_configuration)
      @keys = Keys.new(@sdk_configuration)
      @integrations = Integrations.new(@sdk_configuration)
      @webhook_endpoints = WebhookEndpoints.new(@sdk_configuration)
      @settings = Settings.new(@sdk_configuration)
      @lists = Lists.new(@sdk_configuration)
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

  end
end
