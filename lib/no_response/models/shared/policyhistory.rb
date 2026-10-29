# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Immutable settings snapshots, newest first. history_complete is false when earlier versions predate capture. A restored version is published with a fresh version number. History is removed with the tenant.
      class PolicyHistory
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::PolicyHistoryItem),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        field(
          :has_more,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("has_more"), required: true}}
        )

        field(
          :history_complete,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("history_complete"), required: true}}
        )

        field(
          :next_before_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_before_version")}}
        )

        sig {
          params(
            items: T::Array[Models::Shared::PolicyHistoryItem],
            has_more: T::Boolean,
            history_complete: T::Boolean,
            next_before_version: T.nilable(::Integer)
          )
            .void
        }
        def initialize(items:, has_more:, history_complete:, next_before_version: nil)
          @items = items
          @has_more = has_more
          @history_complete = history_complete
          @next_before_version = next_before_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @has_more == other.has_more
          return false unless @history_complete == other.history_complete
          return false unless @next_before_version == other.next_before_version
          true
        end
      end
    end
  end
end
