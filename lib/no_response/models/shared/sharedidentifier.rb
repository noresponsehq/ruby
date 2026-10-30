# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class SharedIdentifier
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

        field(
          :account,
          Models::Shared::IdentifierSubmission,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account"), required: true}}
        )

        field(
          :linked_account,
          Models::Shared::IdentifierSubmission,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("linked_account"), required: true}}
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
            match_basis: Models::Shared::Match,
            provenance: Models::Shared::Provenance,
            account: Models::Shared::IdentifierSubmission,
            linked_account: Models::Shared::IdentifierSubmission,
            namespace: T.nilable(Models::Shared::Namespace)
          )
            .void
        }
        def initialize(kind:, match_basis:, provenance:, account:, linked_account:, namespace: nil)
          @kind = kind
          @match_basis = match_basis
          @provenance = provenance
          @account = account
          @linked_account = linked_account
          @namespace = namespace
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @match_basis == other.match_basis
          return false unless @provenance == other.provenance
          return false unless @account == other.account
          return false unless @linked_account == other.linked_account
          return false unless @namespace == other.namespace
          true
        end
      end
    end
  end
end
