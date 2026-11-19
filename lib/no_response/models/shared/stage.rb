# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Stage
        include ::Crystalline::Enum
        enums do
          LOOKUP = new("lookup")
          LOOKUP_TYPING = new("lookup_typing")
          PLATFORMS = new("platforms")
          WRITTEN = new("written")
          LATE_PLATFORMS = new("late_platforms")
          LATE_LOOKUP = new("late_lookup")
          AI_TYPING = new("ai_typing")
          ANALYSIS = new("analysis")
          RATING = new("rating")
        end

        open!
      end
    end
  end
end
