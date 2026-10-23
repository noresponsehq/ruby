# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The identity fields of the auth context the assessment was made with, echoed for the workspace's own correlation: the request's auth_context, or the one a hosted provider hook (POST /hooks/{integration_id}) built, with transport provider_hook and its hook_point. Present exactly when the request carried an auth_context, and the same on every revision of the assessment. Values are as the request or the hook sent them; tokens, timestamps, roles and scopes are not echoed, and the echo does not change the score.
      class AssessmentDetailAuthContext
        extend T::Sig
        include Crystalline::MetadataFields

        # The provider slug the context named.
        field(
          :provider,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("provider"), required: true}}
        )
        # The issuer the context named.
        field(
          :issuer,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("issuer"), required: true}}
        )
        # The verified flag the context carried. A provider_hook context is always false.
        field(
          :verified,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("verified"), required: true}}
        )
        # Where the context was derived: backend (also when the request named no transport), browser, or provider_hook for a hosted provider hook.
        field(
          :transport,
          Models::Shared::Transport,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("transport"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Transport, false)
            }
          }
        )
        # The subject the context named; absent when it named none (a pre_registration hook).
        field(
          :subject,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("subject")}}
        )
        # The session identifier the context named, when it named one.
        field(
          :session_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("session_id")}}
        )
        # The organization identifier the context named, when it named one.
        field(
          :organization_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("organization_id")}}
        )
        # The provider event a provider_hook context was sent for; absent for any other transport.
        field(
          :hook_point,
          Crystalline::Nilable.new(Models::Shared::HookPoint),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("hook_point"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HookPoint, true)
            }
          }
        )

        sig {
          params(
            provider: ::String,
            issuer: ::String,
            verified: T::Boolean,
            transport: Models::Shared::Transport,
            subject: T.nilable(::String),
            session_id: T.nilable(::String),
            organization_id: T.nilable(::String),
            hook_point: T.nilable(Models::Shared::HookPoint)
          )
            .void
        }
        def initialize(
          provider:,
          issuer:,
          verified:,
          transport:,
          subject: nil,
          session_id: nil,
          organization_id: nil,
          hook_point: nil
        )
          @provider = provider
          @issuer = issuer
          @verified = verified
          @transport = transport
          @subject = subject
          @session_id = session_id
          @organization_id = organization_id
          @hook_point = hook_point
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @provider == other.provider
          return false unless @issuer == other.issuer
          return false unless @verified == other.verified
          return false unless @transport == other.transport
          return false unless @subject == other.subject
          return false unless @session_id == other.session_id
          return false unless @organization_id == other.organization_id
          return false unless @hook_point == other.hook_point
          true
        end
      end
    end
  end
end
