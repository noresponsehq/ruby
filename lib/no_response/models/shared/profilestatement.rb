# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ProfileStatement
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :topic,
          Models::Shared::Topic,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("topic"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Topic, false)
            }
          }
        )

        field :text, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("text"), required: true}}
        # confirmed: a linked record or the searched identifier states it directly. likely: a strong inference. possible: a weak inference.
        field(
          :certainty,
          Models::Shared::Certainty,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("certainty"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Certainty, false)
            }
          }
        )
        # stated: read from a record. inferred: reasoned from several facts. absence: every source answered and none found it.
        field(
          :basis,
          Models::Shared::Basis,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("basis"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Basis, false)
            }
          }
        )
        # Other explanations to keep open for an inference.
        field(
          :alternatives,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("alternatives"), required: true}}
        )
        # Every record, post or check the statement rests on.
        field(
          :evidence,
          Crystalline::Array.new(Models::Shared::ProfileCitation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence"), required: true}}
        )

        sig {
          params(
            topic: Models::Shared::Topic,
            text: ::String,
            certainty: Models::Shared::Certainty,
            basis: Models::Shared::Basis,
            alternatives: T::Array[::String],
            evidence: T::Array[Models::Shared::ProfileCitation]
          )
            .void
        }
        def initialize(topic:, text:, certainty:, basis:, alternatives:, evidence:)
          @topic = topic
          @text = text
          @certainty = certainty
          @basis = basis
          @alternatives = alternatives
          @evidence = evidence
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @topic == other.topic
          return false unless @text == other.text
          return false unless @certainty == other.certainty
          return false unless @basis == other.basis
          return false unless @alternatives == other.alternatives
          return false unless @evidence == other.evidence
          true
        end
      end
    end
  end
end
