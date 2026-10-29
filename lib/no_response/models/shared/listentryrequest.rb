# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/workspaces/{workspace_id}/lists/{environment} body. Adds one entry to the environment's list and, in the same change, re-decides every account it matches: each sends account.risk_changed when a decision changes. Needs the admin or owner role, or a management key of the environment.
      class ListEntryRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # email matches one address, whatever the case of its local part. email_domain matches every address of the registrable domain and of its subdomains.
        field(
          :kind,
          Models::Shared::ListEntryKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListEntryKind, false)
            }
          }
        )
        # An email address for kind email, written as in an assessment request; an LDH domain (A-label for an internationalised one) such as example.com for kind email_domain, which must sit below a public suffix (co.uk alone is refused with 400). NoResponse stores it in canonical form and answers that form.
        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )
        # block decides block for the accounts the entry matches; allow decides allow. Block wins when both match.
        field(
          :action,
          Models::Shared::ListEntryAction,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("action"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListEntryAction, false)
            }
          }
        )
        # Why the entry exists, for the people who manage the list. It is shown with the entry and decides nothing.
        field(
          :note,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("note")}}
        )
        # Optional expiry. An expired entry stops matching immediately; bounded maintenance removes it and propagates account risk changes.
        field(
          :expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at")}}
        )

        sig {
          params(
            kind: Models::Shared::ListEntryKind,
            value: ::String,
            action: Models::Shared::ListEntryAction,
            note: T.nilable(::String),
            expires_at: T.nilable(::String)
          )
            .void
        }
        def initialize(kind:, value:, action:, note: nil, expires_at: nil)
          @kind = kind
          @value = value
          @action = action
          @note = note
          @expires_at = expires_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @action == other.action
          return false unless @note == other.note
          return false unless @expires_at == other.expires_at
          true
        end
      end
    end
  end
end
