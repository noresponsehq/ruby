# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An account the screening matched to the person, how it was matched, and how much of it was read.
      class ScreeningProfile
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # A platform a screening can cover. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
        field(
          :platform,
          Models::Shared::HandlePlatform,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HandlePlatform, false)
            }
          }
        )

        field(
          :handle,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handle"), required: true}}
        )

        field :url, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("url"), required: true}}
        # public profiles were read; a private or locked one exists but could not be read.
        field(
          :access,
          Models::Shared::Access,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("access"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Access, false)
            }
          }
        )
        # How a profile was matched to the person: the state its evidence earns, and the evidence.
        field(
          :match,
          Models::Shared::ScreeningMatch,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("match"), required: true}}
        )
        # The resolver, collector or analyser that produced a record, by its catalogue name.
        field(
          :collector,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("collector"), required: true}}
        )

        field(
          :items_read,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items_read"), required: true}}
        )

        field(
          :collected_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("collected_at"), required: true}}
        )

        field(
          :display_name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("display_name")}}
        )

        field(
          :bio,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("bio")}}
        )

        field(
          :avatar_url,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("avatar_url")}}
        )

        field(
          :followers,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("followers")}}
        )

        field(
          :account_created_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_created_at")}}
        )
        # Why fewer posts were read than the screening's depth asks for while the account holds more. platform_limit: the platform shows the screening no more of them. page_limit: the pages a screening reads ran out first. rate_limited or unavailable: a later page was held back or failed; the posts before it are kept and the person is partial. Absent when the account was read to its end or to the depth.
        field(
          :posts_stopped,
          Crystalline::Nilable.new(Models::Shared::PostsStopped),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("posts_stopped"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PostsStopped, true)
            }
          }
        )
        # The oldest item read.
        field(
          :period_from,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("period_from")}}
        )
        # The newest item read.
        field(
          :period_to,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("period_to")}}
        )
        # One answer from one source: where it came from, what found it and every field it holds.
        field(
          :record,
          Crystalline::Nilable.new(Models::Shared::Record),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("record")}}
        )

        sig {
          params(
            id: ::String,
            platform: Models::Shared::HandlePlatform,
            handle: ::String,
            url: ::String,
            access: Models::Shared::Access,
            match: Models::Shared::ScreeningMatch,
            collector: ::String,
            items_read: ::Integer,
            collected_at: ::String,
            display_name: T.nilable(::String),
            bio: T.nilable(::String),
            avatar_url: T.nilable(::String),
            followers: T.nilable(::Integer),
            account_created_at: T.nilable(::String),
            posts_stopped: T.nilable(Models::Shared::PostsStopped),
            period_from: T.nilable(::String),
            period_to: T.nilable(::String),
            record: T.nilable(Models::Shared::Record)
          )
            .void
        }
        def initialize(
          id:,
          platform:,
          handle:,
          url:,
          access:,
          match:,
          collector:,
          items_read:,
          collected_at:,
          display_name: nil,
          bio: nil,
          avatar_url: nil,
          followers: nil,
          account_created_at: nil,
          posts_stopped: nil,
          period_from: nil,
          period_to: nil,
          record: nil
        )
          @id = id
          @platform = platform
          @handle = handle
          @url = url
          @access = access
          @match = match
          @collector = collector
          @items_read = items_read
          @collected_at = collected_at
          @display_name = display_name
          @bio = bio
          @avatar_url = avatar_url
          @followers = followers
          @account_created_at = account_created_at
          @posts_stopped = posts_stopped
          @period_from = period_from
          @period_to = period_to
          @record = record
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @platform == other.platform
          return false unless @handle == other.handle
          return false unless @url == other.url
          return false unless @access == other.access
          return false unless @match == other.match
          return false unless @collector == other.collector
          return false unless @items_read == other.items_read
          return false unless @collected_at == other.collected_at
          return false unless @display_name == other.display_name
          return false unless @bio == other.bio
          return false unless @avatar_url == other.avatar_url
          return false unless @followers == other.followers
          return false unless @account_created_at == other.account_created_at
          return false unless @posts_stopped == other.posts_stopped
          return false unless @period_from == other.period_from
          return false unless @period_to == other.period_to
          return false unless @record == other.record
          true
        end
      end
    end
  end
end
