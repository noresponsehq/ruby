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
        # The permalink of the post this one reposts. text then holds that post's author's words, not the person's.
        field(
          :repost_of,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("repost_of")}}
        )
        # The permalink of the post this one quotes. text holds the person's own words alone.
        field(
          :quote_of,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("quote_of")}}
        )
        # A place a post names, as the platform shows it.
        field(
          :place,
          Crystalline::Nilable.new(Models::Shared::PostPlace),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("place")}}
        )
        # The handles of the accounts the post tags, on its own platform.
        field(
          :tagged,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("tagged")}}
        )
        # How many likes the platform shows for the post.
        field(
          :likes,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("likes")}}
        )
        # How many comments the platform shows for the post.
        field(
          :comments,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("comments")}}
        )
        # How many views or plays the platform shows for the post.
        field(
          :views,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("views")}}
        )
        # How many times the platform shows the post was shared or reposted.
        field(
          :shares,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("shares")}}
        )
        # The language the platform says the post is in, as the platform codes it, such as en or pt-BR.
        field(
          :language,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("language")}}
        )
        # true when the platform marks the post as edited after it went up. Absent when it does not mark it.
        field(
          :edited,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("edited")}}
        )
        # true when the platform marks the post as a paid partnership or an ad. Absent when it does not mark it.
        field(
          :sponsored,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sponsored")}}
        )
        # true when the platform labels the post as made or changed with AI. Absent when it does not label it.
        field(
          :ai_generated,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ai_generated")}}
        )
        # The app or device the platform says the post was made with.
        field(
          :posted_with,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("posted_with")}}
        )
        # Everything else the platform sent about the post, under the platform's own names and as it typed them: counts, ids of linked posts and accounts, links, media details, labels and notices. The fields above are not repeated here. Nothing that describes the account the screening read with, such as whether it liked or saved the post, is ever here.
        field(
          :stated,
          Crystalline::Nilable.new(Crystalline::Hash.new(Symbol, ::Object)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("stated")}}
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
            repost_of: T.nilable(::String),
            quote_of: T.nilable(::String),
            place: T.nilable(Models::Shared::PostPlace),
            tagged: T.nilable(T::Array[::String]),
            likes: T.nilable(::Integer),
            comments: T.nilable(::Integer),
            views: T.nilable(::Integer),
            shares: T.nilable(::Integer),
            language: T.nilable(::String),
            edited: T.nilable(T::Boolean),
            sponsored: T.nilable(T::Boolean),
            ai_generated: T.nilable(T::Boolean),
            posted_with: T.nilable(::String),
            stated: T.nilable(T::Hash[Symbol, ::Object]),
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
          repost_of: nil,
          quote_of: nil,
          place: nil,
          tagged: nil,
          likes: nil,
          comments: nil,
          views: nil,
          shares: nil,
          language: nil,
          edited: nil,
          sponsored: nil,
          ai_generated: nil,
          posted_with: nil,
          stated: nil,
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
          @repost_of = repost_of
          @quote_of = quote_of
          @place = place
          @tagged = tagged
          @likes = likes
          @comments = comments
          @views = views
          @shares = shares
          @language = language
          @edited = edited
          @sponsored = sponsored
          @ai_generated = ai_generated
          @posted_with = posted_with
          @stated = stated
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
          return false unless @repost_of == other.repost_of
          return false unless @quote_of == other.quote_of
          return false unless @place == other.place
          return false unless @tagged == other.tagged
          return false unless @likes == other.likes
          return false unless @comments == other.comments
          return false unless @views == other.views
          return false unless @shares == other.shares
          return false unless @language == other.language
          return false unless @edited == other.edited
          return false unless @sponsored == other.sponsored
          return false unless @ai_generated == other.ai_generated
          return false unless @posted_with == other.posted_with
          return false unless @stated == other.stated
          return false unless @screenshot_sha256 == other.screenshot_sha256
          return false unless @captured_at == other.captured_at
          true
        end
      end
    end
  end
end
