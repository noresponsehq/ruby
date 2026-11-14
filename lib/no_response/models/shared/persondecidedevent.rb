# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The person.decided event.
      class PersonDecidedEvent
        extend T::Sig
        include Crystalline::MetadataFields

        # The event id, equal to the NR-Webhook-Id header and across redeliveries and every endpoint the event fans out to.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # When the event was created. Equal across redeliveries; the signing timestamp header is per delivery.
        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # A reviewer recorded a decision on a person. The decision's note stays in the API. Sent once per recorded review; a person's latest review is its decision, so order by decided_at.
        field(
          :data,
          Models::Shared::PersonDecided,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("data"), required: true}}
        )
        # Always person.decided.
        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}
        # Present, and true, only on an event sent by POST /v1/webhooks/{endpoint_id}/test: its data is a fixed example assessment, not one of the workspace's, so a receiver acknowledges it and applies nothing. Real events have no test member.
        field(
          :test,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("test")}}
        )

        sig {
          params(
            id: ::String,
            created_at: ::String,
            data: Models::Shared::PersonDecided,
            type: ::String,
            test: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(id:, created_at:, data:, type: "person.decided", test: nil)
          @id = id
          @created_at = created_at
          @data = data
          unless type == "person.decided"
            raise ArgumentError, "Invalid value for type"
          end

          @type = "person.decided"
          @test = test
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @created_at == other.created_at
          return false unless @data == other.data
          return false unless @type == other.type
          return false unless @test == other.test
          true
        end
      end
    end
  end
end
