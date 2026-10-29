# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # List your private and shared review filters.
      class ReviewViewList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::ReviewView),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::ReviewView]).void }
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
