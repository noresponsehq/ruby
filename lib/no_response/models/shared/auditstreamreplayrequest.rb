# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AuditStreamReplayRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, workspace-scoped webhook event id. A redelivery of the same event carries the same event_id, so consumers deduplicate on it.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )

        sig { params(event_id: ::String).void }
        def initialize(event_id:)
          @event_id = event_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event_id == other.event_id
          true
        end
      end
    end
  end
end
