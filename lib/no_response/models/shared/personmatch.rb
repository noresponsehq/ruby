# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonMatch
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )

        field(
          :matched_on,
          Crystalline::Array.new(Models::Shared::PersonMatchMatchedOn),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_on"), required: true}}
        )

        sig { params(person_id: ::String, matched_on: T::Array[Models::Shared::PersonMatchMatchedOn]).void }
        def initialize(person_id:, matched_on:)
          @person_id = person_id
          @matched_on = matched_on
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          return false unless @matched_on == other.matched_on
          true
        end
      end
    end
  end
end
