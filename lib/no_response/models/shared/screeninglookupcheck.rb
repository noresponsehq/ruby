# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What came of one lane of the lookups for one identifier.
      class ScreeningLookupCheck
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :identifier,
          Models::Shared::IdentifierSearchKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IdentifierSearchKind, false)
            }
          }
        )
        # An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.
        field(
          :lane,
          Models::Shared::Lane,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("lane"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Lane, false)
            }
          }
        )
        # found: a source found the identifier. not_found: every source answered and none found it. partial: the sources that answered found nothing and the others did not answer. not_covered: no source answered. A lookup that failed reads partial or not_covered, not not_found.
        field(
          :status,
          Models::Shared::ScreeningLookupCheckStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningLookupCheckStatus, false)
            }
          }
        )
        # Sources asked: none when no source could be, as when the source is stopped or your workspace refuses it.
        field(
          :sources,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sources"), required: true}}
        )
        # Sources that gave a definite answer.
        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )
        # Sources that found the identifier.
        field(
          :found,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("found"), required: true}}
        )
        # Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::FailureReason),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FailureReason, true)
            }
          }
        )

        sig {
          params(
            identifier: Models::Shared::IdentifierSearchKind,
            lane: Models::Shared::Lane,
            status: Models::Shared::ScreeningLookupCheckStatus,
            sources: ::Integer,
            answered: ::Integer,
            found: ::Integer,
            reason: T.nilable(Models::Shared::FailureReason)
          )
            .void
        }
        def initialize(identifier:, lane:, status:, sources:, answered:, found:, reason: nil)
          @identifier = identifier
          @lane = lane
          @status = status
          @sources = sources
          @answered = answered
          @found = found
          @reason = reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @identifier == other.identifier
          return false unless @lane == other.lane
          return false unless @status == other.status
          return false unless @sources == other.sources
          return false unless @answered == other.answered
          return false unless @found == other.found
          return false unless @reason == other.reason
          true
        end
      end
    end
  end
end
