# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Breach facts for one selector. found is the one required member: false is a definite 'in no breach table'. Every other member is optional, and absent makes no claim. No member carries a breach value, password or hash, and unknown members are refused. truncated means the value matched more tables or records than the lookup keeps, so absence-based claims (a missing name match, for example) are withheld; a truncated result is always found.
      class BreachSummary
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :found,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("found"), required: true}}
        )
        # Distinct breach tables the value appears in.
        field(
          :breach_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("breach_count")}}
        )
        # Year of the oldest dated table.
        field(
          :first_year,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("first_year")}}
        )
        # Year of the newest dated table.
        field(
          :last_year,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_year")}}
        )
        # The union of data kinds the matching tables held, without the values.
        field(
          :exposed,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::BreachExposed)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("exposed")}}
        )
        # The value is in a credential_list or stealer_log table.
        field(
          :in_credential_lists,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("in_credential_lists")}}
        )
        # A plaintext password sat next to the value in a table dated two years ago or less, or the value is in a stealer_log table.
        field(
          :recent_password_exposure,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("recent_password_exposure")}}
        )

        field(
          :truncated,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("truncated")}}
        )

        sig {
          params(
            found: T::Boolean,
            breach_count: T.nilable(::Integer),
            first_year: T.nilable(::Integer),
            last_year: T.nilable(::Integer),
            exposed: T.nilable(T::Array[Models::Shared::BreachExposed]),
            in_credential_lists: T.nilable(T::Boolean),
            recent_password_exposure: T.nilable(T::Boolean),
            truncated: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(
          found:,
          breach_count: nil,
          first_year: nil,
          last_year: nil,
          exposed: nil,
          in_credential_lists: nil,
          recent_password_exposure: nil,
          truncated: nil
        )
          @found = found
          @breach_count = breach_count
          @first_year = first_year
          @last_year = last_year
          @exposed = exposed
          @in_credential_lists = in_credential_lists
          @recent_password_exposure = recent_password_exposure
          @truncated = truncated
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @found == other.found
          return false unless @breach_count == other.breach_count
          return false unless @first_year == other.first_year
          return false unless @last_year == other.last_year
          return false unless @exposed == other.exposed
          return false unless @in_credential_lists == other.in_credential_lists
          return false unless @recent_password_exposure == other.recent_password_exposure
          return false unless @truncated == other.truncated
          true
        end
      end
    end
  end
end
