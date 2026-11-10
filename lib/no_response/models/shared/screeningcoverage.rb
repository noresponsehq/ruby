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

        sig {
          params(
            accounts_found: ::Integer,
            accounts_accessible: ::Integer,
            items_read: ::Integer,
            platforms: T::Array[Models::Shared::ScreeningPlatformCoverage],
            period_from: T.nilable(::String),
            period_to: T.nilable(::String)
          )
            .void
        }
        def initialize(accounts_found:, accounts_accessible:, items_read:, platforms:, period_from: nil, period_to: nil)
          @accounts_found = accounts_found
          @accounts_accessible = accounts_accessible
          @items_read = items_read
          @platforms = platforms
          @period_from = period_from
          @period_to = period_to
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
          true
        end
      end
    end
  end
end
