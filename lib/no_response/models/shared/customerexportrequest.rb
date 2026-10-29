# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class CustomerExportRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :kind,
          Models::Shared::CustomerExportRequestKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::CustomerExportRequestKind, false)
            }
          }
        )

        field(
          :environment,
          Models::Shared::Environment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Environment, false)
            }
          }
        )
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, true)
            }
          }
        )

        field(
          :filter,
          Crystalline::Nilable.new(Models::Shared::CustomerExportRequestFilter),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("filter")}}
        )

        sig {
          params(
            kind: Models::Shared::CustomerExportRequestKind,
            environment: Models::Shared::Environment,
            account_id: T.nilable(::String),
            response_mode: T.nilable(Models::Shared::ResponseMode),
            filter: T.nilable(Models::Shared::CustomerExportRequestFilter)
          )
            .void
        }
        def initialize(kind:, environment:, account_id: nil, response_mode: nil, filter: nil)
          @kind = kind
          @environment = environment
          @account_id = account_id
          @response_mode = response_mode
          @filter = filter
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @environment == other.environment
          return false unless @account_id == other.account_id
          return false unless @response_mode == other.response_mode
          return false unless @filter == other.filter
          true
        end
      end
    end
  end
end
