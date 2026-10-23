# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Optional policy inputs: region.
      class AssessmentRequestPolicyContext
        extend T::Sig
        include Crystalline::MetadataFields

        # ISO 3166-1 alpha-2 region of the user, as the provider determines it.
        field(
          :region,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("region")}}
        )

        sig { params(region: T.nilable(::String)).void }
        def initialize(region: nil)
          @region = region
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @region == other.region
          true
        end
      end
    end
  end
end
