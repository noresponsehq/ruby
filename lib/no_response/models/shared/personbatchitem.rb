# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonBatchItem
        extend T::Sig
        include Crystalline::MetadataFields

        # The row's position in the request.
        field(
          :index,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("index"), required: true}}
        )

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # unchanged: the row matched a person with the same details.
        field(
          :outcome,
          Models::Shared::PersonBatchItemOutcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonBatchItemOutcome, false)
            }
          }
        )

        field(
          :suggested_matches,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::PersonMatch)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("suggested_matches")}}
        )

        sig {
          params(
            index: ::Integer,
            id: ::String,
            outcome: Models::Shared::PersonBatchItemOutcome,
            suggested_matches: T.nilable(T::Array[Models::Shared::PersonMatch])
          )
            .void
        }
        def initialize(index:, id:, outcome:, suggested_matches: nil)
          @index = index
          @id = id
          @outcome = outcome
          @suggested_matches = suggested_matches
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @index == other.index
          return false unless @id == other.id
          return false unless @outcome == other.outcome
          return false unless @suggested_matches == other.suggested_matches
          true
        end
      end
    end
  end
end
