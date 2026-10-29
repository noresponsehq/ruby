# Members

## Overview

Scoped workspace membership automation.

### Available Operations

* [list](#list) - List a workspace's members.
* [update](#update) - Change a member's role.
* [remove](#remove) - Remove a member.

## list

Read the workspace directory with a live key carrying members or members_manage. Member identities and grants belong to this workspace. Owner-controlled issuance limits team automation to authorised service credentials.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listMembers" method="get" path="/v1/workspaces/{workspace_id}/members" example="list" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.members.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |

### Response

**[T.nilable(Models::Operations::ListMembersResponse)](../../models/operations/listmembersresponse.md)**

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

Update a non-owner member role, environment access or sensitive permission exclusions with a live members_manage key. Owner changes, identity binding and support access remain outside this scope. The current delegation ceiling is checked within the change transaction.

### Example Usage: member

<!-- UsageSnippet language="ruby" operationID="updateMember" method="patch" path="/v1/workspaces/{workspace_id}/members/{member_id}" example="member" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.members.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', member_id: 'mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::MemberUpdateRequest.new(
  role: Models::Shared::Role::VIEWER,
  environments: [
    Models::Shared::MemberUpdateRequestEnvironment::TEST,
  ]
))

unless res.nil?
  # handle response
end

```
### Example Usage: role

<!-- UsageSnippet language="ruby" operationID="updateMember" method="patch" path="/v1/workspaces/{workspace_id}/members/{member_id}" example="role" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.members.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', member_id: 'mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::MemberUpdateRequest.new(
  role: Models::Shared::Role::ADMIN
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `member_id`                                                                                                                        | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | The member's mem_ id. A member of another workspace, or a removed one, answers 404.                                                | mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `body`                                                                                                                             | [Models::Shared::MemberUpdateRequest](../../models/shared/memberupdaterequest.md)                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                | {<br/>"role": "viewer",<br/>"environments": [<br/>"test"<br/>]<br/>}                                                               |

### Response

**[T.nilable(Models::Operations::UpdateMemberResponse)](../../models/operations/updatememberresponse.md)**

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

## remove

Remove a non-owner member with a live members_manage key. Subsequent access is refused and personal credentials are revoked. Independently owned service credentials follow their own lifecycle.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="removeMember" method="delete" path="/v1/workspaces/{workspace_id}/members/{member_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.members.remove(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', member_id: 'mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `member_id`                                                                                                                        | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | The member's mem_ id. A member of another workspace, or a removed one, answers 404.                                                | mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |

### Response

**[T.nilable(Models::Operations::RemoveMemberResponse)](../../models/operations/removememberresponse.md)**

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