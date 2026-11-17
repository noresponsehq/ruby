# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnrichmentMode - off: enrichment starts no search and suggests none. suggest: enrichment starts no search by itself, and the person report lists the searches it would start in suggested_searches. automatic: after a workspace person's own investigation or a group's screening, and each time a search on that person finishes, enrichment starts searches by itself. A group takes suggest while the workspace has not set a mode.
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
