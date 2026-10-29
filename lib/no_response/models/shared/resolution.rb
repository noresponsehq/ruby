# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Resolution
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :review_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_version"), required: true}}
        )

        field(
          :risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version"), required: true}}
        )

        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
        )

        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )

        field(
          :conclusion,
          Models::Shared::Conclusion,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("conclusion"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Conclusion, false)
            }
          }
        )

        field :note, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("note"), required: true}}

        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        sig {
          params(
            review_version: ::Integer,
            risk_version: ::Integer,
            assessment_version: ::Integer,
            assessment_id: ::String,
            conclusion: Models::Shared::Conclusion,
            note: ::String,
            created_by: ::String,
            created_at: ::String
          )
            .void
        }
        def initialize(
          review_version:,
          risk_version:,
          assessment_version:,
          assessment_id:,
          conclusion:,
          note:,
          created_by:,
          created_at:
        )
          @review_version = review_version
          @risk_version = risk_version
          @assessment_version = assessment_version
          @assessment_id = assessment_id
          @conclusion = conclusion
          @note = note
          @created_by = created_by
          @created_at = created_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @review_version == other.review_version
          return false unless @risk_version == other.risk_version
          return false unless @assessment_version == other.assessment_version
          return false unless @assessment_id == other.assessment_id
          return false unless @conclusion == other.conclusion
          return false unless @note == other.note
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          true
        end
      end
    end
  end
end
