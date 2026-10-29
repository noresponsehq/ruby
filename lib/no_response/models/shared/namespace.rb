# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Namespace - Required for username: the username submitted by this customer in this workspace/environment. It does not name or join a source platform. Omit for email and phone.
      class Namespace
        include ::Crystalline::Enum
        enums do
          CUSTOMER = new("customer")
        end

        open!
      end
    end
  end
end
