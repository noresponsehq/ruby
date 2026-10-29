# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Cost
        extend T::Sig
        include Crystalline::MetadataFields

        field :allow, ::Float, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("allow"), required: true}}

        field(
          :step_up,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("step_up"), required: true}}
        )

        field(
          :review,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review"), required: true}}
        )

        field :block, ::Float, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block"), required: true}}

        sig { params(allow: ::Float, step_up: ::Float, review: ::Float, block: ::Float).void }
        def initialize(allow:, step_up:, review:, block:)
          @allow = allow
          @step_up = step_up
          @review = review
          @block = block
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @allow == other.allow
          return false unless @step_up == other.step_up
          return false unless @review == other.review
          return false unless @block == other.block
          true
        end
      end
    end
  end
end
