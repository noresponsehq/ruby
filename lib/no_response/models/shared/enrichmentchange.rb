# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A change to enrichment. A field left out keeps the value in force; max_spend or deadline null removes the bound.
      class EnrichmentChange
        extend T::Sig
        include Crystalline::MetadataFields

        # off: enrichment starts no search. suggest: enrichment starts no search by itself. automatic: after a workspace person's own investigation, and each time a search on that person finishes, enrichment starts searches by itself.
        field(
          :mode,
          Crystalline::Nilable.new(Models::Shared::EnrichmentMode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("mode"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::EnrichmentMode, true)
            }
          }
        )
        # Enrichment searches values only from records more likely than this to be the person's, 0 to 0.99.
        field(
          :min_likelihood,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("min_likelihood")}}
        )
        # The kinds of value enrichment searches: distinctive usernames, and email addresses and phone numbers, which belong to one person each.
        field(
          :kinds,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::EnrichmentChangeKind)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kinds")}}
        )
        # The most enrichment may spend on a person from one investigation, in minor units of USD (cents): each search it started after that investigation started counts its estimate or what it spent, whichever is more. At the bound enrichment starts nothing more for that investigation. null: only the environment's screening_daily_cap bounds it.
        field(
          :max_spend,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("max_spend")}}
        )
        # How long enrichment may start searches after an investigation starts, 60 to 2592000 seconds. null: no deadline.
        field(
          :deadline,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deadline")}}
        )

        sig {
          params(
            mode: T.nilable(Models::Shared::EnrichmentMode),
            min_likelihood: T.nilable(::Float),
            kinds: T.nilable(T::Array[Models::Shared::EnrichmentChangeKind]),
            max_spend: T.nilable(::Integer),
            deadline: T.nilable(::Integer)
          )
            .void
        }
        def initialize(mode: nil, min_likelihood: nil, kinds: nil, max_spend: nil, deadline: nil)
          @mode = mode
          @min_likelihood = min_likelihood
          @kinds = kinds
          @max_spend = max_spend
          @deadline = deadline
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @mode == other.mode
          return false unless @min_likelihood == other.min_likelihood
          return false unless @kinds == other.kinds
          return false unless @max_spend == other.max_spend
          return false unless @deadline == other.deadline
          true
        end
      end
    end
  end
end
