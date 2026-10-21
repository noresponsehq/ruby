# Keys

## Overview

Your own API keys.

### Available Operations

* [rotate](#rotate) - Rotate the API key that signs the request.

## rotate

Mints a new key with the same scopes as the key that signs the request and returns it once. The presented key keeps working for overlap_seconds (default 24 hours, from 60 seconds to 7 days), then answers 401. A key accepts one rotation: rotating again with a key already in its overlap answers 409 key_rotation_in_progress, so rotate with the new key. Rotation is not idempotent: a retry after a lost answer mints another key.

### Example Usage: default

<!-- UsageSnippet language="ruby" operationID="rotateApiKey" method="post" path="/v1/keys/rotate" example="default" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
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
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
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
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
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