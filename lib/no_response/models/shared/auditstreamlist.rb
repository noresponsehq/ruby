# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read audit stream subscriptions.
      class AuditStreamList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AuditStream),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::AuditStream]).void }
        def initialize(items:)
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
