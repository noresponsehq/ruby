# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Facts about the number only: line type, carrier and country. The upstream provider, its scores and its verdicts stay internal.
      class PhoneEnrichment
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :fields_,
          Models::Shared::PhoneEnrichmentFields,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("fields"), required: true}}
        )

        sig { params(fields_: Models::Shared::PhoneEnrichmentFields).void }
        def initialize(fields_:)
          @fields_ = fields_
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @fields_ == other.fields_
          true
        end
      end
    end
  end
end
