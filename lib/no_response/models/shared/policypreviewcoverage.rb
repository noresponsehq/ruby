# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyPreviewCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :scanned,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scanned"), required: true}}
        )

        field(
          :eligible,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("eligible"), required: true}}
        )

        field(
          :missing_score,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("missing_score"), required: true}}
        )

        field(
          :unsupported,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unsupported"), required: true}}
        )

        field(
          :truncated,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("truncated"), required: true}}
        )

        field(
          :complete_retained_window,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("complete_retained_window"), required: true}}
        )
        # Deleted, expired and uncaptured records cannot be reconstructed. Counts describe retained evidence and provide no causal estimate of fraud prevented.
        field(
          :historical_population_known,
          Crystalline::Boolean.new,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("historical_population_known"),
              required: true
            }
          }
        )

        sig {
          params(
            scanned: ::Integer,
            eligible: ::Integer,
            missing_score: ::Integer,
            unsupported: ::Integer,
            truncated: T::Boolean,
            complete_retained_window: T::Boolean,
            historical_population_known: T::Boolean
          )
            .void
        }
        def initialize(
          scanned:,
          eligible:,
          missing_score:,
          unsupported:,
          truncated:,
          complete_retained_window:,
          historical_population_known: false
        )
          @scanned = scanned
          @eligible = eligible
          @missing_score = missing_score
          @unsupported = unsupported
          @truncated = truncated
          @complete_retained_window = complete_retained_window
          unless historical_population_known == false
            raise ArgumentError, "Invalid value for historical_population_known"
          end

          @historical_population_known = false
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @scanned == other.scanned
          return false unless @eligible == other.eligible
          return false unless @missing_score == other.missing_score
          return false unless @unsupported == other.unsupported
          return false unless @truncated == other.truncated
          return false unless @complete_retained_window == other.complete_retained_window
          return false unless @historical_population_known == other.historical_population_known
          true
        end
      end
    end
  end
end
