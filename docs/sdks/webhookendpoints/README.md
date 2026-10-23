# WebhookEndpoints

## Overview

Your webhook endpoints: register, list, rotate signing keys, send test events and delete.

### Available Operations

* [list](#list) - List the workspace's webhook endpoints.
* [create](#create) - Register a webhook endpoint.
* [delete](#delete) - Delete a webhook endpoint.
* [rotate_signing_key](#rotate_signing_key) - Rotate an endpoint's signing key.
* [send_test_event](#send_test_event) - Send a test event to an endpoint.
* [list_deliveries](#list_deliveries) - List an endpoint's delivery attempts.
* [replay_delivery](#replay_delivery) - Send one delivery again.

## list

Lists your webhook endpoints in every state, ordered by endpoint_id, with the ids of their signing keys and without secrets. Requires the webhooks scope.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listWebhookEndpoints" method="get" path="/v1/webhooks" example="endpoints" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.list

unless res.nil?
  # handle response
end

```

### Response

**[T.nilable(Models::Operations::ListWebhookEndpointsResponse)](../../models/operations/listwebhookendpointsresponse.md)**

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

Registers a webhook endpoint and returns it with its first signing secret, shown only in this answer: store it where your receiver reads it. The URL is https on port 443 or 8443 with a DNS host whose every address is public; it is checked now and on every delivery. The endpoint starts unverified and receives assessment events once it echoes an endpoint.verification challenge, which sendTestEvent sends. You can hold 5 endpoints. Requires the webhooks scope, and response_mode detailed also the detailed scope. Registration is not idempotent: a retry after a lost answer registers a second endpoint, which you can list and delete.

### Example Usage: created

<!-- UsageSnippet language="ruby" operationID="createWebhookEndpoint" method="post" path="/v1/webhooks" example="created" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::WebhookEndpointRequest.new(
  url: 'https://hooks.example.com/noresponse'
)
res = s.webhook_endpoints.create(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: detailed

<!-- UsageSnippet language="ruby" operationID="createWebhookEndpoint" method="post" path="/v1/webhooks" example="detailed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::WebhookEndpointRequest.new(
  url: 'https://hooks.example.com:8443/noresponse/detailed',
  response_mode: Models::Shared::ResponseMode::DETAILED
)
res = s.webhook_endpoints.create(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: standard

<!-- UsageSnippet language="ruby" operationID="createWebhookEndpoint" method="post" path="/v1/webhooks" example="standard" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::WebhookEndpointRequest.new(
  url: 'https://hooks.example.com/noresponse'
)
res = s.webhook_endpoints.create(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                               | Type                                                                                    | Required                                                                                | Description                                                                             |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `request`                                                                               | [Models::Shared::WebhookEndpointRequest](../../models/shared/webhookendpointrequest.md) | :heavy_check_mark:                                                                      | The request object to use for the request.                                              |

### Response

**[T.nilable(Models::Operations::CreateWebhookEndpointResponse)](../../models/operations/createwebhookendpointresponse.md)**

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

Deletes the endpoint and its signing keys. Deliveries still queued for it are dropped. Requires the webhooks scope. An endpoint that is already gone answers 404.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteWebhookEndpoint" method="delete" path="/v1/webhooks/{endpoint_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.delete(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                    | Type                                                                                         | Required                                                                                     | Description                                                                                  | Example                                                                                      |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `endpoint_id`                                                                                | *::String*                                                                                   | :heavy_check_mark:                                                                           | The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404. | whe_01JA2ZD0E1F2G3H4J5K6M7N8P9                                                               |

### Response

**[T.nilable(Models::Operations::DeleteWebhookEndpointResponse)](../../models/operations/deletewebhookendpointresponse.md)**

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

## rotate_signing_key

Issues a new signing key for the endpoint and returns its secret once. Every delivery from now on is signed with it; the key it replaces keeps verifying for 7 days, so your receiver can hold both while it switches. Requires the webhooks scope. Rotation is not idempotent: a retry after a lost answer issues another key, which replaces the first.

### Example Usage: empty

<!-- UsageSnippet language="ruby" operationID="rotateWebhookSigningKey" method="post" path="/v1/webhooks/{endpoint_id}/rotate" example="empty" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.rotate_signing_key(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', body: Models::Shared::WebhookKeyRotationRequest.new)

unless res.nil?
  # handle response
end

```
### Example Usage: rotated

<!-- UsageSnippet language="ruby" operationID="rotateWebhookSigningKey" method="post" path="/v1/webhooks/{endpoint_id}/rotate" example="rotated" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.rotate_signing_key(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', body: Models::Shared::WebhookKeyRotationRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                     | Type                                                                                          | Required                                                                                      | Description                                                                                   | Example                                                                                       |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `endpoint_id`                                                                                 | *::String*                                                                                    | :heavy_check_mark:                                                                            | The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404.  | whe_01JA2ZD0E1F2G3H4J5K6M7N8P9                                                                |
| `body`                                                                                        | [Models::Shared::WebhookKeyRotationRequest](../../models/shared/webhookkeyrotationrequest.md) | :heavy_check_mark:                                                                            | N/A                                                                                           |                                                                                               |

### Response

**[T.nilable(Models::Operations::RotateWebhookSigningKeyResponse)](../../models/operations/rotatewebhooksigningkeyresponse.md)**

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

## send_test_event

endpoint.verification sends a signed challenge now and answers whether the endpoint echoed it within 5 seconds; an echo verifies the endpoint, including a disabled one. assessment.updated queues one signed event with test: true and a fixed example assessment in the endpoint's response mode, delivered and retried like any other event; the endpoint must be verified. Both use the endpoint's current signing key. Requires the webhooks scope.

### Example Usage: assessment_updated

<!-- UsageSnippet language="ruby" operationID="sendWebhookTestEvent" method="post" path="/v1/webhooks/{endpoint_id}/test" example="assessment_updated" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.send_test_event(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', body: Models::Shared::WebhookTestRequest.new(
  event: Models::Shared::WebhookTestRequestEvent::ASSESSMENT_UPDATED
))

unless res.nil?
  # handle response
end

```
### Example Usage: verification

<!-- UsageSnippet language="ruby" operationID="sendWebhookTestEvent" method="post" path="/v1/webhooks/{endpoint_id}/test" example="verification" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.send_test_event(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', body: Models::Shared::WebhookTestRequest.new(
  event: Models::Shared::WebhookTestRequestEvent::ENDPOINT_VERIFICATION
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                    | Type                                                                                         | Required                                                                                     | Description                                                                                  | Example                                                                                      |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `endpoint_id`                                                                                | *::String*                                                                                   | :heavy_check_mark:                                                                           | The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404. | whe_01JA2ZD0E1F2G3H4J5K6M7N8P9                                                               |
| `body`                                                                                       | [Models::Shared::WebhookTestRequest](../../models/shared/webhooktestrequest.md)              | :heavy_check_mark:                                                                           | N/A                                                                                          |                                                                                              |

### Response

**[T.nilable(Models::Operations::SendWebhookTestEventResponse)](../../models/operations/sendwebhooktesteventresponse.md)**

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

## list_deliveries

Every POST the endpoint received, newest first: the event id and type, which attempt it was, whether it was a replay, delivered or failed, the response code, why it failed and how long it took. Attempts are kept for 30 days, or your retention_days when that is shorter, and are deleted with the assessment they carried. Requires the webhooks scope. Read-only and safe to retry. The cursor is opaque and bound to your workspace and the endpoint; a tampered or expired cursor answers 400 invalid_cursor.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listWebhookDeliveries" method="get" path="/v1/webhooks/{endpoint_id}/deliveries" example="attempts" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.list_deliveries(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', limit: 20)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                    | Type                                                                                         | Required                                                                                     | Description                                                                                  | Example                                                                                      |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `endpoint_id`                                                                                | *::String*                                                                                   | :heavy_check_mark:                                                                           | The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404. | whe_01JA2ZD0E1F2G3H4J5K6M7N8P9                                                               |
| `limit`                                                                                      | *T.nilable(::Integer)*                                                                       | :heavy_minus_sign:                                                                           | Attempts per page.                                                                           |                                                                                              |
| `cursor`                                                                                     | *T.nilable(::String)*                                                                        | :heavy_minus_sign:                                                                           | next_cursor from the previous page, unchanged.                                               |                                                                                              |

### Response

**[T.nilable(Models::Operations::ListWebhookDeliveriesResponse)](../../models/operations/listwebhookdeliveriesresponse.md)**

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

## replay_delivery

Queues the event for the endpoint again: the same event id and body it received, with a new NR-Webhook-Timestamp and a signature from the endpoint's current signing key, retried like any other delivery and listed with replay: true. Your receiver deduplicates on the event id. The endpoint must be verified. Requires the webhooks scope. Not idempotent: each call, a retry included, sends the event again.

### Example Usage: empty

<!-- UsageSnippet language="ruby" operationID="replayWebhookDelivery" method="post" path="/v1/webhooks/{endpoint_id}/deliveries/{event_id}/replay" example="empty" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.replay_delivery(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', event_id: 'evt_01JA2ZD3K4M5N6P7Q8R9S0T1V2', body: Models::Shared::WebhookReplayRequest.new)

unless res.nil?
  # handle response
end

```
### Example Usage: replay

<!-- UsageSnippet language="ruby" operationID="replayWebhookDelivery" method="post" path="/v1/webhooks/{endpoint_id}/deliveries/{event_id}/replay" example="replay" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.webhook_endpoints.replay_delivery(endpoint_id: 'whe_01JA2ZD0E1F2G3H4J5K6M7N8P9', event_id: 'evt_01JA2ZD3K4M5N6P7Q8R9S0T1V2', body: Models::Shared::WebhookReplayRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                   | Type                                                                                                                                                                                                                        | Required                                                                                                                                                                                                                    | Description                                                                                                                                                                                                                 | Example                                                                                                                                                                                                                     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `endpoint_id`                                                                                                                                                                                                               | *::String*                                                                                                                                                                                                                  | :heavy_check_mark:                                                                                                                                                                                                          | The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404.                                                                                                                                | whe_01JA2ZD0E1F2G3H4J5K6M7N8P9                                                                                                                                                                                              |
| `event_id`                                                                                                                                                                                                                  | *::String*                                                                                                                                                                                                                  | :heavy_check_mark:                                                                                                                                                                                                          | The evt_ id of a delivery the endpoint's log holds, as GET /v1/webhooks/{endpoint_id}/deliveries lists it. An id that is malformed, not sent to this endpoint, past the log's retention or another workspace's answers 404. | evt_01JA2ZD3K4M5N6P7Q8R9S0T1V2                                                                                                                                                                                              |
| `body`                                                                                                                                                                                                                      | [Models::Shared::WebhookReplayRequest](../../models/shared/webhookreplayrequest.md)                                                                                                                                         | :heavy_check_mark:                                                                                                                                                                                                          | N/A                                                                                                                                                                                                                         |                                                                                                                                                                                                                             |

### Response

**[T.nilable(Models::Operations::ReplayWebhookDeliveryResponse)](../../models/operations/replaywebhookdeliveryresponse.md)**

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