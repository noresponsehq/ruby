# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One post a collector read, with its permalink and time.
      class ScreeningPost
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field :text, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("text"), required: true}}

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
          :reply_to,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reply_to")}}
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
            text: ::String,
            profile_id: ::String,
            permalink: ::String,
            posted_at: ::String,
            kind: ::String,
            reply_to: T.nilable(::String),
            screenshot_sha256: T.nilable(::String),
            captured_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          text:,
          profile_id:,
          permalink:,
          posted_at:,
          kind: "post",
          reply_to: nil,
          screenshot_sha256: nil,
          captured_at: nil
        )
          @id = id
          @text = text
          @profile_id = profile_id
          @permalink = permalink
          @posted_at = posted_at
          unless kind == "post"
            raise ArgumentError, "Invalid value for kind"
          end

          @kind = "post"
          @reply_to = reply_to
          @screenshot_sha256 = screenshot_sha256
          @captured_at = captured_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @text == other.text
          return false unless @profile_id == other.profile_id
          return false unless @permalink == other.permalink
          return false unless @posted_at == other.posted_at
          return false unless @kind == other.kind
          return false unless @reply_to == other.reply_to
          return false unless @screenshot_sha256 == other.screenshot_sha256
          return false unless @captured_at == other.captured_at
          true
        end
      end
    end
  end
end
