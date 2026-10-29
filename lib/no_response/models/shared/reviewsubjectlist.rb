# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retained tenant-local subject links and the current review version.
      class ReviewSubjectList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :review_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_version"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::ReviewSubject),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(review_version: ::Integer, items: T::Array[Models::Shared::ReviewSubject]).void }
        def initialize(review_version:, items:)
          @review_version = review_version
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @review_version == other.review_version
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
