# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Optional context observed by the client of the user. The server parses these hints into coarse features, leaves raw user_agent and opaque ids out of every answer, and weighs a mismatch with the other evidence.
      class AssessmentRequestClientContext
        extend T::Sig
        include Crystalline::MetadataFields

        # IANA time-zone name such as Europe/London or America/Los_Angeles. Fixed numeric offsets are not accepted.
        field(
          :timezone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("timezone")}}
        )
        # BCP 47 locale, for example en-AU. Treat as a presentation hint, not a nationality signal.
        field(
          :locale,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("locale")}}
        )
        # Client platform. Closed vocabulary keeps integrations stable.
        field(
          :platform,
          Crystalline::Nilable.new(Models::Shared::Platform),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::Platform, true)
            }
          }
        )
        # Customer application version, without build metadata that contains secrets.
        field(
          :app_version,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("app_version")}}
        )
        # The raw User-Agent header of the request that the user sent, at most 512 characters. It is parsed into coarse features and left out of every answer.
        field(
          :user_agent,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("user_agent")}}
        )
        # Workspace-scoped opaque identifier your application mints and rotates when the account or device changes. Send an id of your own, not a hardware fingerprint.
        field(
          :device_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("device_id")}}
        )
        # Opaque signup session identifier. It is used for workspace-scoped velocity and replay checks only.
        field(
          :session_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("session_id")}}
        )
        # Elapsed time from form start to submit. Values below three seconds are a weak automation hint, weighed with the other evidence.
        field(
          :form_duration_ms,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("form_duration_ms")}}
        )
        # RFC 3339 timestamp observed by the client. Server ingress time remains authoritative; a large clock skew is only a low-confidence feature.
        field(
          :client_observed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("client_observed_at")}}
        )

        sig {
          params(
            timezone: T.nilable(::String),
            locale: T.nilable(::String),
            platform: T.nilable(Models::Shared::Platform),
            app_version: T.nilable(::String),
            user_agent: T.nilable(::String),
            device_id: T.nilable(::String),
            session_id: T.nilable(::String),
            form_duration_ms: T.nilable(::Integer),
            client_observed_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          timezone: nil,
          locale: nil,
          platform: nil,
          app_version: nil,
          user_agent: nil,
          device_id: nil,
          session_id: nil,
          form_duration_ms: nil,
          client_observed_at: nil
        )
          @timezone = timezone
          @locale = locale
          @platform = platform
          @app_version = app_version
          @user_agent = user_agent
          @device_id = device_id
          @session_id = session_id
          @form_duration_ms = form_duration_ms
          @client_observed_at = client_observed_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @timezone == other.timezone
          return false unless @locale == other.locale
          return false unless @platform == other.platform
          return false unless @app_version == other.app_version
          return false unless @user_agent == other.user_agent
          return false unless @device_id == other.device_id
          return false unless @session_id == other.session_id
          return false unless @form_duration_ms == other.form_duration_ms
          return false unless @client_observed_at == other.client_observed_at
          true
        end
      end
    end
  end
end
