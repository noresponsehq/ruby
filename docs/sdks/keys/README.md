# Keys

## Overview

Your own API keys.

### Available Operations

* [rotate](#rotate) - Rotate the API key that signs the request.
* [create](#create) - Create an API key.
* [list](#list) - List API keys.
* [revoke](#revoke) - Revoke an API key.

## rotate

Mints a new key with the same scopes as the key that signs the request and returns it once. The presented key keeps working for overlap_seconds (default 24 hours, from 60 seconds to 7 days), then answers 401. A key accepts one rotation: rotating again with a key already in its overlap answers 409 key_rotation_in_progress, so rotate with the new key. Rotation is not idempotent: a retry after a lost answer mints another key.

### Example Usage: default

<!-- UsageSnippet language="ruby" operationID="rotateApiKey" method="post" path="/v1/keys/rotate" example="default" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::KeyRotationRequest.new
res = s.keys.rotate(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: one_hour

<!-- UsageSnippet language="ruby" operationID="rotateApiKey" method="post" path="/v1/keys/rotate" example="one_hour" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::KeyRotationRequest.new(
  overlap_seconds: 3600
)
res = s.keys.rotate(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: rotated

<!-- UsageSnippet language="ruby" operationID="rotateApiKey" method="post" path="/v1/keys/rotate" example="rotated" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::KeyRotationRequest.new
res = s.keys.rotate(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                       | Type                                                                            | Required                                                                        | Description                                                                     |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `request`                                                                       | [Models::Shared::KeyRotationRequest](../../models/shared/keyrotationrequest.md) | :heavy_check_mark:                                                              | The request object to use for the request.                                      |

### Response

**[T.nilable(Models::Operations::RotateApiKeyResponse)](../../models/operations/rotateapikeyresponse.md)**

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

## create

Create an API key in the signing key environment with authority no greater than the issuer holds. Requires management. Optional name, purpose, kind and expiry describe its lifecycle. Send request_id for safe issuance retries: the first successful response returns the secret once; a repeat returns existing metadata without the secret, and changed parameters conflict. Without request_id a retry can create another key. A service credential is independent of its issuer; personal credentials require an authenticated member and retire when that member loses authority.

### Example Usage: live

<!-- UsageSnippet language="ruby" operationID="createKey" method="post" path="/v1/workspaces/{workspace_id}/keys" example="live" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.keys.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::KeyRequest.new(
  environment: Models::Shared::KeyEnvironment::LIVE,
  scopes: [
    Models::Shared::KeyRequestScope::ASSESS,
  ]
))

unless res.nil?
  # handle response
end

```
### Example Usage: test

<!-- UsageSnippet language="ruby" operationID="createKey" method="post" path="/v1/workspaces/{workspace_id}/keys" example="test" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.keys.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::KeyRequest.new(
  environment: Models::Shared::KeyEnvironment::TEST,
  scopes: [
    Models::Shared::KeyRequestScope::ASSESS,
    Models::Shared::KeyRequestScope::HISTORY,
    Models::Shared::KeyRequestScope::WEBHOOKS,
  ]
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `body`                                                                                                                             | [Models::Shared::KeyRequest](../../models/shared/keyrequest.md)                                                                    | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::CreateKeyResponse)](../../models/operations/createkeyresponse.md)**

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

Lists the keys of the signing key's environment, newest first, at most 200, revoked and expired keys included, without secrets: each key's id, prefix, scopes, status, and who created and revoked it. Requires the management scope. Read-only and safe to retry.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listKeys" method="get" path="/v1/workspaces/{workspace_id}/keys" example="list" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.keys.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |

### Response

**[T.nilable(Models::Operations::ListKeysResponse)](../../models/operations/listkeysresponse.md)**

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

## revoke

Revokes a key of the signing key's environment at once: its next request answers 401. Requires the management scope. A key of the other environment or of another workspace answers 404 not_found. A key cannot revoke itself (409 self_revocation): rotate it with keys.rotate, or revoke it with another management key. Revoking a revoked key changes nothing and answers the key as it was revoked, so a retry is safe.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="revokeKey" method="delete" path="/v1/workspaces/{workspace_id}/keys/{key_id}" example="key" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.keys.revoke(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', key_id: '01JA2ZE4K5M6N7P8Q9R0S1T2V3')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `key_id`                                                                                                                           | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | The key's id. A key of another workspace answers 404, as does a key of the other environment to an API key.                        | 01JA2ZE4K5M6N7P8Q9R0S1T2V3                                                                                                         |

### Response

**[T.nilable(Models::Operations::RevokeKeyResponse)](../../models/operations/revokekeyresponse.md)**

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