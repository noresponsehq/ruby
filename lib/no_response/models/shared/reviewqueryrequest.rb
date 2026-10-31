# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewQueryRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Only reviews of this exact account in the authenticated workspace and environment. Applied before pagination.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )

        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::ReviewStatus),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReviewStatus, true)
            }
          }
        )

        field(
          :priority,
          Crystalline::Nilable.new(Models::Shared::Priority),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("priority"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Priority, true)
            }
          }
        )

        field(
          :assignee,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assignee")}}
        )

        field(
          :unassigned,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unassigned")}}
        )

        field(
          :assignee_principal_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assignee_principal_id")}}
        )

        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cursor")}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            account_id: T.nilable(::String),
            status: T.nilable(Models::Shared::ReviewStatus),
            priority: T.nilable(Models::Shared::Priority),
            assignee: T.nilable(::String),
            unassigned: T.nilable(T::Boolean),
            assignee_principal_id: T.nilable(::String),
            cursor: T.nilable(::String),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          account_id: nil,
          status: nil,
          priority: nil,
          assignee: nil,
          unassigned: nil,
          assignee_principal_id: nil,
          cursor: nil,
          limit: 50
        )
          @account_id = account_id
          @status = status
          @priority = priority
          @assignee = assignee
          @unassigned = unassigned
          @assignee_principal_id = assignee_principal_id
          @cursor = cursor
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @status == other.status
          return false unless @priority == other.priority
          return false unless @assignee == other.assignee
          return false unless @unassigned == other.unassigned
          return false unless @assignee_principal_id == other.assignee_principal_id
          return false unless @cursor == other.cursor
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
