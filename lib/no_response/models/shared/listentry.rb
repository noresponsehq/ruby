# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One entry of an environment's list: an exact email or an email domain that decides an account whatever its score. An account matches when one of its admitted assessments sent the email, or an email of the domain. A block entry decides block for every flow and an allow entry decides allow; when both match, block wins. The account's risk carries the list_match reason with the entry's id, and its score stays the one the assessment's facts give. A held flow still waits for its investigation.
      class ListEntry
        extend T::Sig
        include Crystalline::MetadataFields

        # The entry's id: lst_ and a ULID.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )
        # The environment the key belongs to. A live key assesses with live sources; a test key answers from the deterministic simulator.
        field(
          :environment,
          Models::Shared::KeyEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::KeyEnvironment, false)
            }
          }
        )
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
        # The value the entry matches, in canonical form: an email lower-cased whole, or a domain lower-cased and taken to its registrable domain (mail.example.co.uk is stored as example.co.uk).
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

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The external user id of the member who added the entry through the console, or the prefix (nrk_<environment>_<key id>) of the management key that added it.
        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )
        # Why the entry exists, for the people who manage the list. It is shown with the entry and decides nothing.
        field(
          :note,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("note")}}
        )

        sig {
          params(
            id: ::String,
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            kind: Models::Shared::ListEntryKind,
            value: ::String,
            action: Models::Shared::ListEntryAction,
            created_at: ::String,
            created_by: ::String,
            note: T.nilable(::String)
          )
            .void
        }
        def initialize(id:, workspace_id:, environment:, kind:, value:, action:, created_at:, created_by:, note: nil)
          @id = id
          @workspace_id = workspace_id
          @environment = environment
          @kind = kind
          @value = value
          @action = action
          @created_at = created_at
          @created_by = created_by
          @note = note
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @action == other.action
          return false unless @created_at == other.created_at
          return false unless @created_by == other.created_by
          return false unless @note == other.note
          true
        end
      end
    end
  end
end
