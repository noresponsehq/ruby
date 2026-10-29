# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read a past [from,to) interval of at most 31 days. The complete retained populations must fit a combined 100000-row budget and a 1500ms SQL statement budget. No pagination or sampled totals; choose a shorter interval after a row-budget refusal.
      class WorkspaceOperationsSummaryRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}

        sig { params(environment: Models::Shared::AuditSettingsEnvironment, from: ::String, to: ::String).void }
        def initialize(environment:, from:, to:)
          @environment = environment
          @from = from
          @to = to
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @environment == other.environment
          return false unless @from == other.from
          return false unless @to == other.to
          true
        end
      end
    end
  end
end
