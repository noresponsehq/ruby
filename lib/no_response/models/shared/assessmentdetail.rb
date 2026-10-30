# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One assessment's own facts: its score and recommendation, the signals behind them, the lanes still running and its timing. risk here is this assessment's own score; the account's current risk is the account member of the assessment. risk and recommendation are present for complete and partial; assessment_url is present for pending.
      class AssessmentDetail
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.
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
        # Evidence coverage: how much of the planned source evidence gave a definite answer. This is not confidence that an identity is genuine, agreement between identifiers, a risk score or a probability. unavailable means no usable evidence answered; a terminal uncovered assessment can have this value and recommend review.
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
        # Version of the hand-authored heuristic policy that produced the recommendation, for example 'risk-2026-10.7'. A workspace threshold override adds a +t<N> suffix, e.g. 'risk-2026-10.7+t3'.
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
          Models::Shared::AssessmentDetailTiming,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("timing"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # The identifiers an assessment was sent: each member of the request's identifiers object exactly as received, before the server normalised it (the email domain keeps its case, the name its Unicode form). A member the request did not send is absent. NoResponse keeps them encrypted under the workspace's own key, does not index or log them, and deletes them with the assessment: on DELETE of the assessment or its account, at its expires_at, and with the workspace.
        field(
          :identifiers,
          Crystalline::Nilable.new(Models::Shared::SentIdentifiers),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("identifiers")}}
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
        # The one risk decision for this event. score is 0 (safe) to 100 (risky), set by the reasons that fired under a hand-set, versioned heuristic policy. Each reason carries its direction and impact band; the policy's weights are not published. Every answer with a recommendation carries it, and the top-level recommendation equals risk.recommendation. It names no source or provider.
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
        # The identity fields of the auth context the assessment was made with, echoed for the workspace's own correlation: the request's auth_context, or the one a hosted provider hook (POST /hooks/{integration_id}) built, with transport provider_hook and its hook_point. Present exactly when the request carried an auth_context, and the same on every revision of the assessment. Values are as the request or the hook sent them; tokens, timestamps, roles and scopes are not echoed, and the echo does not change the score.
        field(
          :auth_context,
          Crystalline::Nilable.new(Models::Shared::AssessmentDetailAuthContext),
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
            timing: Models::Shared::AssessmentDetailTiming,
            schema_version: ::String,
            identifiers: T.nilable(Models::Shared::SentIdentifiers),
            request_id: T.nilable(::String),
            recommendation: T.nilable(Models::Shared::Recommendation),
            risk: T.nilable(Models::Shared::Risk),
            signals: T.nilable(T::Array[Models::Shared::Signal]),
            policy_basis: ::String,
            assessment_url: T.nilable(::String),
            auth_context: T.nilable(Models::Shared::AssessmentDetailAuthContext)
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
          identifiers: nil,
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
          @identifiers = identifiers
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
          return false unless @identifiers == other.identifiers
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
