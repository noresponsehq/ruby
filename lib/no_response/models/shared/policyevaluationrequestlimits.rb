# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluationRequestLimits
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :review_rate,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_rate"), required: true}}
        )

        field(
          :server_error_rate,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("server_error_rate"), required: true}}
        )

        field(
          :unavailable_result_rate,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unavailable_result_rate"), required: true}}
        )

        field(
          :p95_ms,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("p95_ms"), required: true}}
        )

        sig {
          params(review_rate: ::Float, server_error_rate: ::Float, unavailable_result_rate: ::Float, p95_ms: ::Float)
            .void
        }
        def initialize(review_rate:, server_error_rate:, unavailable_result_rate:, p95_ms:)
          @review_rate = review_rate
          @server_error_rate = server_error_rate
          @unavailable_result_rate = unavailable_result_rate
          @p95_ms = p95_ms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @review_rate == other.review_rate
          return false unless @server_error_rate == other.server_error_rate
          return false unless @unavailable_result_rate == other.unavailable_result_rate
          return false unless @p95_ms == other.p95_ms
          true
        end
      end
    end
  end
end
