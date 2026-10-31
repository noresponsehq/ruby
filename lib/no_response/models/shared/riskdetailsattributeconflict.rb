# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsAttributeConflict
        extend T::Sig
        include Crystalline::MetadataFields

        # name_gender is the records' gender against the submitted first name's usual one.
        field(
          :attribute,
          Models::Shared::Attribute,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("attribute"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Attribute, false)
            }
          }
        )
        # The domains of the breached sites whose tables report the attribute, newest breach first, at most 32. Absent when none of the tables has a site.
        field(
          :sites,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sites")}}
        )
        # How many of the tables reporting the attribute have no site, such as a credential list or a stealer log. Absent when none.
        field(
          :unsited,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unsited")}}
        )

        sig {
          params(
            attribute: Models::Shared::Attribute,
            sites: T.nilable(T::Array[::String]),
            unsited: T.nilable(::Integer)
          )
            .void
        }
        def initialize(attribute:, sites: nil, unsited: nil)
          @attribute = attribute
          @sites = sites
          @unsited = unsited
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @attribute == other.attribute
          return false unless @sites == other.sites
          return false unless @unsited == other.unsited
          true
        end
      end
    end
  end
end
