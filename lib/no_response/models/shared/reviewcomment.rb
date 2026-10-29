# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewComment
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :review_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_version"), required: true}}
        )

        field :body, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("body"), required: true}}

        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        sig {
          params(id: ::String, review_version: ::Integer, body: ::String, created_by: ::String, created_at: ::String)
            .void
        }
        def initialize(id:, review_version:, body:, created_by:, created_at:)
          @id = id
          @review_version = review_version
          @body = body
          @created_by = created_by
          @created_at = created_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @review_version == other.review_version
          return false unless @body == other.body
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          true
        end
      end
    end
  end
end
