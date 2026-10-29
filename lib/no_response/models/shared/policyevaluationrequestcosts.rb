# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluationRequestCosts
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :legitimate,
          Models::Shared::Cost,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("legitimate"), required: true}}
        )

        field(
          :abuse,
          Models::Shared::Cost,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("abuse"), required: true}}
        )

        sig { params(legitimate: Models::Shared::Cost, abuse: Models::Shared::Cost).void }
        def initialize(legitimate:, abuse:)
          @legitimate = legitimate
          @abuse = abuse
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @legitimate == other.legitimate
          return false unless @abuse == other.abuse
          true
        end
      end
    end
  end
end
