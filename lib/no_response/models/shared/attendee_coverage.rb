# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What the latest screening read, per platform.
      class AttendeeCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        def initialize
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          true
        end
      end
    end
  end
end
