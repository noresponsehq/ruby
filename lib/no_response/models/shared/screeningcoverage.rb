# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The denominator of a screening: accounts found, how many could be read, items read and the period they span, so a clean result is distinct from a person nobody could see.
      class ScreeningCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :accounts_found,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts_found"), required: true}}
        )

        field(
          :accounts_accessible,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts_accessible"), required: true}}
        )

        field(
          :items_read,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items_read"), required: true}}
        )

        field(
          :platforms,
          Crystalline::Array.new(Models::Shared::ScreeningPlatformCoverage),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms"), required: true}}
        )
        # The oldest item read on any platform.
        field(
          :period_from,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("period_from")}}
        )
        # The newest item read on any platform.
        field(
          :period_to,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("period_to")}}
        )
        # Requested platforms where the person gave the screening nothing to look up, such as no handle for a platform that reads supplied handles only. Nothing looked and nothing failed: such a platform is not in platforms, is not none_found and does not make the person partial.
        field(
          :not_searched,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("not_searched")}}
        )
        # How many sources this search asked and how many answered, across the lookup stage (sources asked whether an account exists for an identifier) and the platform stage (profiles read on each platform). A source that answered may have found nothing; one that did not answer failed or ran out of time.
        field(
          :sources,
          Crystalline::Nilable.new(Models::Shared::ScreeningCoverageSources),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sources")}}
        )
        # How long this search's latest attempt took, stage by stage. started_at minus the investigation's creation is the time spent queued or retrying.
        field(
          :timing,
          Crystalline::Nilable.new(Models::Shared::ScreeningCoverageTiming),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("timing")}}
        )

        sig {
          params(
            accounts_found: ::Integer,
            accounts_accessible: ::Integer,
            items_read: ::Integer,
            platforms: T::Array[Models::Shared::ScreeningPlatformCoverage],
            period_from: T.nilable(::String),
            period_to: T.nilable(::String),
            not_searched: T.nilable(T::Array[::String]),
            sources: T.nilable(Models::Shared::ScreeningCoverageSources),
            timing: T.nilable(Models::Shared::ScreeningCoverageTiming)
          )
            .void
        }
        def initialize(
          accounts_found:,
          accounts_accessible:,
          items_read:,
          platforms:,
          period_from: nil,
          period_to: nil,
          not_searched: nil,
          sources: nil,
          timing: nil
        )
          @accounts_found = accounts_found
          @accounts_accessible = accounts_accessible
          @items_read = items_read
          @platforms = platforms
          @period_from = period_from
          @period_to = period_to
          @not_searched = not_searched
          @sources = sources
          @timing = timing
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @accounts_found == other.accounts_found
          return false unless @accounts_accessible == other.accounts_accessible
          return false unless @items_read == other.items_read
          return false unless @platforms == other.platforms
          return false unless @period_from == other.period_from
          return false unless @period_to == other.period_to
          return false unless @not_searched == other.not_searched
          return false unless @sources == other.sources
          return false unless @timing == other.timing
          true
        end
      end
    end
  end
end
