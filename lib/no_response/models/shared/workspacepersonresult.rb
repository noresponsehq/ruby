# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Create or reuse a workspace person.
      class WorkspacePersonResult
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :person,
          Models::Shared::WorkspacePerson,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person"), required: true}}
        )

        field(
          :suggested_matches,
          Crystalline::Array.new(Models::Shared::PersonMatch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("suggested_matches"), required: true}}
        )

        field(
          :created,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created"), required: true}}
        )

        sig {
          params(
            person: Models::Shared::WorkspacePerson,
            suggested_matches: T::Array[Models::Shared::PersonMatch],
            created: T::Boolean
          )
            .void
        }
        def initialize(person:, suggested_matches:, created:)
          @person = person
          @suggested_matches = suggested_matches
          @created = created
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person == other.person
          return false unless @suggested_matches == other.suggested_matches
          return false unless @created == other.created
          true
        end
      end
    end
  end
end
