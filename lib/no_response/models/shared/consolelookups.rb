# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The live environment's daily cap on assessments members make through the console (the playground), as spent on the current UTC day. Each console submission with a new Idempotency-Key spends one lookup; a replay spends nothing, and API keys and the test environment spend none. When used reaches limit, the next lookup answers 429 lookup_limit_reached until resets_at. The count is the one the cap enforces.
      class ConsoleLookups
        extend T::Sig
        include Crystalline::MetadataFields

        # Lookups spent since the last reset.
        field :used, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("used"), required: true}}
        # Lookups allowed per UTC day.
        field(
          :limit,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit"), required: true}}
        )
        # The next reset: the coming midnight UTC, when used returns to 0.
        field(
          :resets_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("resets_at"), required: true}}
        )

        sig { params(used: ::Integer, limit: ::Integer, resets_at: ::String).void }
        def initialize(used:, limit:, resets_at:)
          @used = used
          @limit = limit
          @resets_at = resets_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @used == other.used
          return false unless @limit == other.limit
          return false unless @resets_at == other.resets_at
          true
        end
      end
    end
  end
end
