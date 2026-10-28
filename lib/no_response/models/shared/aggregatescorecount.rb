# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # First answers of one flow whose risk.score is in [score_min, score_max]: 0-4, 5-9 up to 95-100. A pending answer has no score.
      class AggregateScoreCount
        extend T::Sig
        include Crystalline::MetadataFields

        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Models::Shared::Flow,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, false)
            }
          }
        )
        # A multiple of 5.
        field(
          :score_min,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_min"), required: true}}
        )

        field(
          :score_max,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_max"), required: true}}
        )

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )

        sig { params(flow: Models::Shared::Flow, score_min: ::Integer, score_max: ::Integer, count: ::Integer).void }
        def initialize(flow:, score_min:, score_max:, count:)
          @flow = flow
          @score_min = score_min
          @score_max = score_max
          @count = count
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @flow == other.flow
          return false unless @score_min == other.score_min
          return false unless @score_max == other.score_max
          return false unless @count == other.count
          true
        end
      end
    end
  end
end
