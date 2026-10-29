# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewResolveRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :expected_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version"), required: true}}
        )

        field(
          :expected_risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_risk_version"), required: true}}
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

        sig {
          params(
            expected_version: ::Integer,
            expected_risk_version: ::Integer,
            conclusion: Models::Shared::Conclusion,
            note: ::String
          )
            .void
        }
        def initialize(expected_version:, expected_risk_version:, conclusion:, note:)
          @expected_version = expected_version
          @expected_risk_version = expected_risk_version
          @conclusion = conclusion
          @note = note
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_version == other.expected_version
          return false unless @expected_risk_version == other.expected_risk_version
          return false unless @conclusion == other.conclusion
          return false unless @note == other.note
          true
        end
      end
    end
  end
end
