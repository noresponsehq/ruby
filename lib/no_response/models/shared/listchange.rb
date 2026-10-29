# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A committed bulk list change and bounded notification progress, available while propagation is pending and for 24 hours after all propagation completes. References count an account once per changed list entry and are not unique accounts. No endpoint delivery or customer enforcement is implied by completed.
      class ListChange
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :state,
          Models::Shared::ListChangeState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListChangeState, false)
            }
          }
        )

        field(
          :added,
          Crystalline::Array.new(Models::Shared::ListEntry),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("added"), required: true}}
        )

        field(
          :removed,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("removed"), required: true}}
        )

        field(
          :pending_propagations,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("pending_propagations"), required: true}}
        )

        field(
          :processed_account_references,
          ::Integer,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("processed_account_references"),
              required: true
            }
          }
        )

        sig {
          params(
            id: ::String,
            created_at: ::String,
            state: Models::Shared::ListChangeState,
            added: T::Array[Models::Shared::ListEntry],
            removed: T::Array[::String],
            pending_propagations: ::Integer,
            processed_account_references: ::Integer
          )
            .void
        }
        def initialize(id:, created_at:, state:, added:, removed:, pending_propagations:, processed_account_references:)
          @id = id
          @created_at = created_at
          @state = state
          @added = added
          @removed = removed
          @pending_propagations = pending_propagations
          @processed_account_references = processed_account_references
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @created_at == other.created_at
          return false unless @state == other.state
          return false unless @added == other.added
          return false unless @removed == other.removed
          return false unless @pending_propagations == other.pending_propagations
          return false unless @processed_account_references == other.processed_account_references
          true
        end
      end
    end
  end
end
