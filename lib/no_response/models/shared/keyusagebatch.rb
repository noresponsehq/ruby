# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 202 answer of POST /v1/key_usage/batches. A replay with the same Idempotency-Key and body answers the same record and counts nothing again.
      class KeyUsageBatch
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned id of the batch: 'kub_' and a 26-character Crockford base32 ULID.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # When NoResponse first recorded the batch.
        field(
          :received_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("received_at"), required: true}}
        )
        # Events counted.
        field(
          :accepted,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accepted"), required: true}}
        )
        # Events that added nothing: a private, reserved or unreadable ip, or an occurred_at more than 24 hours old or more than 5 minutes ahead.
        field(
          :ignored,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ignored"), required: true}}
        )

        sig { params(id: ::String, received_at: ::String, accepted: ::Integer, ignored: ::Integer).void }
        def initialize(id:, received_at:, accepted:, ignored:)
          @id = id
          @received_at = received_at
          @accepted = accepted
          @ignored = ignored
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @received_at == other.received_at
          return false unless @accepted == other.accepted
          return false unless @ignored == other.ignored
          true
        end
      end
    end
  end
end
