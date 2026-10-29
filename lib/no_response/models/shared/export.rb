# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retained review snapshot.
      class Export
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :exported_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("exported_at"), required: true}}
        )

        field(
          :review,
          Models::Shared::Review,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review"), required: true}}
        )

        field(
          :comments,
          Crystalline::Array.new(Models::Shared::ReviewComment),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("comments"), required: true}}
        )

        field(
          :resolutions,
          Crystalline::Array.new(Models::Shared::Resolution),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("resolutions"), required: true}}
        )

        field(
          :subjects,
          Crystalline::Array.new(Models::Shared::ReviewSubject),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("subjects"), required: true}}
        )

        sig {
          params(
            exported_at: ::String,
            review: Models::Shared::Review,
            comments: T::Array[Models::Shared::ReviewComment],
            resolutions: T::Array[Models::Shared::Resolution],
            subjects: T::Array[Models::Shared::ReviewSubject]
          )
            .void
        }
        def initialize(exported_at:, review:, comments:, resolutions:, subjects:)
          @exported_at = exported_at
          @review = review
          @comments = comments
          @resolutions = resolutions
          @subjects = subjects
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @exported_at == other.exported_at
          return false unless @review == other.review
          return false unless @comments == other.comments
          return false unless @resolutions == other.resolutions
          return false unless @subjects == other.subjects
          true
        end
      end
    end
  end
end
