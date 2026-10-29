# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Filter
        extend T::Sig
        include Crystalline::MetadataFields

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

        sig {
          params(
            status: T.nilable(Models::Shared::ReviewStatus),
            priority: T.nilable(Models::Shared::Priority),
            assignee: T.nilable(::String),
            unassigned: T.nilable(T::Boolean),
            assignee_principal_id: T.nilable(::String)
          )
            .void
        }
        def initialize(status: nil, priority: nil, assignee: nil, unassigned: nil, assignee_principal_id: nil)
          @status = status
          @priority = priority
          @assignee = assignee
          @unassigned = unassigned
          @assignee_principal_id = assignee_principal_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @status == other.status
          return false unless @priority == other.priority
          return false unless @assignee == other.assignee
          return false unless @unassigned == other.unassigned
          return false unless @assignee_principal_id == other.assignee_principal_id
          true
        end
      end
    end
  end
end
