# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Cross-identifier agreement, computed from facts only. Every member is optional; absent makes no claim.
      class Consistency
        extend T::Sig
        include Crystalline::MetadataFields

        # How a submitted identifier agrees with what the evidence holds for the other identifiers. unknown is a definite 'cannot tell' (for example a truncated or too-common breach result); absent means the comparison was not made.
        field(
          :name,
          Crystalline::Nilable.new(Models::Shared::ConsistencyValue),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("name"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ConsistencyValue, true)
            }
          }
        )
        # How a submitted identifier agrees with what the evidence holds for the other identifiers. unknown is a definite 'cannot tell' (for example a truncated or too-common breach result); absent means the comparison was not made.
        field(
          :phone,
          Crystalline::Nilable.new(Models::Shared::ConsistencyValue),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("phone"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ConsistencyValue, true)
            }
          }
        )
        # How a submitted identifier agrees with what the evidence holds for the other identifiers. unknown is a definite 'cannot tell' (for example a truncated or too-common breach result); absent means the comparison was not made.
        field(
          :ip,
          Crystalline::Nilable.new(Models::Shared::ConsistencyValue),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("ip"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ConsistencyValue, true)
            }
          }
        )
        # IP country, phone country, breach countries and policy_context.region together. When the breach records give a country, the timezone and locale countries count too. The IP country of a proxy or hosting network does not count.
        field(
          :country,
          Crystalline::Nilable.new(Models::Shared::Country),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("country"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Country, true)
            }
          }
        )

        sig {
          params(
            name: T.nilable(Models::Shared::ConsistencyValue),
            phone: T.nilable(Models::Shared::ConsistencyValue),
            ip: T.nilable(Models::Shared::ConsistencyValue),
            country: T.nilable(Models::Shared::Country)
          )
            .void
        }
        def initialize(name: nil, phone: nil, ip: nil, country: nil)
          @name = name
          @phone = phone
          @ip = ip
          @country = country
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @phone == other.phone
          return false unless @ip == other.ip
          return false unless @country == other.country
          true
        end
      end
    end
  end
end
