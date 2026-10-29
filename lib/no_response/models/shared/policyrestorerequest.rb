# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Publish a captured configuration as a new version. Version checks and publication are atomic. Longer retention does not revive expired records, and restored policy does not undo customer enforcement.
      class PolicyRestoreRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("version"), required: true}}
        )

        field(
          :expected_policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_policy_version"), required: true}}
        )

        field(
          :change_reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("change_reason"), required: true}}
        )

        sig { params(version: ::Integer, expected_policy_version: ::Integer, change_reason: ::String).void }
        def initialize(version:, expected_policy_version:, change_reason:)
          @version = version
          @expected_policy_version = expected_policy_version
          @change_reason = change_reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @version == other.version
          return false unless @expected_policy_version == other.expected_policy_version
          return false unless @change_reason == other.change_reason
          true
        end
      end
    end
  end
end
