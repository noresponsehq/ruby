# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Origin - api (the default) searches the assessments your integration sent. lookup searches the assessments your team ran by hand on the console's Lookup page. The API sets an assessment's origin from the credential that sent it. A lookup is not in any other list, count, webhook event or account.
      class Origin < T::Enum
        enums do
          API = new("api")
          LOOKUP = new("lookup")
        end
      end
    end
  end
end
