# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AssessmentRequestPolicyContext
        extend T::Sig
        include Crystalline::MetadataFields

        # The provider flow the assessment gates. Use the top-level flow instead; this member is ignored when the top-level flow is present. Absent means signup.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::Flow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::Flow, true)
            }
          }
        )
        # ISO 3166-1 alpha-2 region of the signup, as the provider determines it.
        field(
          :region,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("region")}}
        )

        sig { params(flow: T.nilable(Models::Shared::Flow), region: T.nilable(::String)).void }
        def initialize(flow: nil, region: nil)
          @flow = flow
          @region = region
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @flow == other.flow
          return false unless @region == other.region
          true
        end
      end
    end
  end
end
