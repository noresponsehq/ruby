# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One flow's policy in force. A score below step_up is allow, below review step_up, and from review review; from block, when present, the decision is block. admission says when the flow's decision is final.
      class FlowSettings
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :step_up,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("step_up"), required: true}}
        )

        field(
          :review,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review"), required: true}}
        )
        # The depth a request for this flow that names none is served at. Defaults: full for account_creation and purchase, quick for login.
        field(
          :default_depth,
          Models::Shared::DefaultDepth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("default_depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::DefaultDepth, false)
            }
          }
        )
        # true while this flow has no thresholds of its own and uses account_creation's, the default for login and purchase. Always false for signup.
        field(
          :inherits_account_creation,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("inherits_account_creation"), required: true}}
        )
        # immediate (the default): an assessment of this flow is decided from the evidence its answer has, and later evidence may change the decision. held: while the account's current assessment of this flow has not completed, the account's decision for the flow is held, and the final decision arrives as account.risk_changed when the investigation completes or hold_seconds pass, whichever is first. Each flow has its own admission.
        field(
          :admission,
          Models::Shared::Admission,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("admission"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Admission, false)
            }
          }
        )
        # How long a held flow's assessment is held after it was created, 30 to 86400 seconds (default 300). Kept while the flow is immediate.
        field(
          :hold_seconds,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("hold_seconds"), required: true}}
        )
        # The decision a held assessment takes when hold_seconds pass before its investigation completes, unless the evidence so far gives a stricter one (default review). It is announced as account.risk_changed like any other change, so an expired hold is always announced. A hosted provider hook, which cannot wait, answers a held account by it at once: deny for block, allow otherwise. Kept while the flow is immediate.
        field(
          :on_expiry,
          Models::Shared::OnExpiry,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("on_expiry"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::OnExpiry, false)
            }
          }
        )
        # The score from which the decision is block. Absent while blocking is off, the default.
        field(
          :block,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block")}}
        )

        sig {
          params(
            step_up: ::Integer,
            review: ::Integer,
            default_depth: Models::Shared::DefaultDepth,
            inherits_account_creation: T::Boolean,
            admission: Models::Shared::Admission,
            hold_seconds: ::Integer,
            on_expiry: Models::Shared::OnExpiry,
            block: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          step_up:,
          review:,
          default_depth:,
          inherits_account_creation:,
          admission:,
          hold_seconds:,
          on_expiry:,
          block: nil
        )
          @step_up = step_up
          @review = review
          @default_depth = default_depth
          @inherits_account_creation = inherits_account_creation
          @admission = admission
          @hold_seconds = hold_seconds
          @on_expiry = on_expiry
          @block = block
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @step_up == other.step_up
          return false unless @review == other.review
          return false unless @default_depth == other.default_depth
          return false unless @inherits_account_creation == other.inherits_account_creation
          return false unless @admission == other.admission
          return false unless @hold_seconds == other.hold_seconds
          return false unless @on_expiry == other.on_expiry
          return false unless @block == other.block
          true
        end
      end
    end
  end
end
