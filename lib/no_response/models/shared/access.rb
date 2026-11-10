# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Access - public profiles were read; a private or locked one exists but could not be read.
      class Access
        include ::Crystalline::Enum
        enums do
          PUBLIC = new("public")
          PRIVATE = new("private")
          LOCKED = new("locked")
        end

        open!
      end
    end
  end
end
