# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # List override changes among the newest 5000 matching accounts. These counts describe override inputs. Customer enforcement and eventual outcomes remain separate. The response reports whether the matching population was truncated.
      class ListImpact
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :kind,
          Models::Shared::ListImpactKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListImpactKind, false)
            }
          }
        )

        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )

        field(
          :action,
          Models::Shared::Action,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("action"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Action, false)
            }
          }
        )

        field(
          :matched_accounts,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_accounts"), required: true}}
        )

        field(
          :changed_overrides,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("changed_overrides"), required: true}}
        )

        field(
          :truncated,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("truncated"), required: true}}
        )

        field(
          :transitions,
          Crystalline::Array.new(Models::Shared::ListImpactTransition),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("transitions"), required: true}}
        )

        field(
          :scope,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scope"), required: true}}
        )

        field(
          :remove,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("remove")}}
        )

        field(
          :historical_population_known,
          Crystalline::Boolean.new,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("historical_population_known"),
              required: true
            }
          }
        )

        sig {
          params(
            kind: Models::Shared::ListImpactKind,
            value: ::String,
            action: Models::Shared::Action,
            matched_accounts: ::Integer,
            changed_overrides: ::Integer,
            truncated: T::Boolean,
            transitions: T::Array[Models::Shared::ListImpactTransition],
            scope: ::String,
            remove: T.nilable(::String),
            historical_population_known: T::Boolean
          )
            .void
        }
        def initialize(
          kind:,
          value:,
          action:,
          matched_accounts:,
          changed_overrides:,
          truncated:,
          transitions:,
          scope: "current_list_override_inputs",
          remove: nil,
          historical_population_known: false
        )
          @kind = kind
          @value = value
          @action = action
          @matched_accounts = matched_accounts
          @changed_overrides = changed_overrides
          @truncated = truncated
          @transitions = transitions
          unless scope == "current_list_override_inputs"
            raise ArgumentError, "Invalid value for scope"
          end

          @scope = "current_list_override_inputs"
          @remove = remove
          unless historical_population_known == false
            raise ArgumentError, "Invalid value for historical_population_known"
          end

          @historical_population_known = false
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @action == other.action
          return false unless @matched_accounts == other.matched_accounts
          return false unless @changed_overrides == other.changed_overrides
          return false unless @truncated == other.truncated
          return false unless @transitions == other.transitions
          return false unless @scope == other.scope
          return false unless @remove == other.remove
          return false unless @historical_population_known == other.historical_population_known
          true
        end
      end
    end
  end
end
