# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One assessment of one account, as POST /v1/assessments, GET /v1/assessments/{assessment_id} and the assessment.updated webhook return it. status says whether it is final (complete), usable with a source still running (partial) or not yet usable (pending). risk and recommendation are present for complete and partial; assessment_url is present for pending. Keep the highest assessment_version.
      class Assessment
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the tenant; another tenant's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Your own opaque identifier for the account being checked, scoped to your tenant. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused, as is a JWT; a hex digest such as a SHA-256 is allowed. It travels only in request bodies. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # complete: final; nothing is still running. A lane that failed or missed its 10 s deadline stays listed in incomplete_sources, and confidence is lower. partial: a recommendation exists and at least one lane is still running or did not settle (see incomplete_sources). pending: nothing usable before the deadline; no recommendation yet, poll or wait for the webhook.
        field(
          :status,
          Models::Shared::Status,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Status, false)
            }
          }
        )
        # Ordinal confidence in the recommendation under the current policy: low, medium, high or unavailable.
        field(
          :confidence,
          Models::Shared::Confidence,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("confidence"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Confidence, false)
            }
          }
        )
        # The lanes that did not settle, each listed once with a reason; lanes, not sources. In a detailed view a lane is listed exactly when one of its signals did not settle; a standard view carries no signals to match.
        field(
          :incomplete_sources,
          Crystalline::Array.new(Models::Shared::IncompleteSource),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("incomplete_sources"), required: true}}
        )
        # Version of the hand-authored heuristic weights that produced the recommendation, for example 'risk-2026-10.7'. A tenant threshold override adds a +t<N> suffix, e.g. 'risk-2026-10.7+t3'.
        field(
          :policy_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )
        # Monotonic revision of this assessment. 1 on the synchronous answer; each material change while the assessment is served (an async continuation settling a source, a change of recommendation, confidence or status) increments it. Expiry does not increment it: an expired assessment is gone, not revised, and the expiry webhook carries the last served version.
        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
        )
        # When the assessment was created. Fixed for the life of the assessment: every revision carries the same created_at.
        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # After this instant the assessment is no longer served: GET /v1/assessments/{assessment_id} answers 404 and it leaves the account history. It is created_at plus your retention period at creation (default and maximum 365 days) and is fixed per record: a later revision keeps it, and a new assessment for the same account starts its own clock. If you later shorten retention, the effective expiry becomes created_at plus the shorter of the two periods.
        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :timing,
          Models::Shared::AssessmentTiming,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("timing"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # An optional provider correlation id, echoed back. It is not an idempotency key. Refuses an exact-shape JWT or a bare 40, 64 or 128 character hex digest; a UUID is accepted.
        field(
          :request_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id")}}
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
        # The one risk decision for this event. score is 0 (safe) to 100 (risky): the sum of the weights of the reasons that fired, clamped to 0 to 100, from hand-set versioned weights. Every answer with a recommendation carries it, and the top-level recommendation equals risk.recommendation. It names no source or provider.
        field(
          :risk,
          Crystalline::Nilable.new(Models::Shared::Risk),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk")}}
        )
        # Detailed view only (response_mode=detailed, which needs the detailed scope): a standard answer omits signals[], and a detailed one always carries it, possibly empty. The body does not name its mode, so that rule is the serving gate's; the schema states the half it can: an answer with risk.details is a detailed view and carries signals[]. At most one signal per (type, source_id, identifier).
        field(
          :signals,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Signal)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signals")}}
        )
        # Labels the v0 policy as hand-authored and not statistically validated.
        field(
          :policy_basis,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_basis"), required: true}}
        )
        # Server-relative path of the authoritative assessment, GET /v1/assessments/{assessment_id}.
        field(
          :assessment_url,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_url")}}
        )
        # The identity fields of the auth context the assessment was made with, echoed for the tenant's own correlation: the request's auth_context, or the one a hosted provider hook (POST /hooks/{integration_id}) built, with transport provider_hook and its hook_point. Present exactly when the request carried an auth_context, and the same on every revision of the assessment. Values are as the request or the hook sent them; tokens, timestamps, roles and scopes are not echoed, and the echo does not change the score.
        field(
          :auth_context,
          Crystalline::Nilable.new(Models::Shared::AssessmentAuthContext),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("auth_context")}}
        )

        sig {
          params(
            assessment_id: ::String,
            account_id: ::String,
            status: Models::Shared::Status,
            confidence: Models::Shared::Confidence,
            incomplete_sources: T::Array[Models::Shared::IncompleteSource],
            policy_version: ::String,
            assessment_version: ::Integer,
            created_at: ::String,
            updated_at: ::String,
            expires_at: ::String,
            timing: Models::Shared::AssessmentTiming,
            schema_version: ::String,
            request_id: T.nilable(::String),
            recommendation: T.nilable(Models::Shared::Recommendation),
            risk: T.nilable(Models::Shared::Risk),
            signals: T.nilable(T::Array[Models::Shared::Signal]),
            policy_basis: ::String,
            assessment_url: T.nilable(::String),
            auth_context: T.nilable(Models::Shared::AssessmentAuthContext)
          )
            .void
        }
        def initialize(
          assessment_id:,
          account_id:,
          status:,
          confidence:,
          incomplete_sources:,
          policy_version:,
          assessment_version:,
          created_at:,
          updated_at:,
          expires_at:,
          timing:,
          schema_version: "1",
          request_id: nil,
          recommendation: nil,
          risk: nil,
          signals: nil,
          policy_basis: "heuristic_unvalidated",
          assessment_url: nil,
          auth_context: nil
        )
          @assessment_id = assessment_id
          @account_id = account_id
          @status = status
          @confidence = confidence
          @incomplete_sources = incomplete_sources
          @policy_version = policy_version
          @assessment_version = assessment_version
          @created_at = created_at
          @updated_at = updated_at
          @expires_at = expires_at
          @timing = timing
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @request_id = request_id
          @recommendation = recommendation
          @risk = risk
          @signals = signals
          unless policy_basis == "heuristic_unvalidated"
            raise ArgumentError, "Invalid value for policy_basis"
          end

          @policy_basis = "heuristic_unvalidated"
          @assessment_url = assessment_url
          @auth_context = auth_context
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @account_id == other.account_id
          return false unless @status == other.status
          return false unless @confidence == other.confidence
          return false unless @incomplete_sources == other.incomplete_sources
          return false unless @policy_version == other.policy_version
          return false unless @assessment_version == other.assessment_version
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @expires_at == other.expires_at
          return false unless @timing == other.timing
          return false unless @schema_version == other.schema_version
          return false unless @request_id == other.request_id
          return false unless @recommendation == other.recommendation
          return false unless @risk == other.risk
          return false unless @signals == other.signals
          return false unless @policy_basis == other.policy_basis
          return false unless @assessment_url == other.assessment_url
          return false unless @auth_context == other.auth_context
          true
        end
      end
    end
  end
end
