# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyPreviewTransition
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :from,
          Models::Shared::From,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("from"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::From, false)
            }
          }
        )

        field(
          :to,
          Models::Shared::From,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("to"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::From, false)
            }
          }
        )

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )

        sig { params(from: Models::Shared::From, to: Models::Shared::From, count: ::Integer).void }
        def initialize(from:, to:, count:)
          @from = from
          @to = to
          @count = count
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @count == other.count
          true
        end
      end
    end
  end
end
