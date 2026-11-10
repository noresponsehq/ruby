# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Something the analyser flagged. band is capped by the strongest match among the profiles of its evidence: possible at most moderate, probable at most high. capped_from is the band the analyser gave when the cap lowered it.
      class ScreeningFinding
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # What a finding is about: a direct threat to the principal or the event, intent to harm without a named target, fixation on the principal, a grievance against the host, research into the venue, route or security, weapons tied to any of these, disruption or protest planning toward this event, violent extremist content or identification, prior harassment or stalking of staff or principals, or posting the principal's addresses or movements.
        field(
          :category,
          Models::Shared::FindingCategory,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("category"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FindingCategory, false)
            }
          }
        )
        # How severe a finding is, most severe first.
        field(
          :band,
          Models::Shared::FindingBand,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("band"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FindingBand, false)
            }
          }
        )

        field(
          :confidence,
          ::Float,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("confidence"), required: true}}
        )

        field(
          :rationale,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("rationale"), required: true}}
        )
        # The posts and media that support the finding.
        field(
          :evidence,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence"), required: true}}
        )
        # The resolver, collector or analyser that produced a record, by its catalogue name.
        field(
          :analyser,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("analyser"), required: true}}
        )

        field(
          :model,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("model"), required: true}}
        )
        # What the analysis cost, in US cents.
        field(
          :spend_minor,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spend_minor"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # How severe a finding is, most severe first.
        field(
          :capped_from,
          Crystalline::Nilable.new(Models::Shared::FindingBand),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("capped_from"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FindingBand, true)
            }
          }
        )
        # The exact words of the first evidence item that the finding rests on, as the analyser quoted them.
        field(
          :quote,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("quote")}}
        )
        # What the analyser saw in each image among evidence that the finding rests on. Unlike quote, an observation cannot be checked against the record: judge it against the image at the media item's permalink.
        field(
          :media_observations,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::ScreeningMediaObservation)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("media_observations")}}
        )

        sig {
          params(
            id: ::String,
            category: Models::Shared::FindingCategory,
            band: Models::Shared::FindingBand,
            confidence: ::Float,
            rationale: ::String,
            evidence: T::Array[::String],
            analyser: ::String,
            model: ::String,
            spend_minor: ::Integer,
            created_at: ::String,
            capped_from: T.nilable(Models::Shared::FindingBand),
            quote: T.nilable(::String),
            media_observations: T.nilable(T::Array[Models::Shared::ScreeningMediaObservation])
          )
            .void
        }
        def initialize(
          id:,
          category:,
          band:,
          confidence:,
          rationale:,
          evidence:,
          analyser:,
          model:,
          spend_minor:,
          created_at:,
          capped_from: nil,
          quote: nil,
          media_observations: nil
        )
          @id = id
          @category = category
          @band = band
          @confidence = confidence
          @rationale = rationale
          @evidence = evidence
          @analyser = analyser
          @model = model
          @spend_minor = spend_minor
          @created_at = created_at
          @capped_from = capped_from
          @quote = quote
          @media_observations = media_observations
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @category == other.category
          return false unless @band == other.band
          return false unless @confidence == other.confidence
          return false unless @rationale == other.rationale
          return false unless @evidence == other.evidence
          return false unless @analyser == other.analyser
          return false unless @model == other.model
          return false unless @spend_minor == other.spend_minor
          return false unless @created_at == other.created_at
          return false unless @capped_from == other.capped_from
          return false unless @quote == other.quote
          return false unless @media_observations == other.media_observations
          true
        end
      end
    end
  end
end
