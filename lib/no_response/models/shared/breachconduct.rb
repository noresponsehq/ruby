# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BreachConduct - What a breach table's rows record against the identifier: chargeback, one or more chargebacks; declined_payment, one or more declined payments; forum_sanction, a forum ban, warning or infraction. A category and not a value: the schema has no member for one.
      class BreachConduct
        include ::Crystalline::Enum
        enums do
          CHARGEBACK = new("chargeback")
          DECLINED_PAYMENT = new("declined_payment")
          FORUM_SANCTION = new("forum_sanction")
        end

        open!
      end
    end
  end
end
