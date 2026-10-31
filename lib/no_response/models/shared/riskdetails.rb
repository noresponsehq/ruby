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
        # Names found next to the identifiers in breach records, merged, with the number of distinct tables each was seen in and the sites of those tables.
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
        # Every online-account search of the email or username: the platform, what the search came to and, for an account found, what the platform returned beside it. Found first, then not found, then searches that failed or are still running, each by platform name; at most 64. A failed or running search keeps its own outcome and is not reported as not_found.
        field(
          :accounts,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::OnlineAccount)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts")}}
        )
        # What an identity_attribute_conflict reason weighed: each attribute the records disagree on and the sites reporting it. Absent when the reason did not fire, and on an answer stored before conflicts were recorded. No value is served.
        field(
          :attribute_conflicts,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::RiskDetailsAttributeConflict)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attribute_conflicts")}}
        )

        sig {
          params(
            phone_names: T.nilable(T::Array[Models::Shared::RiskDetailsPhoneName]),
            breaches: T.nilable(T::Array[Models::Shared::Breach]),
            breach_names: T.nilable(T::Array[Models::Shared::RiskDetailsBreachName]),
            events: T.nilable(T::Array[Models::Shared::RiskDetailsEvent]),
            accounts: T.nilable(T::Array[Models::Shared::OnlineAccount]),
            attribute_conflicts: T.nilable(T::Array[Models::Shared::RiskDetailsAttributeConflict])
          )
            .void
        }
        def initialize(
          phone_names: nil,
          breaches: nil,
          breach_names: nil,
          events: nil,
          accounts: nil,
          attribute_conflicts: nil
        )
          @phone_names = phone_names
          @breaches = breaches
          @breach_names = breach_names
          @events = events
          @accounts = accounts
          @attribute_conflicts = attribute_conflicts
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @phone_names == other.phone_names
          return false unless @breaches == other.breaches
          return false unless @breach_names == other.breach_names
          return false unless @events == other.events
          return false unless @accounts == other.accounts
          return false unless @attribute_conflicts == other.attribute_conflicts
          true
        end
      end
    end
  end
end
