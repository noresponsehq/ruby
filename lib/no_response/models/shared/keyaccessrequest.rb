# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class KeyAccessRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Explicit restrictions that override scope grants. An empty list restores the access supplied by the scopes. Rotation preserves these restrictions.
        field(
          :denied_actions,
          Crystalline::Array.new(Models::Shared::KeyAccessRequestDeniedAction),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denied_actions"), required: true}}
        )

        sig { params(denied_actions: T::Array[Models::Shared::KeyAccessRequestDeniedAction]).void }
        def initialize(denied_actions:)
          @denied_actions = denied_actions
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @denied_actions == other.denied_actions
          true
        end
      end
    end
  end
end
