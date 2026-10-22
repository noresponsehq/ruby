# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/assessments/query body. account_id travels in the body rather than the URL path so a provider value that turns out to hold personal data is not written to access logs, proxies or browser history. Read-only: no Idempotency-Key. An account with no unexpired assessments answers 200 with empty items.
      class AssessmentQuery
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your tenant. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused, as is a JWT; a hex digest such as a SHA-256 is allowed. It travels only in request bodies. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # next_cursor from the previous page, unchanged. Opaque, MAC'd and bound to the tenant and account_id.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cursor")}}
        )
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ResponseMode, true)
            }
          }
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            account_id: ::String,
            cursor: T.nilable(::String),
            response_mode: T.nilable(Models::Shared::ResponseMode),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(account_id:, cursor: nil, response_mode: nil, limit: 20)
          @account_id = account_id
          @cursor = cursor
          @response_mode = response_mode
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @cursor == other.cursor
          return false unless @response_mode == other.response_mode
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
