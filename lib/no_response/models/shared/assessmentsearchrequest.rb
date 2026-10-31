# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Search retained assessments created in [from,to), at most 366 days. identifier matches the submitted value of each returned assessment directly. The legacy email filter keeps its account-wide mailbox semantics and cannot be combined with identifier. Other filters combine using AND and describe assessment decisions, separate from current account decisions. Results use newest-created order with an assessment-ID tie break and are live, not a snapshot across pages. Requires history or investigate authority; identifier, identifier_expression and email filtering also require identifier-read permission. Detailed response mode additionally requires detailed permission. No Idempotency-Key. identifier_expression requires scope assessment and matches the complete expression within each returned submission; account scope returns 400 invalid_request. At most 8 raw terms and 3 group levels. Mutually exclusive with identifier and email.
      class AssessmentSearchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )
        # Assessments of every account that one of its retained admitted assessments sent this mailbox as identifiers.email, matched as lists match an email entry: case-insensitive, a +tag removed and, at gmail.com and googlemail.com, the dots of the local part ignored. Only assessments stored since email list matching began carry the mailbox. An address that is not a valid mailbox is refused with 400.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::Flow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, true)
            }
          }
        )
        # Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.
        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::Status),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Status, true)
            }
          }
        )
        # api (the default) searches the assessments your integration sent. lookup searches the assessments your team ran by hand on the console's Lookup page. The API sets an assessment's origin from the credential that sent it. A lookup is not in any other list, count, webhook event or account.
        field(
          :origin,
          Crystalline::Nilable.new(Models::Shared::Origin),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("origin"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::Origin, true)
            }
          }
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
        # Opaque, expiring cursor bound to workspace, environment, operation and all filters, including expression scope, ordered structure and original term values. Keep grouping, operand order, matching modes and values unchanged; an omitted match is equivalent to exact. The page limit may change.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cursor")}}
        )
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, true)
            }
          }
        )
        # An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::Decision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Decision, true)
            }
          }
        )
        # Which answer of each assessment the filters describe: latest, the latest stored revision, or first, the first answer, as served when the assessment was first answered (POST /v1/assessments/aggregate counts first answers). A cell of an aggregate drills down to POST /v1/assessments/search with the same filters, revision first and the cell's bucket as from and to.
        field(
          :revision,
          Crystalline::Nilable.new(Models::Shared::AnswerRevision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("revision"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::AnswerRevision, true)
            }
          }
        )

        field(
          :band,
          Crystalline::Nilable.new(Models::Shared::Band),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("band"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Band, true)
            }
          }
        )
        # A stable reason code. New codes may appear; ignore any you do not know.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::ReasonCode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReasonCode, true)
            }
          }
        )
        # The selected reason's served impact band. Requires reason.
        field(
          :impact,
          Crystalline::Nilable.new(Models::Shared::Impact),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("impact"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Impact, true)
            }
          }
        )
        # An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.
        field(
          :lane,
          Crystalline::Nilable.new(Models::Shared::Lane),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("lane"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Lane, true)
            }
          }
        )

        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )

        field(
          :asn,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asn")}}
        )
        # Inclusive lower score bound. Pending answers without a score do not match.
        field(
          :score_min,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_min")}}
        )
        # Inclusive upper score bound, at least score_min when both are supplied.
        field(
          :score_max,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_max")}}
        )
        # The list action captured at the first answer. Requires revision first. Older answers without captured list state do not match, including none.
        field(
          :list_match,
          Crystalline::Nilable.new(Models::Shared::ListMatch),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("list_match"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ListMatch, true)
            }
          }
        )
        # true returns only assessments whose latest stored revision's decision differs from their first answer's decision (see decision); false only the others. An assessment whose first answer or latest revision has no decision yet is not changed. Cannot be combined with revision first.
        field(
          :changed,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("changed")}}
        )
        # One customer-submitted identifier. Defaults to exact comparison of the original submitted value. canonical uses the supported identifier normalisation without an ownership claim: email preserves local-part case, NFC-normalises it and lowercases the domain without removing dots or tags; phone uses international E.164 without extensions or an inferred region; username uses NFC and Unicode case folding within the customer namespace. mailbox is email-only and explicitly selects existing list rules: case-insensitive, remove +tag, and ignore local-part dots at gmail.com and googlemail.com; googlemail.com maps to gmail.com. Username requires namespace customer. Email and phone forbid namespace. Source-discovered identifiers and platform handles are not searched. Unsupported kinds, namespaces, modes and invalid values return 400. Search equality does not establish verified ownership or merge accounts.
        field(
          :identifier,
          Crystalline::Nilable.new(Models::Shared::IdentifierSearch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("identifier")}}
        )
        # A bounded AND/OR expression over submitted identifiers. Required scope assessment means the entire expression must match one retained assessment. Scope account permits each term to match a different retained assessment of the same account and is accepted only by account search. Exactly one of term, and or or is allowed at every node. Groups contain 2 to 8 operands, with at most 3 nested group levels and 8 raw term occurrences over the entire expression. A root term is allowed. Duplicate terms with the same kind, match rule, namespace and normalized comparison are idempotent, but count toward the raw limit. Match rules default to exact and preserve the existing identifier contract. Only retained submitted identifiers can satisfy a term. Unknown fields, unsupported scopes and malformed or oversized expressions return 400 invalid_request.
        field(
          :identifier_expression,
          Crystalline::Nilable.new(Models::Shared::IdentifierExpression),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("identifier_expression")}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            account_id: T.nilable(::String),
            email: T.nilable(::String),
            flow: T.nilable(Models::Shared::Flow),
            status: T.nilable(Models::Shared::Status),
            origin: T.nilable(Models::Shared::Origin),
            recommendation: T.nilable(Models::Shared::Recommendation),
            cursor: T.nilable(::String),
            response_mode: T.nilable(Models::Shared::ResponseMode),
            decision: T.nilable(Models::Shared::Decision),
            revision: T.nilable(Models::Shared::AnswerRevision),
            band: T.nilable(Models::Shared::Band),
            reason: T.nilable(Models::Shared::ReasonCode),
            impact: T.nilable(Models::Shared::Impact),
            lane: T.nilable(Models::Shared::Lane),
            country: T.nilable(::String),
            asn: T.nilable(::Integer),
            score_min: T.nilable(::Integer),
            score_max: T.nilable(::Integer),
            list_match: T.nilable(Models::Shared::ListMatch),
            changed: T.nilable(T::Boolean),
            identifier: T.nilable(Models::Shared::IdentifierSearch),
            identifier_expression: T.nilable(Models::Shared::IdentifierExpression),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          from:,
          to:,
          account_id: nil,
          email: nil,
          flow: nil,
          status: nil,
          origin: nil,
          recommendation: nil,
          cursor: nil,
          response_mode: nil,
          decision: nil,
          revision: nil,
          band: nil,
          reason: nil,
          impact: nil,
          lane: nil,
          country: nil,
          asn: nil,
          score_min: nil,
          score_max: nil,
          list_match: nil,
          changed: nil,
          identifier: nil,
          identifier_expression: nil,
          limit: 20
        )
          @from = from
          @to = to
          @account_id = account_id
          @email = email
          @flow = flow
          @status = status
          @origin = origin
          @recommendation = recommendation
          @cursor = cursor
          @response_mode = response_mode
          @decision = decision
          @revision = revision
          @band = band
          @reason = reason
          @impact = impact
          @lane = lane
          @country = country
          @asn = asn
          @score_min = score_min
          @score_max = score_max
          @list_match = list_match
          @changed = changed
          @identifier = identifier
          @identifier_expression = identifier_expression
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @account_id == other.account_id
          return false unless @email == other.email
          return false unless @flow == other.flow
          return false unless @status == other.status
          return false unless @origin == other.origin
          return false unless @recommendation == other.recommendation
          return false unless @cursor == other.cursor
          return false unless @response_mode == other.response_mode
          return false unless @decision == other.decision
          return false unless @revision == other.revision
          return false unless @band == other.band
          return false unless @reason == other.reason
          return false unless @impact == other.impact
          return false unless @lane == other.lane
          return false unless @country == other.country
          return false unless @asn == other.asn
          return false unless @score_min == other.score_min
          return false unless @score_max == other.score_max
          return false unless @list_match == other.list_match
          return false unless @changed == other.changed
          return false unless @identifier == other.identifier
          return false unless @identifier_expression == other.identifier_expression
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
