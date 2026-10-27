# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The account.risk_changed event.
      class AccountRiskChangedEvent
        extend T::Sig
        include Crystalline::MetadataFields

        # The event id, equal to the NR-Webhook-Id header and across redeliveries and every endpoint the event fans out to.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # When the event was created. Equal across redeliveries; the signing timestamp header is per delivery.
        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The account's decision for at least one flow changed. account is the account as GET /v1/accounts/{account_id} answers it for the revision that made the change: its new score, decision, reasons and decisions_by_flow, and the assessment the risk comes from. previous_decisions_by_flow are the decisions it replaced, so account.decisions_by_flow differs from them for at least one flow, and previous_risk_version is the risk_version they were announced at. On the account's first event no decision was announced before: previous_risk_version is absent and previous_decisions_by_flow is allow for every flow, the decisions an account has before its first event. Events of one account are not ordered: account.risk_version orders them, so keep the account with the highest risk_version and ignore an event whose account is older than the one held.
        field(
          :data,
          Models::Shared::AccountRiskChanged,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("data"), required: true}}
        )
        # Always account.risk_changed.
        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}
        # Present, and true, only on an event sent by POST /v1/webhooks/{endpoint_id}/test: its data is a fixed example assessment, not one of the workspace's, so a receiver acknowledges it and applies nothing. Real events have no test member.
        field(
          :test,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("test")}}
        )

        sig {
          params(
            id: ::String,
            created_at: ::String,
            data: Models::Shared::AccountRiskChanged,
            type: ::String,
            test: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(id:, created_at:, data:, type: "account.risk_changed", test: nil)
          @id = id
          @created_at = created_at
          @data = data
          unless type == "account.risk_changed"
            raise ArgumentError, "Invalid value for type"
          end

          @type = "account.risk_changed"
          @test = test
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @created_at == other.created_at
          return false unless @data == other.data
          return false unless @type == other.type
          return false unless @test == other.test
          true
        end
      end
    end
  end
end
