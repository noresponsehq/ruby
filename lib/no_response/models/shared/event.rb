# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An event and its screening context.
      class Event
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )
        # The event's name.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # When the event starts.
        field(
          :starts_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("starts_at"), required: true}}
        )
        # When the event ends, at or after its start; the start when omitted.
        field(
          :ends_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ends_at"), required: true}}
        )
        # The people the event protects.
        field(
          :principals,
          Crystalline::Array.new(Models::Shared::Principal),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("principals"), required: true}}
        )
        # Sensitive topics.
        field(
          :topics,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("topics"), required: true}}
        )
        # How many attendees the event holds.
        field(
          :attendees,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees"), required: true}}
        )
        # Goes up by one with every change.
        field(
          :version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("version"), required: true}}
        )
        # When raw collected items and unmatched candidate profiles are purged: 30 days after the event ends.
        field(
          :purge_after,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("purge_after"), required: true}}
        )
        # The member or key label that created the event.
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

        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # Where the event is held.
        field(
          :venue,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("venue")}}
        )
        # The organisation hosting the event.
        field(
          :host,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("host")}}
        )

        sig {
          params(
            id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            name: ::String,
            starts_at: ::String,
            ends_at: ::String,
            principals: T::Array[Models::Shared::Principal],
            topics: T::Array[::String],
            attendees: ::Integer,
            version: ::Integer,
            purge_after: ::String,
            created_by: ::String,
            created_at: ::String,
            updated_at: ::String,
            venue: T.nilable(::String),
            host: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          environment:,
          name:,
          starts_at:,
          ends_at:,
          principals:,
          topics:,
          attendees:,
          version:,
          purge_after:,
          created_by:,
          created_at:,
          updated_at:,
          venue: nil,
          host: nil
        )
          @id = id
          @environment = environment
          @name = name
          @starts_at = starts_at
          @ends_at = ends_at
          @principals = principals
          @topics = topics
          @attendees = attendees
          @version = version
          @purge_after = purge_after
          @created_by = created_by
          @created_at = created_at
          @updated_at = updated_at
          @venue = venue
          @host = host
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @environment == other.environment
          return false unless @name == other.name
          return false unless @starts_at == other.starts_at
          return false unless @ends_at == other.ends_at
          return false unless @principals == other.principals
          return false unless @topics == other.topics
          return false unless @attendees == other.attendees
          return false unless @version == other.version
          return false unless @purge_after == other.purge_after
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @venue == other.venue
          return false unless @host == other.host
          true
        end
      end
    end
  end
end
