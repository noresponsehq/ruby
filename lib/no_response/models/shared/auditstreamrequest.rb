# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AuditStreamRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )

        field(
          :actions,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actions")}}
        )

        sig { params(endpoint_id: ::String, actions: T.nilable(T::Array[::String])).void }
        def initialize(endpoint_id:, actions: nil)
          @endpoint_id = endpoint_id
          @actions = actions
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @actions == other.actions
          true
        end
      end
    end
  end
end
