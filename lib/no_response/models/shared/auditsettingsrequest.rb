# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AuditSettingsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :retention_days,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days"), required: true}}
        )

        sig { params(retention_days: ::Integer).void }
        def initialize(retention_days:)
          @retention_days = retention_days
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @retention_days == other.retention_days
          true
        end
      end
    end
  end
end
