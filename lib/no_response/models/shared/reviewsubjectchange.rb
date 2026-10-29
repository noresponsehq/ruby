# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The link and resulting review version.
      class ReviewSubjectChange
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :review_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_version"), required: true}}
        )
        # A tenant-local investigation link. risk_version is the account risk version captured when the link was added. It does not assert a relationship or change feedback or enforcement.
        field(
          :subject,
          Models::Shared::ReviewSubject,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("subject"), required: true}}
        )

        sig { params(review_version: ::Integer, subject: Models::Shared::ReviewSubject).void }
        def initialize(review_version:, subject:)
          @review_version = review_version
          @subject = subject
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @review_version == other.review_version
          return false unless @subject == other.subject
          true
        end
      end
    end
  end
end
