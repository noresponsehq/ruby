# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Topic
        include ::Crystalline::Enum
        enums do
          IDENTITY = new("identity")
          LOCATION = new("location")
          MOVEMENT = new("movement")
          TIMELINE = new("timeline")
          INTERESTS = new("interests")
          RELATIONSHIPS = new("relationships")
          WORK = new("work")
          EDUCATION = new("education")
          ACCOUNTS = new("accounts")
          CREDENTIALS = new("credentials")
          DEVICES = new("devices")
          ABSENCE = new("absence")
        end

        open!
      end
    end
  end
end
