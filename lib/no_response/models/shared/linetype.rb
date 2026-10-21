# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class LineType
        include ::Crystalline::Enum
        enums do
          MOBILE = new("mobile")
          VOIP = new("voip")
          LANDLINE = new("landline")
          TOLL_FREE = new("toll_free")
          OTHER = new("other")
        end

        open!
      end
    end
  end
end
