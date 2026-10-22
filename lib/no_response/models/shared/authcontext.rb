# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Normalised claims from a session your backend has already verified with WorkOS, Clerk, Auth0 or any OIDC provider. Pass the output of the SDK's auth adapters, not a raw token.
      class AuthContext
        extend T::Sig
        include Crystalline::MetadataFields

        # Lowercase provider slug. WorkOS, Clerk and Auth0 have first-class adapters; every other provider uses a customer-specific OIDC slug. Provider brand is metadata; it does not change risk by itself.
        field(
          :provider,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("provider"), required: true}}
        )
        # The verified token issuer, normally the provider's HTTPS issuer URL.
        field(
          :issuer,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("issuer"), required: true}}
        )
        # The verified stable subject identifier (`sub`), opaque to NoResponse. Required, except from a provider hook at pre_registration, where no user exists yet.
        field(
          :subject,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("subject"), required: true}}
        )
        # Whether the customer completed signature, issuer, audience and expiry validation before calling NoResponse. False contexts are accepted only as weak hints.
        field(
          :verified,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("verified"), required: true}}
        )
        # The verified audience/resource identifier used by the customer's API. Use audiences when the provider emits multiple values.
        field(
          :audience,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("audience")}}
        )
        # All verified audience/resource identifiers from an OAuth or OIDC token. The first value may also be copied to audience for simple integrations.
        field(
          :audiences,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("audiences")}}
        )
        # The verified session identifier (`sid` or provider equivalent).
        field(
          :session_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("session_id")}}
        )
        # The active organization or workspace identifier, when the provider issued one.
        field(
          :organization_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("organization_id")}}
        )
        # The provider tenant identifier, when distinct from organization_id.
        field(
          :tenant_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("tenant_id")}}
        )
        # The verified token identifier (`jti`), used for replay and rotation correlation.
        field(
          :token_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("token_id")}}
        )
        # Verified token issue time (`iat`).
        field(
          :issued_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("issued_at")}}
        )
        # Verified token expiry (`exp`).
        field(
          :expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at")}}
        )
        # Creation time of the provider session from the verified backend session record (for example Clerk Session.createdAt or WorkOS Session.created_at). This is separate from token issuance and auth_time.
        field(
          :session_created_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("session_created_at")}}
        )
        # Verified end-user authentication time (`auth_time`), when present.
        field(
          :auth_time,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("auth_time")}}
        )
        # Account creation time from the customer's verified provider record, when available.
        field(
          :account_created_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_created_at")}}
        )
        # Whether the customer's provider asserts that the email identifier was verified.
        field(
          :email_verified,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email_verified")}}
        )
        # Whether the customer's provider asserts that the phone identifier was verified.
        field(
          :phone_verified,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone_verified")}}
        )
        # Provider or OIDC assurance level, when the customer has mapped one.
        field(
          :assurance_level,
          Crystalline::Nilable.new(Models::Shared::AssuranceLevel),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("assurance_level"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::AssuranceLevel, true)
            }
          }
        )
        # Whether the verified session is acting on behalf of another subject.
        field(
          :impersonated,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("impersonated")}}
        )
        # Where this context was derived. Backend is the trusted integration path; browser values are treated as weak hints. provider_hook is a hosted provider hook (an Auth0 or WorkOS Action) calling at hook_point; it needs hook_point and verified false, and its authentication facts are not scored.
        field(
          :transport,
          Crystalline::Nilable.new(Models::Shared::Transport),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("transport"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::Transport, true)
            }
          }
        )
        # The provider event a provider_hook context was sent for. pre_registration runs before the user exists, so subject and the request's account_id may be absent there. Sent only with transport provider_hook.
        field(
          :hook_point,
          Crystalline::Nilable.new(Models::Shared::HookPoint),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("hook_point"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::HookPoint, true)
            }
          }
        )
        # Normalized multi-factor evidence from a verified provider session.
        field(
          :mfa,
          Crystalline::Nilable.new(Models::Shared::AuthContextMfa),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("mfa")}}
        )
        # Bounded role slugs from the verified provider; roles do not change risk by themselves.
        field(
          :roles,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("roles")}}
        )
        # Bounded scopes from the verified access token; scopes do not change risk by themselves.
        field(
          :scopes,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scopes")}}
        )

        sig {
          params(
            provider: ::String,
            issuer: ::String,
            subject: ::String,
            verified: T::Boolean,
            audience: T.nilable(::String),
            audiences: T.nilable(T::Array[::String]),
            session_id: T.nilable(::String),
            organization_id: T.nilable(::String),
            tenant_id: T.nilable(::String),
            token_id: T.nilable(::String),
            issued_at: T.nilable(::String),
            expires_at: T.nilable(::String),
            session_created_at: T.nilable(::String),
            auth_time: T.nilable(::String),
            account_created_at: T.nilable(::String),
            email_verified: T.nilable(T::Boolean),
            phone_verified: T.nilable(T::Boolean),
            assurance_level: T.nilable(Models::Shared::AssuranceLevel),
            impersonated: T.nilable(T::Boolean),
            transport: T.nilable(Models::Shared::Transport),
            hook_point: T.nilable(Models::Shared::HookPoint),
            mfa: T.nilable(Models::Shared::AuthContextMfa),
            roles: T.nilable(T::Array[::String]),
            scopes: T.nilable(T::Array[::String])
          )
            .void
        }
        def initialize(
          provider:,
          issuer:,
          subject:,
          verified:,
          audience: nil,
          audiences: nil,
          session_id: nil,
          organization_id: nil,
          tenant_id: nil,
          token_id: nil,
          issued_at: nil,
          expires_at: nil,
          session_created_at: nil,
          auth_time: nil,
          account_created_at: nil,
          email_verified: nil,
          phone_verified: nil,
          assurance_level: nil,
          impersonated: nil,
          transport: nil,
          hook_point: nil,
          mfa: nil,
          roles: nil,
          scopes: nil
        )
          @provider = provider
          @issuer = issuer
          @subject = subject
          @verified = verified
          @audience = audience
          @audiences = audiences
          @session_id = session_id
          @organization_id = organization_id
          @tenant_id = tenant_id
          @token_id = token_id
          @issued_at = issued_at
          @expires_at = expires_at
          @session_created_at = session_created_at
          @auth_time = auth_time
          @account_created_at = account_created_at
          @email_verified = email_verified
          @phone_verified = phone_verified
          @assurance_level = assurance_level
          @impersonated = impersonated
          @transport = transport
          @hook_point = hook_point
          @mfa = mfa
          @roles = roles
          @scopes = scopes
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @provider == other.provider
          return false unless @issuer == other.issuer
          return false unless @subject == other.subject
          return false unless @verified == other.verified
          return false unless @audience == other.audience
          return false unless @audiences == other.audiences
          return false unless @session_id == other.session_id
          return false unless @organization_id == other.organization_id
          return false unless @tenant_id == other.tenant_id
          return false unless @token_id == other.token_id
          return false unless @issued_at == other.issued_at
          return false unless @expires_at == other.expires_at
          return false unless @session_created_at == other.session_created_at
          return false unless @auth_time == other.auth_time
          return false unless @account_created_at == other.account_created_at
          return false unless @email_verified == other.email_verified
          return false unless @phone_verified == other.phone_verified
          return false unless @assurance_level == other.assurance_level
          return false unless @impersonated == other.impersonated
          return false unless @transport == other.transport
          return false unless @hook_point == other.hook_point
          return false unless @mfa == other.mfa
          return false unless @roles == other.roles
          return false unless @scopes == other.scopes
          true
        end
      end
    end
  end
end
