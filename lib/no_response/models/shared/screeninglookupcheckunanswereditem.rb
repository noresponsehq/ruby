# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ScreeningLookupCheckUnansweredItem
        extend T::Sig
        include Crystalline::MetadataFields

        # The id of the connector that did not answer: breach for the breach search.
        field(
          :connector,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("connector"), required: true}}
        )
        # Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.
        field(
          :reason,
          Models::Shared::FailureReason,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FailureReason, false)
            }
          }
        )

        sig { params(connector: ::String, reason: Models::Shared::FailureReason).void }
        def initialize(connector:, reason:)
          @connector = connector
          @reason = reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @connector == other.connector
          return false unless @reason == other.reason
          true
        end
      end
    end
  end
end
