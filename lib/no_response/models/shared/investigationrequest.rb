# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Runs a new investigation against one retained workspace person.
      class InvestigationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :depth,
          Models::Shared::ScreeningDepth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningDepth, false)
            }
          }
        )

        field(
          :platforms,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms"), required: true}}
        )

        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )

        sig { params(depth: Models::Shared::ScreeningDepth, platforms: T::Array[::String], person_id: ::String).void }
        def initialize(depth:, platforms:, person_id:)
          @depth = depth
          @platforms = platforms
          @person_id = person_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @depth == other.depth
          return false unless @platforms == other.platforms
          return false unless @person_id == other.person_id
          true
        end
      end
    end
  end
end
