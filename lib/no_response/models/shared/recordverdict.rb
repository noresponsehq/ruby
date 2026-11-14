# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A recorded verdict on one record. A later verdict on the same record replaces it.
      class RecordVerdict
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :record_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("record_id"), required: true}}
        )
        # A reviewer's overrule (POST .../people/{person_id}/records), which decides joined whatever the likelihood and sticks for as long as a lookup finds the same record. Absent when nobody overruled it.
        field(
          :verdict,
          Models::Shared::Verdict,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("verdict"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Verdict, false)
            }
          }
        )

        field(
          :decided_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_by"), required: true}}
        )

        field(
          :decided_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_at"), required: true}}
        )

        sig {
          params(record_id: ::String, verdict: Models::Shared::Verdict, decided_by: ::String, decided_at: ::String).void
        }
        def initialize(record_id:, verdict:, decided_by:, decided_at:)
          @record_id = record_id
          @verdict = verdict
          @decided_by = decided_by
          @decided_at = decided_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @record_id == other.record_id
          return false unless @verdict == other.verdict
          return false unless @decided_by == other.decided_by
          return false unless @decided_at == other.decided_at
          true
        end
      end
    end
  end
end
