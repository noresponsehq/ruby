# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One group the person belongs to and their role in it.
      class PersonGroup
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )

        field(
          :group_name,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_name"), required: true}}
        )
        # When the person was added to the group.
        field(
          :added_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("added_at"), required: true}}
        )
        # The group's optional event start; null for an ongoing group.
        field(
          :group_starts_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_starts_at"), required: true}}
        )
        # The person's role in the group: guest, crew, vendor or press, or null when it was not given.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::PersonRole),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonRole, false)
            }
          }
        )

        sig {
          params(
            group_id: ::String,
            group_name: ::String,
            added_at: ::String,
            group_starts_at: T.nilable(::String),
            role: T.nilable(Models::Shared::PersonRole)
          )
            .void
        }
        def initialize(group_id:, group_name:, added_at:, group_starts_at: nil, role: nil)
          @group_id = group_id
          @group_name = group_name
          @added_at = added_at
          @group_starts_at = group_starts_at
          @role = role
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @group_name == other.group_name
          return false unless @added_at == other.added_at
          return false unless @group_starts_at == other.group_starts_at
          return false unless @role == other.role
          true
        end
      end
    end
  end
end
