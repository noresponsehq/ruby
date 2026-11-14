# Groups

## Overview

Groups, lists of people, screenings and reviewer decisions.

### Available Operations

* [list](#list) - List an environment's groups.
* [create](#create) - Create a group to screen.
* [get](#get) - Read a group.
* [update](#update) - Change a group.
* [delete](#delete) - Erase a group.
* [list_people](#list_people) - List a group's people.
* [add_people](#add_people) - Add or update a batch of people.
* [get_person](#get_person) - Read a person's report.
* [review_person](#review_person) - Record a decision on a person.
* [judge_record](#judge_record) - Join one of a person's records to them, or reject it.
* [list_screenings](#list_screenings) - List a group's screenings.
* [start_screening](#start_screening) - Start a screening.
* [get_screening](#get_screening) - Read a screening.
* [cancel_screening](#cancel_screening) - Cancel a screening.

## list

List this environment's groups, newest first. Pass next_before back as before for the next page. Requires the groups scope.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listGroups" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, limit: 20)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | At most this many items.                                                                                                                                               |                                                                                                                                                                        |
| `before`                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                     | Read groups older than this one.                                                                                                                                       |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListGroupsResponse)](../../models/operations/listgroupsresponse.md)**

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

Create a group to screen: its name, start, venue, host, the principals it protects and the sensitive topics posts are read against. An environment holds at most 1000 groups.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createGroup" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, body: Models::Shared::GroupRequest.new(
  name: 'Annual shareholder meeting',
  starts_at: '2026-01-01T00:00:00Z',
  ends_at: '2026-01-02T00:00:00Z',
  venue: 'Example Convention Centre',
  host: 'Example Holdings',
  principals: [
    Models::Shared::Principal.new(
      name: 'Alex Principal',
      aliases: [
        'Alex P',
      ]
    ),
  ],
  topics: [
    'executive pay',
  ]
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
| `body`                                                                                                                                                                 | [Models::Shared::GroupRequest](../../models/shared/grouprequest.md)                                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CreateGroupResponse)](../../models/operations/creategroupresponse.md)**

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

## get

Read a group and how many people it holds.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getGroup" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.get(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::GetGroupResponse)](../../models/operations/getgroupresponse.md)**

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

Change the fields you name. Send expected_version to apply the change only to that version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="updateGroup" method="patch" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::GroupUpdate.new(
  name: 'Annual shareholder meeting',
  starts_at: '2026-01-01T00:00:00Z',
  ends_at: '2026-01-02T00:00:00Z',
  venue: 'Example Convention Centre',
  host: 'Example Holdings',
  principals: [
    Models::Shared::Principal.new(
      name: 'Alex Principal',
      aliases: [
        'Alex P',
      ]
    ),
  ],
  topics: [
    'executive pay',
  ]
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
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::GroupUpdate](../../models/shared/groupupdate.md)                                                                                                      | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::UpdateGroupResponse)](../../models/operations/updategroupresponse.md)**

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

Erase a group with its people, their decisions and its screenings, and stop any screening still running.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteGroup" method="delete" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.delete(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::DeleteGroupResponse)](../../models/operations/deletegroupresponse.md)**

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

## list_people

Read a group's roster in upload order, with each person's match state, highest finding band and decision. Filter by band or decision; pass next_after back as after.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listPeople" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/people" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Operations::ListPeopleRequest.new(
  workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  environment: Models::Shared::KeyEnvironment::TEST,
  group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
)
res = s.groups.list_people(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                             | Type                                                                                  | Required                                                                              | Description                                                                           |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `request`                                                                             | [Models::Operations::ListPeopleRequest](../../models/operations/listpeoplerequest.md) | :heavy_check_mark:                                                                    | The request object to use for the request.                                            |

### Response

**[T.nilable(Models::Operations::ListPeopleResponse)](../../models/operations/listpeopleresponse.md)**

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

## add_people

Add or update 1 to 500 people with an Idempotency-Key. A row with the same external_id, else email, else phone as an existing person updates it. Identities are stored encrypted.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="addPeople" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/people" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.add_people(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::PersonBatchRequest.new(
  people: []
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
| `group_id`                                                                                                                                                                                                                                                               | *::String*                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                           |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::PersonBatchRequest](../../models/shared/personbatchrequest.md)                                                                                                                                                                                          | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

### Response

**[T.nilable(Models::Operations::AddPeopleResponse)](../../models/operations/addpeopleresponse.md)**

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

## get_person

Read a person's report: matched profiles, findings with their evidence, every recorded decision, and the other groups where the same email or phone appears.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getPerson" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/people/{person_id}" example="records" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.get_person(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `person_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::GetPersonResponse)](../../models/operations/getpersonresponse.md)**

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

## review_person

Record a cleared, watch or escalated decision with a note. The latest decision is the person's; the next screening refreshes everyone on watch or escalated.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="reviewPerson" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/people/{person_id}/review" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.review_person(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::PersonReviewRequest.new(
  decision: Models::Shared::PersonDecision::ESCALATED,
  note: 'Known to the venue team.'
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
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `person_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::PersonReviewRequest](../../models/shared/personreviewrequest.md)                                                                                      | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ReviewPersonResponse)](../../models/operations/reviewpersonresponse.md)**

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

## judge_record

Join one of a person's lookup records to them whatever its likelihood, or reject it so it stays a lead. The verdict sticks while lookups find the same record.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="judgeRecord" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/people/{person_id}/records" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.judge_record(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::RecordVerdictRequest.new(
  record_id: 'rec_3f9a1c22d4e5b6a73f9a1c22d4e5b6a7',
  verdict: Models::Shared::Verdict::REJECTED
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
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `person_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::RecordVerdictRequest](../../models/shared/recordverdictrequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::JudgeRecordResponse)](../../models/operations/judgerecordresponse.md)**

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

## list_screenings

List a group's screenings, newest first.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listScreenings" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/screenings" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.list_screenings(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', limit: 20)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | At most this many items.                                                                                                                                               |                                                                                                                                                                        |
| `before`                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                     | Read screenings older than this one.                                                                                                                                   |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListScreeningsResponse)](../../models/operations/listscreeningsresponse.md)**

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

## start_screening

Start a screening of new people and everyone on watch or escalated, with an Idempotency-Key. It finishes completed, partial or failed minutes to hours later; poll it. The answer carries estimated_spend; a screening whose estimate exceeds what the daily screening cap has left answers 409 screening_cap_exceeded. The test environment screens with the synthetic connector, which makes up deterministic profiles, posts and findings.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="startScreening" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/screenings" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.start_screening(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::ScreeningRequest.new(
  depth: Models::Shared::ScreeningDepth::STANDARD,
  platforms: []
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
| `group_id`                                                                                                                                                                                                                                                               | *::String*                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                           |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::ScreeningRequest](../../models/shared/screeningrequest.md)                                                                                                                                                                                              | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

### Response

**[T.nilable(Models::Operations::StartScreeningResponse)](../../models/operations/startscreeningresponse.md)**

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

## get_screening

Read a screening's status and progress.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getScreening" method="get" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/screenings/{screening_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.get_screening(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', screening_id: 'scn_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `screening_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | scn_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::GetScreeningResponse)](../../models/operations/getscreeningresponse.md)**

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

## cancel_screening

Stop a queued or running screening. People already screened keep their results.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="cancelScreening" method="post" path="/v1/workspaces/{workspace_id}/groups/{environment}/{group_id}/screenings/{screening_id}/cancel" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.groups.cancel_screening(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, group_id: 'grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM', screening_id: 'scn_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::ScreeningCancelRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `group_id`                                                                                                                                                             | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `screening_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | scn_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::ScreeningCancelRequest](../../models/shared/screeningcancelrequest.md)                                                                                | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CancelScreeningResponse)](../../models/operations/cancelscreeningresponse.md)**

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