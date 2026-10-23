# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AssessmentDeletionAccount
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id of the deleted assessment.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The assessment the account's current risk now comes from. Absent when the account has no assessment with a decision left, and GET /v1/accounts/{account_id} then answers 404.
        field(
          :current_assessment_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("current_assessment_id")}}
        )

        sig { params(id: ::String, current_assessment_id: T.nilable(::String)).void }
        def initialize(id:, current_assessment_id: nil)
          @id = id
          @current_assessment_id = current_assessment_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @current_assessment_id == other.current_assessment_id
          true
        end
      end
    end
  end
end
