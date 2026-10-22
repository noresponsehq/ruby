# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/assessments body. At least one of email, username or phone is required; name and ip only refine an assessment. No field carries a password, hash, token or breach value, and unknown members are refused. The email local part is kept as received and only the domain is lower-cased; the username is compared case-insensitively; the phone is strict E.164 and is assessed asynchronously. The whole body is capped at 32768 bytes. client_context holds bounded hints from the signup client; auth_context holds normalised claims from a session your backend has verified. Raw tokens are refused.
      class AssessmentRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your tenant. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused, as is a JWT; a hex digest such as a SHA-256 is allowed. It travels only in request bodies. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # At least one of email, username or phone. name and ip refine the match and travel beside a lookup identifier; a body with only name or ip is refused with 400.
        field(
          :identifiers,
          Models::Shared::AssessmentRequestIdentifiers,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("identifiers"), required: true}}
        )

        field(
          :policy_context,
          Crystalline::Nilable.new(Models::Shared::AssessmentRequestPolicyContext),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_context")}}
        )
        # An optional provider correlation id, echoed back. It is not an idempotency key. Refuses an exact-shape JWT or a bare 40, 64 or 128 character hex digest; a UUID is accepted.
        field(
          :request_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id")}}
        )
        # Optional tighter budget, 50 to 500 ms, measured from the moment the request reaches NoResponse. Absent means the 500 ms ceiling; a value above it is refused with 400 rather than clamped.
        field(
          :deadline_ms,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deadline_ms")}}
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
        # Optional context observed by your signup client. The server parses these hints into coarse features, leaves raw user_agent and opaque ids out of every answer, and weighs a mismatch with the other evidence.
        field(
          :client_context,
          Crystalline::Nilable.new(Models::Shared::AssessmentRequestClientContext),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("client_context")}}
        )
        # Normalised claims from a session your backend has already verified with WorkOS, Clerk, Auth0 or any OIDC provider. Pass the output of the SDK's auth adapters, not a raw token.
        field(
          :auth_context,
          Crystalline::Nilable.new(Models::Shared::AuthContext),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("auth_context")}}
        )
        # Optional. When the signup gate issues an API key to the new account, send SHA-256 of that key, so later usage of the key, or a leaked copy, ties back to this assessment. Each SDK has a helper that computes it. Send only the hash: customer keys are high-entropy, so the hash reveals nothing about them. The assessment stores it, and no response, webhook or log carries it.
        field(
          :issued_credential,
          Crystalline::Nilable.new(Models::Shared::AssessmentRequestIssuedCredential),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("issued_credential")}}
        )

        sig {
          params(
            account_id: ::String,
            identifiers: Models::Shared::AssessmentRequestIdentifiers,
            policy_context: T.nilable(Models::Shared::AssessmentRequestPolicyContext),
            request_id: T.nilable(::String),
            deadline_ms: T.nilable(::Integer),
            response_mode: T.nilable(Models::Shared::ResponseMode),
            client_context: T.nilable(Models::Shared::AssessmentRequestClientContext),
            auth_context: T.nilable(Models::Shared::AuthContext),
            issued_credential: T.nilable(Models::Shared::AssessmentRequestIssuedCredential)
          )
            .void
        }
        def initialize(
          account_id:,
          identifiers:,
          policy_context: nil,
          request_id: nil,
          deadline_ms: nil,
          response_mode: nil,
          client_context: nil,
          auth_context: nil,
          issued_credential: nil
        )
          @account_id = account_id
          @identifiers = identifiers
          @policy_context = policy_context
          @request_id = request_id
          @deadline_ms = deadline_ms
          @response_mode = response_mode
          @client_context = client_context
          @auth_context = auth_context
          @issued_credential = issued_credential
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @identifiers == other.identifiers
          return false unless @policy_context == other.policy_context
          return false unless @request_id == other.request_id
          return false unless @deadline_ms == other.deadline_ms
          return false unless @response_mode == other.response_mode
          return false unless @client_context == other.client_context
          return false unless @auth_context == other.auth_context
          return false unless @issued_credential == other.issued_credential
          true
        end
      end
    end
  end
end
