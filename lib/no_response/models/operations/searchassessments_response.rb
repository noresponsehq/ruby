# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class SearchAssessmentsResponse
        extend T::Sig
        include Crystalline::MetadataFields

        field :headers, Crystalline::Hash.new(Symbol, Crystalline::Array.new(::String))

        field :result, Models::Shared::AssessmentSearchPage, {}

        sig { params(headers: T::Hash[Symbol, T::Array[::String]], result: Models::Shared::AssessmentSearchPage).void }
        def initialize(headers:, result:)
          @headers = headers
          @result = result
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @headers == other.headers
          return false unless @result == other.result
          true
        end
      end
    end
  end
end
