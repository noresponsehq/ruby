# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskSummaryEmail
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :disposable,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("disposable")}}
        )
        # Accounts found for the email.
        field(
          :accounts_found,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts_found")}}
        )
        # Breach facts for one selector. found is the one required member: false is a definite 'in no breach table'. Every other member is optional, and absent makes no claim. No member carries a breach value, password or hash, and unknown members are refused. truncated means the value matched more tables or records than the lookup keeps, so absence-based claims (a missing name match, for example) are withheld; a truncated result is always found.
        field(
          :breach,
          Crystalline::Nilable.new(Models::Shared::BreachSummary),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("breach")}}
        )

        sig {
          params(
            disposable: T.nilable(T::Boolean),
            accounts_found: T.nilable(::Integer),
            breach: T.nilable(Models::Shared::BreachSummary)
          )
            .void
        }
        def initialize(disposable: nil, accounts_found: nil, breach: nil)
          @disposable = disposable
          @accounts_found = accounts_found
          @breach = breach
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @disposable == other.disposable
          return false unless @accounts_found == other.accounts_found
          return false unless @breach == other.breach
          true
        end
      end
    end
  end
end
