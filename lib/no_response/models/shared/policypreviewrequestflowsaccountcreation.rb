# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyPreviewRequestFlowsAccountCreation
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :step_up,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("step_up")}}
        )

        field(
          :review,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review")}}
        )

        field(
          :block,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block")}}
        )

        sig { params(step_up: T.nilable(::Integer), review: T.nilable(::Integer), block: T.nilable(::Integer)).void }
        def initialize(step_up: nil, review: nil, block: nil)
          @step_up = step_up
          @review = review
          @block = block
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @step_up == other.step_up
          return false unless @review == other.review
          return false unless @block == other.block
          true
        end
      end
    end
  end
end
