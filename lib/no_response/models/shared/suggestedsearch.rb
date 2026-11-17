# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A search enrichment would start: a distinctive or unique value of a likely record, not yet searched for the person. A person starts it with POST .../searches, naming the record and the field.
      class SuggestedSearch
        extend T::Sig
        include Crystalline::MetadataFields

        # The lookup record whose value enrichment would search. It is among the report's lookup records.
        field(
          :record_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("record_id"), required: true}}
        )
        # The field of that record that holds the value. Send record_id and field to POST .../searches to start the search.
        field(
          :field,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field"), required: true}}
        )
        # The kind of the value: one of the kinds the environment's enrichment setting names.
        field(
          :kind,
          Models::Shared::SuggestedSearchKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SuggestedSearchKind, false)
            }
          }
        )
        # The likelihood of the record that holds the value, from 0.01 to 0.99. Enrichment suggests a value only from a record more likely than the setting's min_likelihood, the likeliest first.
        field(
          :likelihood,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("likelihood"), required: true}}
        )

        sig {
          params(record_id: ::String, field: ::String, kind: Models::Shared::SuggestedSearchKind, likelihood: ::Float)
            .void
        }
        def initialize(record_id:, field:, kind:, likelihood:)
          @record_id = record_id
          @field = field
          @kind = kind
          @likelihood = likelihood
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @record_id == other.record_id
          return false unless @field == other.field
          return false unless @kind == other.kind
          return false unless @likelihood == other.likelihood
          true
        end
      end
    end
  end
end
