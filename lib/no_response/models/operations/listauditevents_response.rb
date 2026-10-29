# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListAuditEventsResponse
        extend T::Sig
        include Crystalline::MetadataFields
        sig { returns(T.proc.returns(T.nilable(ListAuditEventsResponse))) }
        attr_accessor :next_page

        field :headers, Crystalline::Hash.new(Symbol, Crystalline::Array.new(::String))

        field :result, Models::Shared::AuditEventList, {}

        sig { params(headers: T::Hash[Symbol, T::Array[::String]], result: Models::Shared::AuditEventList).void }
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

        def each
          page = self
          loop do
            yield page
            next_page = page.next_page.call if page.next_page
            break if next_page.nil?
            page = T.must(next_page)
          end
        end
      end
    end
  end
end
