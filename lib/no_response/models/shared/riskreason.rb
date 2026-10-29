# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One reason that fired. direction is whether it raises or lowers the score, or is neutral (informational, it moves nothing). impact is a coarse band of how much it moves the score: none for a neutral reason, otherwise low, medium or high.
      class RiskReason
        extend T::Sig
        include Crystalline::MetadataFields

        # A stable reason code. New codes may appear; ignore any you do not know.
        field(
          :code,
          Models::Shared::ReasonCode,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("code"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReasonCode, false)
            }
          }
        )

        field(
          :direction,
          Models::Shared::Direction,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("direction"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Direction, false)
            }
          }
        )
        # The selected reason's served impact band. Requires reason.
        field(
          :impact,
          Models::Shared::Impact,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("impact"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Impact, false)
            }
          }
        )
        # The submitted identifier or client context field a reason concerns; absent when it concerns the whole assessment. Client context is a claimed hint, not a device fingerprint.
        field(
          :identifier,
          Crystalline::Nilable.new(Models::Shared::ReasonIdentifier),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReasonIdentifier, true)
            }
          }
        )
        # The list entry a list_match reason applied. No other reason carries it.
        field(
          :list_entry_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("list_entry_id")}}
        )

        sig {
          params(
            code: Models::Shared::ReasonCode,
            direction: Models::Shared::Direction,
            impact: Models::Shared::Impact,
            identifier: T.nilable(Models::Shared::ReasonIdentifier),
            list_entry_id: T.nilable(::String)
          )
            .void
        }
        def initialize(code:, direction:, impact:, identifier: nil, list_entry_id: nil)
          @code = code
          @direction = direction
          @impact = impact
          @identifier = identifier
          @list_entry_id = list_entry_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @code == other.code
          return false unless @direction == other.direction
          return false unless @impact == other.impact
          return false unless @identifier == other.identifier
          return false unless @list_entry_id == other.list_entry_id
          true
        end
      end
    end
  end
end
