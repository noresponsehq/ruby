# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Records a decision on an attendee.
      class AttendeeReviewRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :decision,
          Models::Shared::AttendeeDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AttendeeDecision, false)
            }
          }
        )
        # Why, for the venue team and later reviewers.
        field(
          :note,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("note")}}
        )

        sig { params(decision: Models::Shared::AttendeeDecision, note: T.nilable(::String)).void }
        def initialize(decision:, note: nil)
          @decision = decision
          @note = note
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @decision == other.decision
          return false unless @note == other.note
          true
        end
      end
    end
  end
end
