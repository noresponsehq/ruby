# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A change to one flow. A field left out keeps the value in force. Thresholds set on login or purchase start from the values in force, account_creation's while it inherits them. After the change, 0 < step_up < review <= 100 and block is off or review <= block <= 100.
      class FlowChange
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :step_up,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("step_up")}}
        )

        field(
          :review,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review")}}
        )
        # The depth a request for this flow that names none is served at. Defaults: full for account_creation and purchase, quick for login.
        field(
          :default_depth,
          Crystalline::Nilable.new(Models::Shared::DefaultDepth),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("default_depth"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::DefaultDepth, true)
            }
          }
        )
        # Login or purchase only: drop the flow's own thresholds so it uses account_creation's again. Not combined with step_up, review or block. Send true; false is refused.
        field(
          :inherits_account_creation,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("inherits_account_creation")}}
        )
        # Alias of inherits_account_creation, still accepted. Send true; false is refused.
        #
        # @deprecated true: This will be removed in a future release, please migrate away from it as soon as possible.
        field(
          :inherits_signup,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("inherits_signup")}}
        )
        # immediate (the default): an assessment of this flow is decided from the evidence its answer has, and later evidence may change the decision. held: while the account's current assessment of this flow has not completed, the account's decision for the flow is held, and the final decision arrives as account.risk_changed when the investigation completes or hold_seconds pass, whichever is first. Each flow has its own admission.
        field(
          :admission,
          Crystalline::Nilable.new(Models::Shared::Admission),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("admission"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Admission, true)
            }
          }
        )
        # How long a held flow's assessment is held after it was created, 30 to 86400 seconds (default 300). Kept while the flow is immediate.
        field(
          :hold_seconds,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("hold_seconds")}}
        )
        # The decision a held assessment takes when hold_seconds pass before its investigation completes, unless the evidence so far gives a stricter one (default review). It is announced as account.risk_changed like any other change, so an expired hold is always announced. A hosted provider hook, which cannot wait, answers a held account by it at once: deny for block, allow otherwise. Kept while the flow is immediate.
        field(
          :on_expiry,
          Crystalline::Nilable.new(Models::Shared::OnExpiry),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("on_expiry"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::OnExpiry, true)
            }
          }
        )
        # The score from which the decision is block; null turns blocking off.
        field(
          :block,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block")}}
        )

        sig {
          params(
            step_up: T.nilable(::Integer),
            review: T.nilable(::Integer),
            default_depth: T.nilable(Models::Shared::DefaultDepth),
            inherits_account_creation: T.nilable(T::Boolean),
            inherits_signup: T.nilable(T::Boolean),
            admission: T.nilable(Models::Shared::Admission),
            hold_seconds: T.nilable(::Integer),
            on_expiry: T.nilable(Models::Shared::OnExpiry),
            block: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          step_up: nil,
          review: nil,
          default_depth: nil,
          inherits_account_creation: nil,
          inherits_signup: nil,
          admission: nil,
          hold_seconds: nil,
          on_expiry: nil,
          block: nil
        )
          @step_up = step_up
          @review = review
          @default_depth = default_depth
          @inherits_account_creation = inherits_account_creation
          @inherits_signup = inherits_signup
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
          return false unless @inherits_signup == other.inherits_signup
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
