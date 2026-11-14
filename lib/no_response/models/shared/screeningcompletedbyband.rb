# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Screened people by the band of their most severe finding.
      class ScreeningCompletedByBand
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :critical,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("critical"), required: true}}
        )

        field :high, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("high"), required: true}}

        field(
          :moderate,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("moderate"), required: true}}
        )

        field :low, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("low"), required: true}}

        field :info, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("info"), required: true}}

        sig { params(critical: ::Integer, high: ::Integer, moderate: ::Integer, low: ::Integer, info: ::Integer).void }
        def initialize(critical:, high:, moderate:, low:, info:)
          @critical = critical
          @high = high
          @moderate = moderate
          @low = low
          @info = info
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @critical == other.critical
          return false unless @high == other.high
          return false unless @moderate == other.moderate
          return false unless @low == other.low
          return false unless @info == other.info
          true
        end
      end
    end
  end
end
