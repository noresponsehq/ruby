# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retrieve one consistent snapshot of retained customer-accessible records, including assessment revisions, account decisions, feedback, key associations, enforcements and request diagnostics. Secrets, restricted source information, other customers' data and legacy free-text notes are excluded. The same standard/detailed permissions apply. An export exceeding 10000 records or 8 MiB returns export_too_large without a partial result. Historical decisions that were not captured are identified as an exclusion.
      class AccountExport
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :exported_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("exported_at"), required: true}}
        )

        field(
          :current_risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("current_risk_version"), required: true}}
        )

        field(
          :assessments,
          Crystalline::Array.new(Models::Shared::AssessmentRevision),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessments"), required: true}}
        )

        field(
          :decisions,
          Crystalline::Array.new(Models::Shared::AccountDecisionSnapshot),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decisions"), required: true}}
        )

        field(
          :outcomes,
          Crystalline::Array.new(Models::Shared::AccountOutcome),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("outcomes"), required: true}}
        )

        field(
          :assessment_outcomes,
          Crystalline::Array.new(Models::Shared::ExportAssessmentOutcome),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_outcomes"), required: true}}
        )

        field(
          :credentials,
          Crystalline::Array.new(Models::Shared::CredentialAssociation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("credentials"), required: true}}
        )

        field(
          :bindings,
          Crystalline::Array.new(Models::Shared::AccountBinding),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("bindings"), required: true}}
        )

        field(
          :enforcements,
          Crystalline::Array.new(Models::Shared::Enforcement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("enforcements"), required: true}}
        )

        field(
          :requests,
          Crystalline::Array.new(Models::Shared::RequestDiagnostic),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("requests"), required: true}}
        )

        field(
          :exclusions,
          Crystalline::Array.new(Models::Shared::Exclusion),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("exclusions"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )

        field(
          :complete,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("complete"), required: true}}
        )

        sig {
          params(
            account_id: ::String,
            exported_at: ::String,
            current_risk_version: ::Integer,
            assessments: T::Array[Models::Shared::AssessmentRevision],
            decisions: T::Array[Models::Shared::AccountDecisionSnapshot],
            outcomes: T::Array[Models::Shared::AccountOutcome],
            assessment_outcomes: T::Array[Models::Shared::ExportAssessmentOutcome],
            credentials: T::Array[Models::Shared::CredentialAssociation],
            bindings: T::Array[Models::Shared::AccountBinding],
            enforcements: T::Array[Models::Shared::Enforcement],
            requests: T::Array[Models::Shared::RequestDiagnostic],
            exclusions: T::Array[Models::Shared::Exclusion],
            schema_version: ::String,
            complete: T::Boolean
          )
            .void
        }
        def initialize(
          account_id:,
          exported_at:,
          current_risk_version:,
          assessments:,
          decisions:,
          outcomes:,
          assessment_outcomes:,
          credentials:,
          bindings:,
          enforcements:,
          requests:,
          exclusions:,
          schema_version: "1",
          complete: true
        )
          @account_id = account_id
          @exported_at = exported_at
          @current_risk_version = current_risk_version
          @assessments = assessments
          @decisions = decisions
          @outcomes = outcomes
          @assessment_outcomes = assessment_outcomes
          @credentials = credentials
          @bindings = bindings
          @enforcements = enforcements
          @requests = requests
          @exclusions = exclusions
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          unless complete == true
            raise ArgumentError, "Invalid value for complete"
          end

          @complete = true
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @exported_at == other.exported_at
          return false unless @current_risk_version == other.current_risk_version
          return false unless @assessments == other.assessments
          return false unless @decisions == other.decisions
          return false unless @outcomes == other.outcomes
          return false unless @assessment_outcomes == other.assessment_outcomes
          return false unless @credentials == other.credentials
          return false unless @bindings == other.bindings
          return false unless @enforcements == other.enforcements
          return false unless @requests == other.requests
          return false unless @exclusions == other.exclusions
          return false unless @schema_version == other.schema_version
          return false unless @complete == other.complete
          true
        end
      end
    end
  end
end
