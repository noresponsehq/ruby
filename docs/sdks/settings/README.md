# Settings

## Overview

Environment policy, history and previews.

### Available Operations

* [get](#get) - Read an environment's settings.
* [update](#update) - Change an environment's settings.
* [list_history](#list_history) - Read immutable configuration versions.
* [restore](#restore) - Restore captured settings as a new guarded version.
* [preview](#preview) - Preview exact retained-score threshold transitions without side effects.

## get

Read this environment retention, source selection and effective flow policies. A flow without its own thresholds inherits account_creation. Requires settings or management. Another environment answers404. Read-only and safe to retry.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getSettings" method="get" path="/v1/workspaces/{workspace_id}/settings/{environment}" example="default" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.get(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::GetSettingsResponse)](../../models/operations/getsettingsresponse.md)**

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

## update

Change named retention, source or flow settings in one transaction. Requires settings or management; changes to active policy also require policy_publish, which legacy management includes. Use expected_policy_version to reject concurrent changes and record a change_reason. Each accepted change creates a fresh version and an atomic audit event. Retention-only edits do not require policy publication authority. Flow thresholds preserve their declared ordering and bounds.

### Example Usage: changed

<!-- UsageSnippet language="ruby" operationID="updateSettings" method="patch" path="/v1/workspaces/{workspace_id}/settings/{environment}" example="changed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::SettingsRequest.new(
  retention_days: 30,
  expected_policy_version: 1,
  change_reason: 'Reviewed retention policy'
))

unless res.nil?
  # handle response
end

```
### Example Usage: flows

<!-- UsageSnippet language="ruby" operationID="updateSettings" method="patch" path="/v1/workspaces/{workspace_id}/settings/{environment}" example="flows" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::SettingsRequest.new(
  retention_days: 90,
  refused_sources: [
    Models::Shared::SourceId::PHONE,
  ],
  flows: Models::Shared::SettingsRequestFlows.new(
    account_creation: Models::Shared::FlowChange.new(
      admission: Models::Shared::Admission::HELD,
      hold_seconds: 600,
      on_expiry: Models::Shared::OnExpiry::REVIEW
    ),
    login: Models::Shared::FlowChange.new(
      step_up: 30,
      review: 60,
      block: nil,
      default_depth: Models::Shared::UsageCountDepth::FULL
    ),
    purchase: Models::Shared::FlowChange.new(
      inherits_account_creation: true
    )
  )
))

unless res.nil?
  # handle response
end

```
### Example Usage: signup

<!-- UsageSnippet language="ruby" operationID="updateSettings" method="patch" path="/v1/workspaces/{workspace_id}/settings/{environment}" example="signup" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::SettingsRequest.new(
  flows: Models::Shared::SettingsRequestFlows.new(
    account_creation: Models::Shared::FlowChange.new(
      block: 95
    )
  )
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::SettingsRequest](../../models/shared/settingsrequest.md)                                                                                              | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | {<br/>"expected_policy_version": 1,<br/>"change_reason": "Reviewed retention policy",<br/>"retention_days": 30<br/>}                                                   |

### Response

**[T.nilable(Models::Operations::UpdateSettingsResponse)](../../models/operations/updatesettingsresponse.md)**

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

## list_history

Read immutable configuration versions in one environment with settings or management. Follow before_version for older records.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listPolicyHistory" method="get" path="/v1/workspaces/{workspace_id}/settings/{environment}/history" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.list_history(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, limit: 50)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `before_version`                                                                                                                                                       | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListPolicyHistoryResponse)](../../models/operations/listpolicyhistoryresponse.md)**

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

## restore

Restore a retained configuration as a fresh version with the expected current version and a change reason. Requires settings plus policy_publish, or legacy management. Restore preserves the historical record and does not undo customer enforcement.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="restorePolicy" method="post" path="/v1/workspaces/{workspace_id}/settings/{environment}/restore" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.restore(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::PolicyRestoreRequest.new(
  version: 157_178,
  expected_policy_version: 260_899,
  change_reason: 'Adjust thresholds after reviewing retained evidence'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::PolicyRestoreRequest](../../models/shared/policyrestorerequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::RestorePolicyResponse)](../../models/operations/restorepolicyresponse.md)**

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

## preview

Compare proposed policy with bounded retained first answers, including baseline, coverage and uncertainty. Requires settings or management. This read starts no provider work and publishes no changes.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="previewPolicy" method="post" path="/v1/workspaces/{workspace_id}/settings/{environment}/preview" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.settings.preview(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::PolicyPreviewRequest.new(
  expected_policy_version: 789_985,
  from: '2026-01-01T00:00:00Z',
  to: '2026-01-01T00:00:00Z',
  flows: Models::Shared::PolicyPreviewRequestFlows.new
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::PolicyPreviewRequest](../../models/shared/policypreviewrequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::PreviewPolicyResponse)](../../models/operations/previewpolicyresponse.md)**

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