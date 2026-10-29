# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyPreviewRequestFlowsPurchase
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
        # Send true; false is refused.
        field(
          :inherits_account_creation,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("inherits_account_creation")}}
        )

        field(
          :block,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block")}}
        )

        sig {
          params(
            step_up: T.nilable(::Integer),
            review: T.nilable(::Integer),
            inherits_account_creation: T.nilable(T::Boolean),
            block: T.nilable(::Integer)
          )
            .void
        }
        def initialize(step_up: nil, review: nil, inherits_account_creation: nil, block: nil)
          @step_up = step_up
          @review = review
          @inherits_account_creation = inherits_account_creation
          @block = block
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @step_up == other.step_up
          return false unless @review == other.review
          return false unless @inherits_account_creation == other.inherits_account_creation
          return false unless @block == other.block
          true
        end
      end
    end
  end
end
