# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Search retained assessments created in [from,to), over at most 366 days. Filters use each assessment decision, rather than the current account decision. Results can change between pages. Keep the assessment version to retrieve the exact decision later. This read does not require an idempotency key.
      class AssessmentSearchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::Flow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, true)
            }
          }
        )
        # complete: final; nothing is still running. A lane that failed or missed its 10 s deadline stays listed in incomplete_sources, and confidence is lower. partial: a recommendation exists and at least one lane is still running or did not settle (see incomplete_sources). pending: nothing usable before the deadline; no recommendation yet, poll or wait for the webhook.
        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::Status),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Status, true)
            }
          }
        )
        # The recommended action: allow, step_up or review. Your application applies it.
        field(
          :recommendation,
          Crystalline::Nilable.new(Models::Shared::Recommendation),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("recommendation"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Recommendation, true)
            }
          }
        )
        # Opaque, expiring cursor bound to this environment, operation and every filter. Keep the filters unchanged.
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
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, true)
            }
          }
        )
        # The decision of the assessment's latest stored revision: block when its stored risk.block is true, otherwise its recommendation. This is not the account's current decision or held-admission state. Combined with recommendation using AND.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::Decision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::Decision, true)
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
            from: ::String,
            to: ::String,
            account_id: T.nilable(::String),
            flow: T.nilable(Models::Shared::Flow),
            status: T.nilable(Models::Shared::Status),
            recommendation: T.nilable(Models::Shared::Recommendation),
            cursor: T.nilable(::String),
            response_mode: T.nilable(Models::Shared::ResponseMode),
            decision: T.nilable(Models::Shared::Decision),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          from:,
          to:,
          account_id: nil,
          flow: nil,
          status: nil,
          recommendation: nil,
          cursor: nil,
          response_mode: nil,
          decision: nil,
          limit: 20
        )
          @from = from
          @to = to
          @account_id = account_id
          @flow = flow
          @status = status
          @recommendation = recommendation
          @cursor = cursor
          @response_mode = response_mode
          @decision = decision
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @account_id == other.account_id
          return false unless @flow == other.flow
          return false unless @status == other.status
          return false unless @recommendation == other.recommendation
          return false unless @cursor == other.cursor
          return false unless @response_mode == other.response_mode
          return false unless @decision == other.decision
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
