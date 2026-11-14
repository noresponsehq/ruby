# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PostsStopped - Why fewer posts were read than the screening's depth asks for while the account holds more. platform_limit: the platform shows the screening no more of them. page_limit: the pages a screening reads ran out first. rate_limited or unavailable: a later page was held back or failed; the posts before it are kept and the person is partial. Absent when the account was read to its end or to the depth.
      class PostsStopped
        include ::Crystalline::Enum
        enums do
          PLATFORM_LIMIT = new("platform_limit")
          PAGE_LIMIT = new("page_limit")
          RATE_LIMITED = new("rate_limited")
          UNAVAILABLE = new("unavailable")
        end

        open!
      end
    end
  end
end
