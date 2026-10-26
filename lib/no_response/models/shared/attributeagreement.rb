# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
      class AttributeAgreement
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :agreement,
          Models::Shared::Agreement,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("agreement"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Agreement, false)
            }
          }
        )

        field(
          :values,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("values"), required: true}}
        )

        field(
          :support,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("support"), required: true}}
        )

        sig { params(agreement: Models::Shared::Agreement, values: ::Integer, support: ::Integer).void }
        def initialize(agreement:, values:, support:)
          @agreement = agreement
          @values = values
          @support = support
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @agreement == other.agreement
          return false unless @values == other.values
          return false unless @support == other.support
          true
        end
      end
    end
  end
end
