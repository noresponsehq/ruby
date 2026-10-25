# Integrations

## Overview

Hosted endpoints that answer your sign-up and sign-in hooks.

### Available Operations

* [create](#create) - Register a hosted provider integration.
* [list](#list) - List the workspace's integrations.
* [delete](#delete) - Delete an integration.
* [rotate](#rotate) - Replace an integration's secret.

## create

Registers a WorkOS, Auth0 or Supabase integration and returns its hosted endpoint, url, so a sign-up or sign-in is scored with no server of your own. For WorkOS, send the Actions signing secret from the WorkOS dashboard and point the user registration and authentication Actions at url. For Supabase, send the hook secret Supabase generates (v1,whsec_...) and set url as the Before User Created hook's HTTPS endpoint. For Auth0, the answer's secret is the shared secret of the NoResponse Auth0 Action, shown once: store it as an Action secret. hook_points defaults to every hook point the platform has (Supabase has only pre_registration); an event that is not listed is allowed without an assessment. The endpoint waits for the full assessment for at most 2.5 seconds (WorkOS, Supabase) or 4.5 seconds (Auth0), denies only when risk.block is true and allows on any failure. Requires the integrations scope; at most 10 per account. Not idempotent: a retry after a lost answer registers another integration.

### Example Usage: auth0

<!-- UsageSnippet language="ruby" operationID="createIntegration" method="post" path="/v1/integrations" example="auth0" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::IntegrationRequest.new(
  platform: Models::Shared::IntegrationPlatform::AUTH0
)
res = s.integrations.create(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: supabase

<!-- UsageSnippet language="ruby" operationID="createIntegration" method="post" path="/v1/integrations" example="supabase" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::IntegrationRequest.new(
  platform: Models::Shared::IntegrationPlatform::SUPABASE,
  signing_secret: 'v1,whsec_dGVzdC1zdXBhYmFzZS1ob29rLXNlY3JldC1ub3QtcmVhbA=='
)
res = s.integrations.create(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: workos

<!-- UsageSnippet language="ruby" operationID="createIntegration" method="post" path="/v1/integrations" example="workos" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::IntegrationRequest.new(
  platform: Models::Shared::IntegrationPlatform::WORKOS,
  hook_points: [
    Models::Shared::IntegrationHookPoint::PRE_REGISTRATION,
    Models::Shared::IntegrationHookPoint::POST_LOGIN,
  ],
  signing_secret: 'wos_action_secret_k3Yx8pQ2mN7vR4tW'
)
res = s.integrations.create(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                       | Type                                                                            | Required                                                                        | Description                                                                     |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `request`                                                                       | [Models::Shared::IntegrationRequest](../../models/shared/integrationrequest.md) | :heavy_check_mark:                                                              | The request object to use for the request.                                      |

### Response

**[T.nilable(Models::Operations::CreateIntegrationResponse)](../../models/operations/createintegrationresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## list

Every integration, oldest first. Listings carry no secrets. Requires the integrations scope.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listIntegrations" method="get" path="/v1/integrations" example="list" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.integrations.list

unless res.nil?
  # handle response
end

```

### Response

**[T.nilable(Models::Operations::ListIntegrationsResponse)](../../models/operations/listintegrationsresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## delete

Removes the integration and its secrets; its endpoint answers 404 from then on, so remove the Action from the provider first. Requires the integrations scope. An unknown or already deleted integration answers 404.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteIntegration" method="delete" path="/v1/integrations/{integration_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.integrations.delete(integration_id: 'int_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                             | Type                                                                                                                                  | Required                                                                                                                              | Description                                                                                                                           | Example                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `integration_id`                                                                                                                      | *::String*                                                                                                                            | :heavy_check_mark:                                                                                                                    | Path segment, matched case-sensitively. A value that does not match the integration_id shape, or another workspace's id, answers 404. | int_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                        |

### Response

**[T.nilable(Models::Operations::DeleteIntegrationResponse)](../../models/operations/deleteintegrationresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## rotate

For Auth0, send {} and the answer's secret is the new shared secret, shown once. For WorkOS, regenerate the Actions secret in the WorkOS dashboard and send it as signing_secret; for Supabase, generate a new hook secret in the Supabase dashboard and send it as signing_secret. The replaced secret is still accepted for 24 hours (previous_secret_expires_at). Requires the integrations scope. Not idempotent: a retry after a lost answer rotates again.

### Example Usage: auth0

<!-- UsageSnippet language="ruby" operationID="rotateIntegrationSecret" method="post" path="/v1/integrations/{integration_id}/rotate" example="auth0" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.integrations.rotate(integration_id: 'int_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::IntegrationRotationRequest.new)

unless res.nil?
  # handle response
end

```
### Example Usage: workos

<!-- UsageSnippet language="ruby" operationID="rotateIntegrationSecret" method="post" path="/v1/integrations/{integration_id}/rotate" example="workos" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.integrations.rotate(integration_id: 'int_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::IntegrationRotationRequest.new(
  signing_secret: 'wos_action_secret_Z9cD1eF5gH0jL4sP'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                             | Type                                                                                                                                  | Required                                                                                                                              | Description                                                                                                                           | Example                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `integration_id`                                                                                                                      | *::String*                                                                                                                            | :heavy_check_mark:                                                                                                                    | Path segment, matched case-sensitively. A value that does not match the integration_id shape, or another workspace's id, answers 404. | int_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                        |
| `body`                                                                                                                                | [Models::Shared::IntegrationRotationRequest](../../models/shared/integrationrotationrequest.md)                                       | :heavy_check_mark:                                                                                                                    | N/A                                                                                                                                   |                                                                                                                                       |

### Response

**[T.nilable(Models::Operations::RotateIntegrationSecretResponse)](../../models/operations/rotateintegrationsecretresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |