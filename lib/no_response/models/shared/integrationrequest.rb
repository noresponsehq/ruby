# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/integrations body. Registers a hosted endpoint for one authentication provider. The workspace is the API key that signs the request, so the body has no workspace field and refuses one like any other unknown member. A WorkOS integration needs signing_secret, the Actions secret shown in the WorkOS dashboard, which NoResponse uses to verify each Action request and to sign its answer. An Auth0 integration sends no signing_secret: NoResponse generates the shared secret and returns it once.
      class IntegrationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The authentication provider that calls the endpoint.
        field(
          :platform,
          Models::Shared::IntegrationPlatform,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IntegrationPlatform, false)
            }
          }
        )
        # The provider events the endpoint scores. Default both: pre_registration (WorkOS user registration Action, Auth0 pre-user-registration trigger) and post_login (WorkOS authentication Action, Auth0 post-login trigger). An event that is not listed is answered allow without an assessment.
        field(
          :hook_points,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::IntegrationHookPoint)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("hook_points")}}
        )
        # The WorkOS Actions signing secret, as the WorkOS dashboard shows it: 16 to 256 printable ASCII characters with no spaces. It is stored sealed and is not returned.
        field(
          :signing_secret,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signing_secret")}}
        )

        sig {
          params(
            platform: Models::Shared::IntegrationPlatform,
            hook_points: T.nilable(T::Array[Models::Shared::IntegrationHookPoint]),
            signing_secret: T.nilable(::String)
          )
            .void
        }
        def initialize(platform:, hook_points: nil, signing_secret: nil)
          @platform = platform
          @hook_points = hook_points
          @signing_secret = signing_secret
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @platform == other.platform
          return false unless @hook_points == other.hook_points
          return false unless @signing_secret == other.signing_secret
          true
        end
      end
    end
  end
end
