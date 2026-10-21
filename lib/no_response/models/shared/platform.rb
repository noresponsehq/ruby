# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Platform - Client platform. Closed vocabulary keeps integrations stable.
      class Platform < T::Enum
        enums do
          WEB = new("web")
          IOS = new("ios")
          ANDROID = new("android")
          OTHER = new("other")
        end
      end
    end
  end
end
