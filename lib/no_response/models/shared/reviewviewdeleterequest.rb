# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewViewDeleteRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :expected_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version"), required: true}}
        )

        sig { params(expected_version: ::Integer).void }
        def initialize(expected_version:)
          @expected_version = expected_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_version == other.expected_version
          true
        end
      end
    end
  end
end
