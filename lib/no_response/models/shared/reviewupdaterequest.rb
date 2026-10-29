# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewUpdateRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :expected_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version"), required: true}}
        )

        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::ReviewUpdateRequestStatus),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ReviewUpdateRequestStatus, true)
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

        sig {
          params(
            expected_version: ::Integer,
            status: T.nilable(Models::Shared::ReviewUpdateRequestStatus),
            priority: T.nilable(Models::Shared::Priority),
            assignee: T.nilable(::String)
          )
            .void
        }
        def initialize(expected_version:, status: nil, priority: nil, assignee: nil)
          @expected_version = expected_version
          @status = status
          @priority = priority
          @assignee = assignee
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_version == other.expected_version
          return false unless @status == other.status
          return false unless @priority == other.priority
          return false unless @assignee == other.assignee
          true
        end
      end
    end
  end
end
