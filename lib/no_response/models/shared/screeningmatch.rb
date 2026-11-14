# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How a profile was matched to the person: the state its evidence earns, and the evidence.
      class ScreeningMatch
        extend T::Sig
        include Crystalline::MetadataFields

        # How sure the screening is that a profile is the person's, from its evidence: confirmed is a handle on the person row, or two or more hard identifiers (email, phone, a supplied handle, or a fact an existing source returned); probable is one identifier beyond the name; possible is the name alone.
        field(
          :state,
          Models::Shared::ProfileMatchState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ProfileMatchState, false)
            }
          }
        )

        field(
          :evidence,
          Crystalline::Array.new(Models::Shared::ScreeningMatchEvidence),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence"), required: true}}
        )

        sig {
          params(state: Models::Shared::ProfileMatchState, evidence: T::Array[Models::Shared::ScreeningMatchEvidence])
            .void
        }
        def initialize(state:, evidence:)
          @state = state
          @evidence = evidence
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @state == other.state
          return false unless @evidence == other.evidence
          true
        end
      end
    end
  end
end
