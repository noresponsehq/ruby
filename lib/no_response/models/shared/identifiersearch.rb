# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One customer-submitted identifier. Defaults to exact comparison of the original submitted value. canonical uses the supported identifier normalisation without an ownership claim: email preserves local-part case, NFC-normalises it and lowercases the domain without removing dots or tags; phone uses international E.164 without extensions or an inferred region; username uses NFC and Unicode case folding within the customer namespace. mailbox is email-only and explicitly selects existing list rules: case-insensitive, remove +tag, and ignore local-part dots at gmail.com and googlemail.com; googlemail.com maps to gmail.com. Username requires namespace customer. Email and phone forbid namespace. Source-discovered identifiers and platform handles are not searched. Unsupported kinds, namespaces, modes and invalid values return 400. Search equality does not establish verified ownership or merge accounts.
      class IdentifierSearch
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
        # The comparison value. Stored original identifiers remain unchanged. An invalid identifier is refused instead of returning an empty result.
        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )
        # exact compares the original submitted value; canonical uses identifier-specific normalisation; mailbox explicitly selects the email alias rules used by lists.
        field(
          :match,
          Crystalline::Nilable.new(Models::Shared::Match),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Match, true)
            }
          }
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
            match: T.nilable(Models::Shared::Match),
            namespace: T.nilable(Models::Shared::Namespace)
          )
            .void
        }
        def initialize(kind:, value:, match: nil, namespace: nil)
          @kind = kind
          @value = value
          @match = match
          @namespace = namespace
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @match == other.match
          return false unless @namespace == other.namespace
          true
        end
      end
    end
  end
end
