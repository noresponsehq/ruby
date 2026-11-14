# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A reviewer's verdict on whether one of a person's lookup records is theirs.
      class RecordVerdictRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # One of the person's lookup records.
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

        sig { params(record_id: ::String, verdict: Models::Shared::Verdict).void }
        def initialize(record_id:, verdict:)
          @record_id = record_id
          @verdict = verdict
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @record_id == other.record_id
          return false unless @verdict == other.verdict
          true
        end
      end
    end
  end
end
