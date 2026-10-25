# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Use account_creation or its deprecated alias signup, not both.
      class SettingsRequestFlows
        extend T::Sig
        include Crystalline::MetadataFields

        # A change to one flow. A field left out keeps the value in force. Thresholds set on login or purchase start from the values in force, account_creation's while it inherits them. After the change, 0 < step_up < review <= 100 and block is off or review <= block <= 100.
        field(
          :account_creation,
          Crystalline::Nilable.new(Models::Shared::FlowChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_creation")}}
        )
        # A change to one flow. A field left out keeps the value in force. Thresholds set on login or purchase start from the values in force, account_creation's while it inherits them. After the change, 0 < step_up < review <= 100 and block is off or review <= block <= 100.
        field(
          :login,
          Crystalline::Nilable.new(Models::Shared::FlowChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("login")}}
        )
        # A change to one flow. A field left out keeps the value in force. Thresholds set on login or purchase start from the values in force, account_creation's while it inherits them. After the change, 0 < step_up < review <= 100 and block is off or review <= block <= 100.
        field(
          :purchase,
          Crystalline::Nilable.new(Models::Shared::FlowChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("purchase")}}
        )
        # A change to one flow. A field left out keeps the value in force. Thresholds set on login or purchase start from the values in force, account_creation's while it inherits them. After the change, 0 < step_up < review <= 100 and block is off or review <= block <= 100.
        field(
          :signup,
          Crystalline::Nilable.new(Models::Shared::FlowChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signup")}}
        )

        sig {
          params(
            account_creation: T.nilable(Models::Shared::FlowChange),
            login: T.nilable(Models::Shared::FlowChange),
            purchase: T.nilable(Models::Shared::FlowChange),
            signup: T.nilable(Models::Shared::FlowChange)
          )
            .void
        }
        def initialize(account_creation: nil, login: nil, purchase: nil, signup: nil)
          @account_creation = account_creation
          @login = login
          @purchase = purchase
          @signup = signup
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_creation == other.account_creation
          return false unless @login == other.login
          return false unless @purchase == other.purchase
          return false unless @signup == other.signup
          true
        end
      end
    end
  end
end
