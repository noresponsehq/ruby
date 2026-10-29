# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Current customer-reported labels, not independently established ground truth. Missing keys mean zero. Unknown is an explicit report; absent or expired feedback is unreported.
      class OutcomesByOutcome
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :confirmed_abuse,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("confirmed_abuse")}}
        )

        field(
          :account_takeover,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_takeover")}}
        )

        field(
          :chargeback,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("chargeback")}}
        )

        field(
          :false_positive,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("false_positive")}}
        )

        field(
          :legitimate,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("legitimate")}}
        )

        field(
          :unknown,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unknown")}}
        )

        sig {
          params(
            confirmed_abuse: T.nilable(::Integer),
            account_takeover: T.nilable(::Integer),
            chargeback: T.nilable(::Integer),
            false_positive: T.nilable(::Integer),
            legitimate: T.nilable(::Integer),
            unknown: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          confirmed_abuse: nil,
          account_takeover: nil,
          chargeback: nil,
          false_positive: nil,
          legitimate: nil,
          unknown: nil
        )
          @confirmed_abuse = confirmed_abuse
          @account_takeover = account_takeover
          @chargeback = chargeback
          @false_positive = false_positive
          @legitimate = legitimate
          @unknown = unknown
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @confirmed_abuse == other.confirmed_abuse
          return false unless @account_takeover == other.account_takeover
          return false unless @chargeback == other.chargeback
          return false unless @false_positive == other.false_positive
          return false unless @legitimate == other.legitimate
          return false unless @unknown == other.unknown
          true
        end
      end
    end
  end
end
