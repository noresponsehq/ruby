# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DeleteListEntryResponse
        extend T::Sig
        include Crystalline::MetadataFields

        field :headers, Crystalline::Hash.new(Symbol, Crystalline::Array.new(::String))

        sig { params(headers: T::Hash[Symbol, T::Array[::String]]).void }
        def initialize(headers:)
          @headers = headers
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @headers == other.headers
          true
        end
      end
    end
  end
end
