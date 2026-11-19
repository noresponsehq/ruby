# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Runs a new investigation against one retained workspace person.
      class InvestigationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :depth,
          Models::Shared::ScreeningDepth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningDepth, false)
            }
          }
        )

        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )
        # A change to enrichment. A field left out keeps the value in force; max_spend or deadline null removes the bound.
        field(
          :enrichment,
          Crystalline::Nilable.new(Models::Shared::EnrichmentChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("enrichment")}}
        )

        sig {
          params(
            depth: Models::Shared::ScreeningDepth,
            person_id: ::String,
            enrichment: T.nilable(Models::Shared::EnrichmentChange)
          )
            .void
        }
        def initialize(depth:, person_id:, enrichment: nil)
          @depth = depth
          @person_id = person_id
          @enrichment = enrichment
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @depth == other.depth
          return false unless @person_id == other.person_id
          return false unless @enrichment == other.enrichment
          true
        end
      end
    end
  end
end
