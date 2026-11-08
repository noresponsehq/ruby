# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One recorded decision.
      class AttendeeReview
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

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

        field(
          :note,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("note")}}
        )

        sig {
          params(
            id: ::String,
            decision: Models::Shared::AttendeeDecision,
            created_by: ::String,
            created_at: ::String,
            note: T.nilable(::String)
          )
            .void
        }
        def initialize(id:, decision:, created_by:, created_at:, note: nil)
          @id = id
          @decision = decision
          @created_by = created_by
          @created_at = created_at
          @note = note
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @decision == other.decision
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          return false unless @note == other.note
          true
        end
      end
    end
  end
end
