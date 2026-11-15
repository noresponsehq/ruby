# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Adds 1 to 500 workspace people to the group. Reuses an explicit person_id or external_id. Matching email or phone values only suggest people; automatic merging is disabled.
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
