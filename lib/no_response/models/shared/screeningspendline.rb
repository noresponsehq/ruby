# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What one implementation cost.
      class ScreeningSpendLine
        extend T::Sig
        include Crystalline::MetadataFields

        # The resolver, collector or analyser that produced a record, by its catalogue name.
        field(
          :implementation,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("implementation"), required: true}}
        )

        field(
          :role,
          Models::Shared::ScreeningSpendLineRole,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningSpendLineRole, false)
            }
          }
        )

        field(
          :spend_minor,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spend_minor"), required: true}}
        )

        sig {
          params(implementation: ::String, role: Models::Shared::ScreeningSpendLineRole, spend_minor: ::Integer).void
        }
        def initialize(implementation:, role:, spend_minor:)
          @implementation = implementation
          @role = role
          @spend_minor = spend_minor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @implementation == other.implementation
          return false unless @role == other.role
          return false unless @spend_minor == other.spend_minor
          true
        end
      end
    end
  end
end
