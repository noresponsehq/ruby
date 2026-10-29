# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AuditStream
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
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

        field(
          :actions,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actions"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # unverified until the endpoint echoes an endpoint.verification challenge (send one with POST /v1/webhooks/{endpoint_id}/test); verified receives assessment.updated events; disabled after 72 hours of continuous delivery failure, and verified again by the same challenge.
        field(
          :endpoint_state,
          Models::Shared::WebhookEndpointState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("endpoint_state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WebhookEndpointState, false)
            }
          }
        )

        field(
          :last_attempt_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_attempt_at")}}
        )

        field(
          :last_delivered_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_delivered_at")}}
        )

        sig {
          params(
            endpoint_id: ::String,
            environment: Models::Shared::Environment,
            actions: T::Array[::String],
            created_at: ::String,
            endpoint_state: Models::Shared::WebhookEndpointState,
            last_attempt_at: T.nilable(::String),
            last_delivered_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          endpoint_id:,
          environment:,
          actions:,
          created_at:,
          endpoint_state:,
          last_attempt_at: nil,
          last_delivered_at: nil
        )
          @endpoint_id = endpoint_id
          @environment = environment
          @actions = actions
          @created_at = created_at
          @endpoint_state = endpoint_state
          @last_attempt_at = last_attempt_at
          @last_delivered_at = last_delivered_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @environment == other.environment
          return false unless @actions == other.actions
          return false unless @created_at == other.created_at
          return false unless @endpoint_state == other.endpoint_state
          return false unless @last_attempt_at == other.last_attempt_at
          return false unless @last_delivered_at == other.last_delivered_at
          true
        end
      end
    end
  end
end
