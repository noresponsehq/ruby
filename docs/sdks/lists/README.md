# Lists

## Overview

List entries, previews and durable changes.

### Available Operations

* [list](#list) - List an environment's list entries.
* [create](#create) - Add an entry to an environment's list.
* [delete](#delete) - Remove an entry from an environment's list.
* [preview](#preview) - Preview a list override change without side effects.
* [change](#change) - Apply an idempotent atomic bulk list change.
* [get_change](#get_change) - Read a bulk list change and propagation progress.

## list

Page through this environment allow and block entries, with canonical values, reasons and optional expiry. Requires settings or management. Follow the returned cursor until exhausted; a page is not the complete list. The cursor is bound to the environment and current filters.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listListEntries" method="get" path="/v1/workspaces/{workspace_id}/lists/{environment}" example="default" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `cursor`                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListListEntriesResponse)](../../models/operations/listlistentriesresponse.md)**

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

Add a canonical email or email-domain override with a reason and optional expiry. Requires settings plus policy_publish, or legacy management. Block wins over allow when both match. A small single-entry change retains the documented synchronous match budget; use lists.change for larger changes, whose account propagation is durable and resumable.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createListEntry" method="post" path="/v1/workspaces/{workspace_id}/lists/{environment}" example="default" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::ListEntryRequest.new(
  kind: Models::Shared::ListEntryKind::EMAIL_DOMAIN,
  value: 'throwaway.example',
  action: Models::Shared::ListEntryAction::BLOCK,
  note: 'Signup burst from one domain'
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
| `body`                                                                                                                                                                 | [Models::Shared::ListEntryRequest](../../models/shared/listentryrequest.md)                                                                                            | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CreateListEntryResponse)](../../models/operations/createlistentryresponse.md)**

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

Remove an override with settings plus policy_publish, or legacy management. The removal takes effect for new decisions and schedules resumable propagation across matching retained accounts. An unknown or already removed entry answers404. Account risk events announce changed decisions as propagation runs.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteListEntry" method="delete" path="/v1/workspaces/{workspace_id}/lists/{environment}/{list_entry_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.delete(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, list_entry_id: 'lst_01JA2ZE4K5M6N7P8Q9R0S1T2V3')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `list_entry_id`                                                                                                                                                        | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | The entry's id. An entry of another environment or workspace answers 404.                                                                                              | lst_01JA2ZE4K5M6N7P8Q9R0S1T2V3                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::DeleteListEntryResponse)](../../models/operations/deletelistentryresponse.md)**

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

Preview canonical list matches and current override effects with settings or management. The result states its bounded coverage and changes no list entries.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="previewList" method="post" path="/v1/workspaces/{workspace_id}/lists/{environment}/preview" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.preview(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::ListPreviewRequest.new(
  add: Models::Shared::ListEntryRequest.new(
    kind: Models::Shared::ListEntryKind::EMAIL_DOMAIN,
    value: 'example.com',
    action: Models::Shared::ListEntryAction::BLOCK
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
| `body`                                                                                                                                                                 | [Models::Shared::ListPreviewRequest](../../models/shared/listpreviewrequest.md)                                                                                        | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | {<br/>"add": {<br/>"kind": "email_domain",<br/>"value": "example.com",<br/>"action": "block"<br/>}<br/>}                                                               |

### Response

**[T.nilable(Models::Operations::PreviewListResponse)](../../models/operations/previewlistresponse.md)**

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

## change

Atomically add and remove a bounded batch of entries with an idempotency key. Requires settings plus policy_publish, or legacy management. The receipt exposes durable account propagation beyond the synchronous single-entry budget; poll lists.getChange until completion.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="changeLists" method="post" path="/v1/workspaces/{workspace_id}/lists/{environment}/bulk" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.change(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::ListBulkRequest.new(
  add: [
    Models::Shared::ListEntryRequest.new(
      kind: Models::Shared::ListEntryKind::EMAIL,
      value: 'throwaway.example',
      action: Models::Shared::ListEntryAction::BLOCK,
      note: 'Signup burst from one domain',
      expires_at: '2026-01-01T00:00:00Z'
    ),
  ],
  remove: [
    'lst_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  ]
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `workspace_id`                                                                                                                                                                                                                                                           | *::String*                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                       | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                                                                                                                       | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                           |
| `environment`                                                                                                                                                                                                                                                            | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                                                                                                                  | :heavy_check_mark:                                                                                                                                                                                                                                                       | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404.                                                                                                   |                                                                                                                                                                                                                                                                          |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::ListBulkRequest](../../models/shared/listbulkrequest.md)                                                                                                                                                                                                | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

### Response

**[T.nilable(Models::Operations::ChangeListsResponse)](../../models/operations/changelistsresponse.md)**

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

## get_change

Read retained propagation progress for a list change with settings or management.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getListChange" method="get" path="/v1/workspaces/{workspace_id}/list_changes/{environment}/{change_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.lists.get_change(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, change_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `change_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::GetListChangeResponse)](../../models/operations/getlistchangeresponse.md)**

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