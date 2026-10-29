# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Why this result matched a typed identifier search. value is the original value submitted in assessment_id. Provenance records a customer submission, not a source discovery or verified ownership. Equality is deterministic and has no inferred confidence score. An account result names its newest retained matching assessment, which can differ from latest.
      class IdentifierMatch
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :kind,
          Models::Shared::IdentifierSearchKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IdentifierSearchKind, false)
            }
          }
        )

        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )
        # exact compares the original submitted value; canonical uses identifier-specific normalisation; mailbox explicitly selects the email alias rules used by lists.
        field(
          :match_basis,
          Models::Shared::Match,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match_basis"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Match, false)
            }
          }
        )
        # Customer-submitted input. It does not mean the customer or NoResponse verified ownership.
        field(
          :provenance,
          Models::Shared::Provenance,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("provenance"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Provenance, false)
            }
          }
        )
        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Required for username: the username submitted by this customer in this workspace/environment. It does not name or join a source platform. Omit for email and phone.
        field(
          :namespace,
          Crystalline::Nilable.new(Models::Shared::Namespace),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("namespace"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Namespace, true)
            }
          }
        )

        sig {
          params(
            kind: Models::Shared::IdentifierSearchKind,
            value: ::String,
            match_basis: Models::Shared::Match,
            provenance: Models::Shared::Provenance,
            assessment_id: ::String,
            namespace: T.nilable(Models::Shared::Namespace)
          )
            .void
        }
        def initialize(kind:, value:, match_basis:, provenance:, assessment_id:, namespace: nil)
          @kind = kind
          @value = value
          @match_basis = match_basis
          @provenance = provenance
          @assessment_id = assessment_id
          @namespace = namespace
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @match_basis == other.match_basis
          return false unless @provenance == other.provenance
          return false unless @assessment_id == other.assessment_id
          return false unless @namespace == other.namespace
          true
        end
      end
    end
  end
end
