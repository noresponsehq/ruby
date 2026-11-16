# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ProfileLead
        extend T::Sig
        include Crystalline::MetadataFields

        # A value copied exactly from a linked record that the person was not searched by.
        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )

        field :kind, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind"), required: true}}

        field :why, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("why"), required: true}}

        field(
          :evidence,
          Crystalline::Array.new(Models::Shared::ProfileCitation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence"), required: true}}
        )

        sig {
          params(value: ::String, kind: ::String, why: ::String, evidence: T::Array[Models::Shared::ProfileCitation])
            .void
        }
        def initialize(value:, kind:, why:, evidence:)
          @value = value
          @kind = kind
          @why = why
          @evidence = evidence
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @value == other.value
          return false unless @kind == other.kind
          return false unless @why == other.why
          return false unless @evidence == other.evidence
          true
        end
      end
    end
  end
end
