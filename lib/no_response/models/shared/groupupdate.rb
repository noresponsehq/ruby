# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Updates a group. Dates describe an optional event and do not control person retention.
      class GroupUpdate
        extend T::Sig
        include Crystalline::MetadataFields

        # The group's name.
        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
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
        # Optional event start; null for an ongoing group. Omit to keep the current value; send null to clear it.
        field(
          :starts_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("starts_at")}}
        )
        # Optional event end; requires starts_at and must be at or after it. Null when no end is set. Omit to keep the current value; send null to clear it.
        field(
          :ends_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ends_at")}}
        )

        sig {
          params(
            name: T.nilable(::String),
            venue: T.nilable(::String),
            host: T.nilable(::String),
            principals: T.nilable(T::Array[Models::Shared::Principal]),
            topics: T.nilable(T::Array[::String]),
            expected_version: T.nilable(::Integer),
            starts_at: T.nilable(::String),
            ends_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          name: nil,
          venue: nil,
          host: nil,
          principals: nil,
          topics: nil,
          expected_version: nil,
          starts_at: (
            starts_at_omitted = true
            nil
          ),
          ends_at: (
            ends_at_omitted = true
            nil
          )
        )
          @name = name
          @venue = venue
          @host = host
          @principals = principals
          @topics = topics
          @expected_version = expected_version
          @starts_at = starts_at
          @starts_at_omitted = starts_at_omitted
          @ends_at = ends_at
          @ends_at_omitted = ends_at_omitted
        end


        def to_dict
          result = super
          result["starts_at"] = nil if @starts_at.nil? && !@starts_at_omitted
          result["ends_at"] = nil if @ends_at.nil? && !@ends_at_omitted
          result
        end

        def self.from_dict(value)
          result = super
          result.starts_at = nil if value.key?("starts_at") && value["starts_at"].nil?
          result.ends_at = nil if value.key?("ends_at") && value["ends_at"].nil?
          result
        end

        def starts_at=(value)
          @starts_at_omitted = false
          @starts_at = value
        end

        def ends_at=(value)
          @ends_at_omitted = false
          @ends_at = value
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @venue == other.venue
          return false unless @host == other.host
          return false unless @principals == other.principals
          return false unless @topics == other.topics
          return false unless @expected_version == other.expected_version
          return false unless @starts_at == other.starts_at
          return false unless @ends_at == other.ends_at
          true
        end
      end
    end
  end
end
