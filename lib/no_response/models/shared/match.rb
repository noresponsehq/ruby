# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Match - exact compares the original submitted value; canonical uses identifier-specific normalisation; mailbox explicitly selects the email alias rules used by lists.
      class Match
        include ::Crystalline::Enum
        enums do
          EXACT = new("exact")
          CANONICAL = new("canonical")
          MAILBOX = new("mailbox")
        end

        open!
      end
    end
  end
end
