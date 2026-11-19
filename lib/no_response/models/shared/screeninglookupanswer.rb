# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ScreeningLookupAnswer
        extend T::Sig
        include Crystalline::MetadataFields

        # The id of the connector asked: breach for the breach search.
        field(
          :connector,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("connector"), required: true}}
        )

        field(
          :identifier,
          Models::Shared::Identifier,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Identifier, false)
            }
          }
        )
        # Per-signal outcome. A source that timed out, was blocked or errored reports blocked, unavailable or inconclusive with a reason and is listed in incomplete_sources; not_found is a definite absence.
        field(
          :outcome,
          Models::Shared::SignalOutcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SignalOutcome, false)
            }
          }
        )

        field(
          :answered_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered_at")}}
        )

        sig {
          params(
            connector: ::String,
            identifier: Models::Shared::Identifier,
            outcome: Models::Shared::SignalOutcome,
            answered_at: T.nilable(::String)
          )
            .void
        }
        def initialize(connector:, identifier:, outcome:, answered_at: nil)
          @connector = connector
          @identifier = identifier
          @outcome = outcome
          @answered_at = answered_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @connector == other.connector
          return false unless @identifier == other.identifier
          return false unless @outcome == other.outcome
          return false unless @answered_at == other.answered_at
          true
        end
      end
    end
  end
end
