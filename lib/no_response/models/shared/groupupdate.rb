# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Changes the fields it names; at least one besides expected_version.
      class GroupUpdate
        extend T::Sig
        include Crystalline::MetadataFields

        # The group's name.
        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # When the group starts.
        field(
          :starts_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("starts_at")}}
        )
        # When the group ends, at or after its start; the start when omitted.
        field(
          :ends_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ends_at")}}
        )
        # Where the group is held.
        field(
          :venue,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("venue")}}
        )
        # The organisation hosting the group.
        field(
          :host,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("host")}}
        )
        # The people the group protects, at most 20.
        field(
          :principals,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Principal)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("principals")}}
        )
        # Sensitive topics the screening reads posts against, at most 50.
        field(
          :topics,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("topics")}}
        )
        # When present, the change applies only if the group is still at this version (409 group_conflict otherwise).
        field(
          :expected_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version")}}
        )

        sig {
          params(
            name: T.nilable(::String),
            starts_at: T.nilable(::String),
            ends_at: T.nilable(::String),
            venue: T.nilable(::String),
            host: T.nilable(::String),
            principals: T.nilable(T::Array[Models::Shared::Principal]),
            topics: T.nilable(T::Array[::String]),
            expected_version: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          name: nil,
          starts_at: nil,
          ends_at: nil,
          venue: nil,
          host: nil,
          principals: nil,
          topics: nil,
          expected_version: nil
        )
          @name = name
          @starts_at = starts_at
          @ends_at = ends_at
          @venue = venue
          @host = host
          @principals = principals
          @topics = topics
          @expected_version = expected_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @starts_at == other.starts_at
          return false unless @ends_at == other.ends_at
          return false unless @venue == other.venue
          return false unless @host == other.host
          return false unless @principals == other.principals
          return false unless @topics == other.topics
          return false unless @expected_version == other.expected_version
          true
        end
      end
    end
  end
end
