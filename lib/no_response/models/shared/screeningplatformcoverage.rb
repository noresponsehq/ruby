# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What a screening read on one platform.
      class ScreeningPlatformCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        # A platform a screening can cover. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
        field(
          :platform,
          Models::Shared::HandlePlatform,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HandlePlatform, false)
            }
          }
        )
        # covered read at least one profile; none_found looked and found no account; inaccessible found accounts that are private or locked; failed could not finish looking; unavailable has no resolver or collector enabled.
        field(
          :status,
          Models::Shared::ScreeningPlatformCoverageStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(
                Models::Shared::ScreeningPlatformCoverageStatus,
                false
              )
            }
          }
        )

        field(
          :accounts_found,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts_found"), required: true}}
        )

        field(
          :items_read,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items_read"), required: true}}
        )

        sig {
          params(
            platform: Models::Shared::HandlePlatform,
            status: Models::Shared::ScreeningPlatformCoverageStatus,
            accounts_found: ::Integer,
            items_read: ::Integer
          )
            .void
        }
        def initialize(platform:, status:, accounts_found:, items_read:)
          @platform = platform
          @status = status
          @accounts_found = accounts_found
          @items_read = items_read
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @platform == other.platform
          return false unless @status == other.status
          return false unless @accounts_found == other.accounts_found
          return false unless @items_read == other.items_read
          true
        end
      end
    end
  end
end
