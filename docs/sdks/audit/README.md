# Audit

## Overview

Durable audit history, retention and delivery.

### Available Operations

* [list](#list) - List a workspace's audit log.
* [get_retention](#get_retention) - Read audit retention and available history.
* [update_retention](#update_retention) - Set bounded customer audit retention.
* [list_streams](#list_streams) - Read audit stream subscriptions.
* [configure_stream](#configure_stream) - Configure an audit stream subscription.
* [remove_stream](#remove_stream) - Remove an audit stream.
* [replay_stream](#replay_stream) - Replay an audit delivery.

## list

Read audit events within your current environment permissions. Filters apply before pagination.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listAuditEvents" method="get" path="/v1/workspaces/{workspace_id}/audit_events" example="page" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Operations::ListAuditEventsRequest.new(
  workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
)
res = s.audit.list(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                       | Type                                                                                            | Required                                                                                        | Description                                                                                     |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `request`                                                                                       | [Models::Operations::ListAuditEventsRequest](../../models/operations/listauditeventsrequest.md) | :heavy_check_mark:                                                                              | The request object to use for the request.                                                      |

### Response

**[T.nilable(Models::Operations::ListAuditEventsResponse)](../../models/operations/listauditeventsresponse.md)**

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

## get_retention

Read audit retention for the environment. The default is 365 days. Oldest available is an observation; it does not establish uninterrupted capture. Workspace-wide events follow the live storage policy.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getAuditRetention" method="get" path="/v1/workspaces/{workspace_id}/audit_settings/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.get_retention(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::AuditSettingsEnvironment::TEST)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `environment`                                                                                                                      | [Models::Shared::AuditSettingsEnvironment](../../models/shared/auditsettingsenvironment.md)                                        | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::GetAuditRetentionResponse)](../../models/operations/getauditretentionresponse.md)**

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

## update_retention

Set test-environment audit retention from 1 to 365 days with audit_manage scope. Live retention also governs workspace-wide audit events and requires a dashboard member authorised in both environments. Shortening immediately hides older events and invalidates audit exports; extending cannot restore deleted events. External receivers control copies already delivered.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="updateAuditRetention" method="patch" path="/v1/workspaces/{workspace_id}/audit_settings/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.update_retention(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Operations::Environment::TEST, body: Models::Shared::AuditSettingsRequest.new(
  retention_days: 90
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `environment`                                                                                                                      | [Models::Operations::Environment](../../models/operations/environment.md)                                                          | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                | test                                                                                                                               |
| `body`                                                                                                                             | [Models::Shared::AuditSettingsRequest](../../models/shared/auditsettingsrequest.md)                                                | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::UpdateAuditRetentionResponse)](../../models/operations/updateauditretentionresponse.md)**

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

## list_streams

List audit subscriptions and their endpoint state and latest delivery attempt. Streams use verified HTTPS webhook endpoints and signed audit.event bodies. Delivery is at least once and unordered; deduplicate by webhook id. An empty action filter accepts all actions within the chosen scope.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listAuditStreams" method="get" path="/v1/workspaces/{workspace_id}/audit_streams/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.list_streams(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::Environment::TEST)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `environment`                                                                                                                      | [Models::Shared::Environment](../../models/shared/environment.md)                                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::ListAuditStreamsResponse)](../../models/operations/listauditstreamsresponse.md)**

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

## configure_stream

Configure the action filter for one verified webhook endpoint. Requires audit_manage. Capture starts at subscription creation; use an audit export for available earlier events. Workspace-wide scope requires an unrestricted console member and is unavailable to API keys.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="configureAuditStream" method="post" path="/v1/workspaces/{workspace_id}/audit_streams/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.configure_stream(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::Environment::TEST, body: Models::Shared::AuditStreamRequest.new(
  endpoint_id: 'whe_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  actions: [
    'key.created',
    'member.access_changed',
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
| `environment`                                                                                                                      | [Models::Shared::Environment](../../models/shared/environment.md)                                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |
| `body`                                                                                                                             | [Models::Shared::AuditStreamRequest](../../models/shared/auditstreamrequest.md)                                                    | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::ConfigureAuditStreamResponse)](../../models/operations/configureauditstreamresponse.md)**

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

## remove_stream

Remove an audit subscription and cancel queued deliveries. Requires audit_manage. An HTTP delivery already in flight cannot be recalled. The endpoint remains registered for other event types.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="removeAuditStream" method="delete" path="/v1/workspaces/{workspace_id}/audit_streams/{environment}/{endpoint_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.remove_stream(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::Environment::LIVE, endpoint_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `environment`                                                                                                                      | [Models::Shared::Environment](../../models/shared/environment.md)                                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |
| `endpoint_id`                                                                                                                      | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::RemoveAuditStreamResponse)](../../models/operations/removeauditstreamresponse.md)**

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

## replay_stream

Replay a recorded delivery for the current audit subscription. Requires audit_manage. Source retention and the current action filter are checked again before sending. Expired or unsubscribed events are dropped.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="replayAuditStream" method="post" path="/v1/workspaces/{workspace_id}/audit_streams/{environment}/{endpoint_id}/replay" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.audit.replay_stream(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::Environment::TEST, endpoint_id: '<id>', body: Models::Shared::AuditStreamReplayRequest.new(
  event_id: 'evt_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `environment`                                                                                                                      | [Models::Shared::Environment](../../models/shared/environment.md)                                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |
| `endpoint_id`                                                                                                                      | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |
| `body`                                                                                                                             | [Models::Shared::AuditStreamReplayRequest](../../models/shared/auditstreamreplayrequest.md)                                        | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::ReplayAuditStreamResponse)](../../models/operations/replayauditstreamresponse.md)**

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