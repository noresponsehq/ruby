# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

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
          :weight,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("weight"), required: true}}
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

        sig {
          params(
            code: Models::Shared::ReasonCode,
            weight: ::Integer,
            identifier: T.nilable(Models::Shared::ReasonIdentifier)
          )
            .void
        }
        def initialize(code:, weight:, identifier: nil)
          @code = code
          @weight = weight
          @identifier = identifier
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @code == other.code
          return false unless @weight == other.weight
          return false unless @identifier == other.identifier
          true
        end
      end
    end
  end
end
