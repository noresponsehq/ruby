# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class StageTime
        extend T::Sig
        include Crystalline::MetadataFields

        # ai_typing and analysis appear only on searches recorded before the engine stopped analysing results.
        field(
          :stage,
          Models::Shared::Stage,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("stage"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Stage, false)
            }
          }
        )

        field :ms, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ms"), required: true}}

        sig { params(stage: Models::Shared::Stage, ms: ::Integer).void }
        def initialize(stage:, ms:)
          @stage = stage
          @ms = ms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @stage == other.stage
          return false unless @ms == other.ms
          true
        end
      end
    end
  end
end
