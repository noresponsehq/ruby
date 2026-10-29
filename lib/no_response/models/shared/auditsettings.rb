# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read audit retention and available history.
      class AuditSettings
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )

        field(
          :retention_days,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days"), required: true}}
        )

        field(
          :oldest_available_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("oldest_available_at")}}
        )

        field(
          :capture,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("capture"), required: true}}
        )

        sig {
          params(
            environment: Models::Shared::AuditSettingsEnvironment,
            retention_days: ::Integer,
            oldest_available_at: T.nilable(::String),
            capture: ::String
          )
            .void
        }
        def initialize(environment:, retention_days:, oldest_available_at: nil, capture: "available_events_only")
          @environment = environment
          @retention_days = retention_days
          @oldest_available_at = oldest_available_at
          unless capture == "available_events_only"
            raise ArgumentError, "Invalid value for capture"
          end

          @capture = "available_events_only"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @environment == other.environment
          return false unless @retention_days == other.retention_days
          return false unless @oldest_available_at == other.oldest_available_at
          return false unless @capture == other.capture
          true
        end
      end
    end
  end
end
