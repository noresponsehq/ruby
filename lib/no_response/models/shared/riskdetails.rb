# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Detailed view only (response_mode=detailed, which needs the detailed scope); a standard answer leaves it out. Merged observations without provider, source, origin, raw breach record, value or score.
      class RiskDetails
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :phone_names,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::RiskDetailsPhoneName)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone_names")}}
        )
        # The matching breach tables, newest first, at most 100.
        field(
          :breaches,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Breach)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("breaches")}}
        )
        # Names found next to the identifiers in breach records, merged, with the number of distinct tables each was seen in.
        field(
          :breach_names,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::RiskDetailsBreachName)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("breach_names")}}
        )
        # The identity's dated footprint events, newest first, at most 300: the year and month, what happened (created, last_active, breached), the site, its category, the kind of evidence and the identifier it belongs to. No breach value: dates are coarsened to the month.
        field(
          :events,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::RiskDetailsEvent)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("events")}}
        )

        sig {
          params(
            phone_names: T.nilable(T::Array[Models::Shared::RiskDetailsPhoneName]),
            breaches: T.nilable(T::Array[Models::Shared::Breach]),
            breach_names: T.nilable(T::Array[Models::Shared::RiskDetailsBreachName]),
            events: T.nilable(T::Array[Models::Shared::RiskDetailsEvent])
          )
            .void
        }
        def initialize(phone_names: nil, breaches: nil, breach_names: nil, events: nil)
          @phone_names = phone_names
          @breaches = breaches
          @breach_names = breach_names
          @events = events
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @phone_names == other.phone_names
          return false unless @breaches == other.breaches
          return false unless @breach_names == other.breach_names
          return false unless @events == other.events
          true
        end
      end
    end
  end
end
