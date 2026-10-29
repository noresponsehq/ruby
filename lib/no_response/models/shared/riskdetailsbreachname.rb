# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsBreachName
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )

        field(
          :seen_in,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("seen_in"), required: true}}
        )
        # The domains of the breached sites whose tables hold the name, lower case, each once, newest breach first, at most 32: the domain values of breaches[]. Covers the email's and the username's tables together. Absent when none of the tables has a site.
        field(
          :sites,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sites")}}
        )
        # How many of the tables that hold the name have no site, such as a credential list or a stealer log. Absent when none.
        field(
          :unsited,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unsited")}}
        )

        sig {
          params(
            value: ::String,
            seen_in: ::Integer,
            sites: T.nilable(T::Array[::String]),
            unsited: T.nilable(::Integer)
          )
            .void
        }
        def initialize(value:, seen_in:, sites: nil, unsited: nil)
          @value = value
          @seen_in = seen_in
          @sites = sites
          @unsited = unsited
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @value == other.value
          return false unless @seen_in == other.seen_in
          return false unless @sites == other.sites
          return false unless @unsited == other.unsited
          true
        end
      end
    end
  end
end
