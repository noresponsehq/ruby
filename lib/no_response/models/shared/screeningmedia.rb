# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One image or video a collector read, with the post that carried it.
      class ScreeningMedia
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :media_type,
          Models::Shared::MediaType,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("media_type"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::MediaType, false)
            }
          }
        )
        # Where the platform serves the image or video.
        field(
          :media_url,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("media_url"), required: true}}
        )

        field(
          :profile_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("profile_id"), required: true}}
        )

        field(
          :permalink,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("permalink"), required: true}}
        )

        field(
          :posted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("posted_at"), required: true}}
        )

        field :kind, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind"), required: true}}

        field(
          :post_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("post_id")}}
        )
        # The caption or alt text.
        field(
          :text,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("text")}}
        )
        # SHA-256 of the screenshot taken of a flagged item.
        field(
          :screenshot_sha256,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("screenshot_sha256")}}
        )
        # When the screenshot was taken.
        field(
          :captured_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("captured_at")}}
        )

        sig {
          params(
            id: ::String,
            media_type: Models::Shared::MediaType,
            media_url: ::String,
            profile_id: ::String,
            permalink: ::String,
            posted_at: ::String,
            kind: ::String,
            post_id: T.nilable(::String),
            text: T.nilable(::String),
            screenshot_sha256: T.nilable(::String),
            captured_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          media_type:,
          media_url:,
          profile_id:,
          permalink:,
          posted_at:,
          kind: "media",
          post_id: nil,
          text: nil,
          screenshot_sha256: nil,
          captured_at: nil
        )
          @id = id
          @media_type = media_type
          @media_url = media_url
          @profile_id = profile_id
          @permalink = permalink
          @posted_at = posted_at
          unless kind == "media"
            raise ArgumentError, "Invalid value for kind"
          end

          @kind = "media"
          @post_id = post_id
          @text = text
          @screenshot_sha256 = screenshot_sha256
          @captured_at = captured_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @media_type == other.media_type
          return false unless @media_url == other.media_url
          return false unless @profile_id == other.profile_id
          return false unless @permalink == other.permalink
          return false unless @posted_at == other.posted_at
          return false unless @kind == other.kind
          return false unless @post_id == other.post_id
          return false unless @text == other.text
          return false unless @screenshot_sha256 == other.screenshot_sha256
          return false unless @captured_at == other.captured_at
          true
        end
      end
    end
  end
end
