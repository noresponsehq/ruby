# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Errors
      # HTTP 429 problem document.
      class RateLimitError < StandardError
        extend T::Sig
        include Crystalline::MetadataFields

        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}

        field(
          :title,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("title"), required: true}}
        )

        field(
          :detail,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("detail"), required: true}}
        )
        # Machine codes an HTTP 429 answer can carry.
        field(
          :code,
          Models::Shared::RateLimitErrorCode,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("code"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RateLimitErrorCode, false)
            }
          }
        )

        field(
          :request_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id"), required: true}}
        )

        field(
          :status,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("status"), required: true}}
        )

        field(
          :instance,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("instance")}}
        )

        field(
          :invalid_params,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::ProblemInvalidParam)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("invalid_params")}}
        )

        sig {
          params(
            type: ::String,
            title: ::String,
            detail: ::String,
            code: Models::Shared::RateLimitErrorCode,
            request_id: ::String,
            status: ::Integer,
            instance: T.nilable(::String),
            invalid_params: T.nilable(T::Array[Models::Shared::ProblemInvalidParam])
          )
            .void
        }
        def initialize(type:, title:, detail:, code:, request_id:, status: 429, instance: nil, invalid_params: nil)
          @type = type
          @title = title
          @detail = detail
          @code = code
          @request_id = request_id
          unless status == 429
            raise ArgumentError, "Invalid value for status"
          end

          @status = 429
          @instance = instance
          @invalid_params = invalid_params
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @type == other.type
          return false unless @title == other.title
          return false unless @detail == other.detail
          return false unless @code == other.code
          return false unless @request_id == other.request_id
          return false unless @status == other.status
          return false unless @instance == other.instance
          return false unless @invalid_params == other.invalid_params
          true
        end
      end
    end
  end
end
