# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ErasureReceiptTarget
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :name,
          Models::Shared::ErasureReceiptTargetName,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("name"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ErasureReceiptTargetName, false)
            }
          }
        )

        field(
          :status,
          Models::Shared::ErasureReceiptTargetStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ErasureReceiptTargetStatus, false)
            }
          }
        )

        field(
          :completed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("completed_at")}}
        )

        sig {
          params(
            name: Models::Shared::ErasureReceiptTargetName,
            status: Models::Shared::ErasureReceiptTargetStatus,
            completed_at: T.nilable(::String)
          )
            .void
        }
        def initialize(name:, status:, completed_at: nil)
          @name = name
          @status = status
          @completed_at = completed_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @status == other.status
          return false unless @completed_at == other.completed_at
          true
        end
      end
    end
  end
end
