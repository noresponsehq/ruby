# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Adds or updates 1 to 500 people. A row naming an existing person of the group (the same external_id, else the same email, else the same phone) updates it.
      class PersonBatchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :people,
          Crystalline::Array.new(Models::Shared::PersonIdentity),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people"), required: true}}
        )

        sig { params(people: T::Array[Models::Shared::PersonIdentity]).void }
        def initialize(people:)
          @people = people
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @people == other.people
          true
        end
      end
    end
  end
end
