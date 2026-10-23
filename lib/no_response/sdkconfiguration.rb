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

  SERVERS = T.let(
    [
      # 1 - Production
      "https://api.noresponse.org"
    ].freeze,
    T::Array[String]
  )
  # Contains the list of servers available to the SDK

  class SDKConfiguration
    extend T::Sig

    sig { returns(T.nilable(Faraday::Connection)) }
    attr_accessor :client

    sig { returns(::NoResponse::SDKHooks::Hooks) }
    attr_accessor :hooks

    sig { returns(T.nilable(::NoResponse::Utils::RetryConfig)) }
    attr_accessor :retry_config

    sig { returns(T.nilable(Float)) }
    attr_accessor :timeout

    sig { returns(T.nilable(T.proc.returns(T.nilable(Models::Shared::Security)))) }
    attr_accessor :security_source

    sig { returns(T.nilable(String)) }
    attr_accessor :server_url

    sig { returns(T.nilable(Integer)) }
    attr_accessor :server_idx

    sig { returns(String) }
    attr_accessor :language

    sig { returns(String) }
    attr_accessor :openapi_doc_version

    sig { returns(String) }
    attr_accessor :sdk_version

    sig { returns(String) }
    attr_accessor :gen_version

    sig { returns(String) }
    attr_accessor :user_agent

    sig do
      params(
        client: T.nilable(Faraday::Connection),
        hooks: ::NoResponse::SDKHooks::Hooks,
        retry_config: T.nilable(::NoResponse::Utils::RetryConfig),
        timeout_ms: T.nilable(Integer),
        api_key: T.nilable(::String),
        security_source: T.nilable(T.proc.returns(Models::Shared::Security)),
        server_url: T.nilable(String),
        server_idx: T.nilable(Integer)
      )
        .void
    end
    def initialize(client, hooks, retry_config, timeout_ms, api_key, security_source, server_url, server_idx)
      @client = client
      @hooks = hooks
      @retry_config = retry_config
      @server_url = server_url
      @timeout = (timeout_ms.to_f / 1000) unless timeout_ms.nil?
      @server_idx = server_idx.nil? ? 0 : server_idx
      if @server_idx.negative? || @server_idx >= SERVERS.length
        raise StandardError, "Invalid server index #{server_idx}"
      end

      if !security_source.nil?
        @security_source = security_source
      elsif !api_key.nil?
        @security_source = -> { Models::Shared::Security.new(api_key: api_key) }
      elsif !ENV.fetch("NORESPONSE_API_KEY", "").empty?
        env_security = Models::Shared::Security.new(api_key: ENV.fetch("NORESPONSE_API_KEY"))
        @security_source = -> { env_security }
      end

      @language = "ruby"
      @openapi_doc_version = "1"
      @sdk_version = "3.0.1"
      @gen_version = "internal"
      @user_agent = "noresponse-sdk/ruby 3.0.1 internal 1 noresponse"
    end

    sig { returns([String, T::Hash[Symbol, String]]) }
    def get_server_details
      return [@server_url.delete_suffix("/"), {}] if !@server_url.nil?
      @server_idx = T.must(@server_idx)
      [T.must(SERVERS[@server_idx]), {}]
    end
  end
end
