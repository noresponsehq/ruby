# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Changes of the account decision for an assessment's flow after its first answer, as account.risk_changed announces them, counted in the bucket of the assessment's creation. from is the decision announced before (allow before the first announcement); an assessment that changes twice counts twice.
      class AggregateLateFlip
        extend T::Sig
        include Crystalline::MetadataFields

        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
        field(
          :from,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("from"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )
        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
        field(
          :to,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("to"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )
        # How long after the assessment's creation the change was made.
        field(
          :delay,
          Models::Shared::Delay,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("delay"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Delay, false)
            }
          }
        )

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )

        sig {
          params(
            from: Models::Shared::AccountDecision,
            to: Models::Shared::AccountDecision,
            delay: Models::Shared::Delay,
            count: ::Integer
          )
            .void
        }
        def initialize(from:, to:, delay:, count:)
          @from = from
          @to = to
          @delay = delay
          @count = count
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @delay == other.delay
          return false unless @count == other.count
          true
        end
      end
    end
  end
end
