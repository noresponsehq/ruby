# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class MediaType
        include ::Crystalline::Enum
        enums do
          IMAGE = new("image")
          VIDEO = new("video")
        end

        open!
      end
    end
  end
end
