# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What an analyser saw in one image that a finding rests on.
      class ScreeningMediaObservation
        extend T::Sig
        include Crystalline::MetadataFields

        # The image, one of the finding's evidence.
        field(
          :media_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("media_id"), required: true}}
        )
        # What the analyser saw in the image that supports the finding.
        field(
          :description,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("description"), required: true}}
        )
        # Words the analyser read in the image, as it read them. They come from the image's pixels, not from a post's text, so they are not a quote and were not checked against the record.
        field(
          :read_text,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("read_text")}}
        )

        sig { params(media_id: ::String, description: ::String, read_text: T.nilable(::String)).void }
        def initialize(media_id:, description:, read_text: nil)
          @media_id = media_id
          @description = description
          @read_text = read_text
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @media_id == other.media_id
          return false unless @description == other.description
          return false unless @read_text == other.read_text
          true
        end
      end
    end
  end
end
