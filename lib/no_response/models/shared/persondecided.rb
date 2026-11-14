# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A reviewer recorded a decision on a person. The decision's note stays in the API. Sent once per recorded review; a person's latest review is its decision, so order by decided_at.
      class PersonDecided
        extend T::Sig
        include Crystalline::MetadataFields

        # The person's group.
        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )
        # The person decided on.
        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )
        # The recorded review.
        field(
          :review_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_id"), required: true}}
        )

        field(
          :decision,
          Models::Shared::PersonDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonDecision, false)
            }
          }
        )
        # Who decided: the member's external user id, or the API key's label, as the person's decided_by.
        field(
          :decided_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_by"), required: true}}
        )
        # When the decision was recorded; equal to the event's created_at.
        field(
          :decided_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_at"), required: true}}
        )

        sig {
          params(
            group_id: ::String,
            person_id: ::String,
            review_id: ::String,
            decision: Models::Shared::PersonDecision,
            decided_by: ::String,
            decided_at: ::String
          )
            .void
        }
        def initialize(group_id:, person_id:, review_id:, decision:, decided_by:, decided_at:)
          @group_id = group_id
          @person_id = person_id
          @review_id = review_id
          @decision = decision
          @decided_by = decided_by
          @decided_at = decided_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @person_id == other.person_id
          return false unless @review_id == other.review_id
          return false unless @decision == other.decision
          return false unless @decided_by == other.decided_by
          return false unless @decided_at == other.decided_at
          true
        end
      end
    end
  end
end
