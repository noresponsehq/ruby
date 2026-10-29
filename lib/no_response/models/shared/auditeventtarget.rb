# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AuditEventTarget
        extend T::Sig
        include Crystalline::MetadataFields

        # The kind of resource the change acted on.
        field(
          :type,
          Models::Shared::AuditEventTargetType,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("type"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditEventTargetType, false)
            }
          }
        )
        # The resource's id, when it has one.
        field(
          :id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id")}}
        )

        sig { params(type: Models::Shared::AuditEventTargetType, id: T.nilable(::String)).void }
        def initialize(type:, id: nil)
          @type = type
          @id = id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @type == other.type
          return false unless @id == other.id
          true
        end
      end
    end
  end
end
