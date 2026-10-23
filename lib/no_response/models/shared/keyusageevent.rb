# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One request made with an issued key. An event whose ip is not a public address, or whose occurred_at is more than 24 hours old or more than 5 minutes ahead, is counted in ignored and adds nothing.
      class KeyUsageEvent
        extend T::Sig
        include Crystalline::MetadataFields

        # SHA-256 of the issued key's UTF-8 bytes, as 64 lower-case hex characters: the value sent as issued_credential.sha256 when the account was assessed. Each SDK's issued-credential helper computes it.
        field(
          :key_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_sha256"), required: true}}
        )
        # The client IP address the request came from, IPv4 or IPv6, as your server saw it. Stored only as a keyed digest and its country.
        field :ip, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ip"), required: true}}
        # When the request was made.
        field(
          :occurred_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("occurred_at"), required: true}}
        )
        # The request's User-Agent header, at most 512 characters. Stored only as a keyed digest.
        field(
          :user_agent,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("user_agent")}}
        )
        # The model or product the request used, such as gpt-4o-mini. Stored only as a keyed digest.
        field(
          :model,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("model")}}
        )
        # Input tokens the request consumed.
        field(
          :input_tokens,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("input_tokens")}}
        )
        # Output tokens the request produced.
        field(
          :output_tokens,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("output_tokens")}}
        )
        # The share of requests your sampler records, when it records only some: 0.1 means this event stands for 10 requests. Request and token totals are weighted by its inverse. Distinct IP and country counts see only the events sent.
        field(
          :sample_rate,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sample_rate")}}
        )

        sig {
          params(
            key_sha256: ::String,
            ip: ::String,
            occurred_at: ::String,
            user_agent: T.nilable(::String),
            model: T.nilable(::String),
            input_tokens: T.nilable(::Integer),
            output_tokens: T.nilable(::Integer),
            sample_rate: T.nilable(::Float)
          )
            .void
        }
        def initialize(
          key_sha256:,
          ip:,
          occurred_at:,
          user_agent: nil,
          model: nil,
          input_tokens: nil,
          output_tokens: nil,
          sample_rate: 1.0
        )
          @key_sha256 = key_sha256
          @ip = ip
          @occurred_at = occurred_at
          @user_agent = user_agent
          @model = model
          @input_tokens = input_tokens
          @output_tokens = output_tokens
          @sample_rate = sample_rate
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @key_sha256 == other.key_sha256
          return false unless @ip == other.ip
          return false unless @occurred_at == other.occurred_at
          return false unless @user_agent == other.user_agent
          return false unless @model == other.model
          return false unless @input_tokens == other.input_tokens
          return false unless @output_tokens == other.output_tokens
          return false unless @sample_rate == other.sample_rate
          true
        end
      end
    end
  end
end
