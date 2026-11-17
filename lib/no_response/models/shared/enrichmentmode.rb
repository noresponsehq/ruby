# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnrichmentMode - off: enrichment starts no search. suggest: enrichment starts no search by itself. automatic: after a workspace person's own investigation, and each time a search on that person finishes, enrichment starts searches by itself.
      class EnrichmentMode
        include ::Crystalline::Enum
        enums do
          OFF = new("off")
          SUGGEST = new("suggest")
          AUTOMATIC = new("automatic")
        end

        open!
      end
    end
  end
end
