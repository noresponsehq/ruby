# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A bounded AND/OR expression over submitted identifiers. Required scope assessment means the entire expression must match one retained assessment. Scope account permits each term to match a different retained assessment of the same account and is accepted only by account search. Exactly one of term, and or or is allowed at every node. Groups contain 2 to 8 operands, with at most 3 nested group levels and 8 raw term occurrences over the entire expression. A root term is allowed. Duplicate terms with the same kind, match rule, namespace and normalized comparison are idempotent, but count toward the raw limit. Match rules default to exact and preserve the existing identifier contract. Only retained submitted identifiers can satisfy a term. Unknown fields, unsupported scopes and malformed or oversized expressions return 400 invalid_request.
      class IdentifierExpression
        extend T::Sig
        include Crystalline::MetadataFields

        # assessment requires one submission to satisfy the complete expression. account permits witnesses across retained submissions of one account and is supported only by POST /v1/accounts/search. No default: select scope explicitly.
        field(
          :scope,
          Models::Shared::ScopeEnum,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("scope"),
              required: true,
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ScopeEnum, false)
            }
          }
        )

        field(
          :expression,
          Models::Shared::IdentifierExpressionNode,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expression"), required: true}}
        )

        sig { params(scope: Models::Shared::ScopeEnum, expression: Models::Shared::IdentifierExpressionNode).void }
        def initialize(scope:, expression:)
          @scope = scope
          @expression = expression
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @scope == other.scope
          return false unless @expression == other.expression
          true
        end
      end
    end
  end
end
