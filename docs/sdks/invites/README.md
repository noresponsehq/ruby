# Invites

## Overview

Workspace-bound invitation lifecycle.

### Available Operations

* [create](#create) - Invite a member.
* [list](#list) - List pending invites.
* [revoke](#revoke) - Revoke an invite.
* [resend](#resend) - Reissue an invitation for delivery.

## create

Create a workspace-bound invite for a non-owner role with a live members_manage key. The new token is returned once. Set external_user_id to bind acceptance to an exact verified provider subject; email is contact information. Creating a token does not send an email.

### Example Usage: bound

<!-- UsageSnippet language="ruby" operationID="createInvite" method="post" path="/v1/workspaces/{workspace_id}/invites" example="bound" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::InviteRequest.new(
  role: Models::Shared::Role::VIEWER,
  external_user_id: 'user_2EXAMPLE'
))

unless res.nil?
  # handle response
end

```
### Example Usage: invite

<!-- UsageSnippet language="ruby" operationID="createInvite" method="post" path="/v1/workspaces/{workspace_id}/invites" example="invite" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::InviteRequest.new(
  role: Models::Shared::Role::VIEWER,
  email: 'alex@example.com',
  external_user_id: 'user_teammate',
  environments: [
    Models::Shared::InviteRequestEnvironment::TEST,
  ]
))

unless res.nil?
  # handle response
end

```
### Example Usage: open

<!-- UsageSnippet language="ruby" operationID="createInvite" method="post" path="/v1/workspaces/{workspace_id}/invites" example="open" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::InviteRequest.new(
  role: Models::Shared::Role::DEVELOPER,
  email: 'dev@example.com'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `body`                                                                                                                             | [Models::Shared::InviteRequest](../../models/shared/inviterequest.md)                                                              | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                | {<br/>"role": "viewer",<br/>"email": "alex@example.com",<br/>"external_user_id": "user_teammate",<br/>"environments": [<br/>"test"<br/>]<br/>} |

### Response

**[T.nilable(Models::Operations::CreateInviteResponse)](../../models/operations/createinviteresponse.md)**

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

Read pending workspace invitations with a live members_manage key. Tokens are excluded. Expiry and token reissue timestamps describe invitation state; they do not establish email delivery.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listInvites" method="get" path="/v1/workspaces/{workspace_id}/invites" example="list" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |

### Response

**[T.nilable(Models::Operations::ListInvitesResponse)](../../models/operations/listinvitesresponse.md)**

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

Revoke a pending invitation with a live members_manage key. A revoked token cannot be accepted. Owner-role invitations remain outside machine delegation.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="revokeInvite" method="delete" path="/v1/workspaces/{workspace_id}/invites/{invite_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.revoke(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', invite_id: 'inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `invite_id`                                                                                                                        | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | The invite's inv_ id. An invite of another workspace, or one no longer pending, answers 404.                                       | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |

### Response

**[T.nilable(Models::Operations::RevokeInviteResponse)](../../models/operations/revokeinviteresponse.md)**

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

## resend

Reissue a pending non-owner invitation with a live members_manage key. The old token is invalidated and the new token is returned once with renewed expiry. Its role and permissions are preserved. This operation does not prove email delivery and is not automatically retried.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="resendInvite" method="post" path="/v1/workspaces/{workspace_id}/invites/{invite_id}/resend" example="invite" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.invites.resend(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', invite_id: 'inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::InviteResendRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `invite_id`                                                                                                                        | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | The invite's inv_ id. An invite of another workspace, or one no longer pending, answers 404.                                       | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `body`                                                                                                                             | [Models::Shared::InviteResendRequest](../../models/shared/inviteresendrequest.md)                                                  | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::ResendInviteResponse)](../../models/operations/resendinviteresponse.md)**

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