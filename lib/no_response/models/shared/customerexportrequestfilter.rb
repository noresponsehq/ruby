# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class CustomerExportRequestFilter
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :action,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("action")}}
        )

        field(
          :actor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actor")}}
        )

        field(
          :target_type,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("target_type")}}
        )

        field(
          :target_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("target_id")}}
        )

        field(
          :environment,
          Crystalline::Nilable.new(Models::Shared::Environment),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Environment, true)
            }
          }
        )

        field(
          :outcome,
          Crystalline::Nilable.new(Models::Shared::CustomerExportRequestFilterOutcome),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(
                Models::Shared::CustomerExportRequestFilterOutcome,
                true
              )
            }
          }
        )

        field(
          :since,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("since")}}
        )

        field(
          :until_,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("until")}}
        )

        sig {
          params(
            action: T.nilable(::String),
            actor: T.nilable(::String),
            target_type: T.nilable(::String),
            target_id: T.nilable(::String),
            environment: T.nilable(Models::Shared::Environment),
            outcome: T.nilable(Models::Shared::CustomerExportRequestFilterOutcome),
            since: T.nilable(::String),
            until_: T.nilable(::String)
          )
            .void
        }
        def initialize(
          action: nil,
          actor: nil,
          target_type: nil,
          target_id: nil,
          environment: nil,
          outcome: nil,
          since: nil,
          until_: nil
        )
          @action = action
          @actor = actor
          @target_type = target_type
          @target_id = target_id
          @environment = environment
          @outcome = outcome
          @since = since
          @until_ = until_
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @action == other.action
          return false unless @actor == other.actor
          return false unless @target_type == other.target_type
          return false unless @target_id == other.target_id
          return false unless @environment == other.environment
          return false unless @outcome == other.outcome
          return false unless @since == other.since
          return false unless @until_ == other.until_
          true
        end
      end
    end
  end
end
