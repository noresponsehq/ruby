# Reviews

## Overview

Collaborative review cases, comments and linked subjects.

### Available Operations

* [list](#list) - List retained account reviews.
* [create](#create) - Open a review for a retained account.
* [get](#get) - Read an account review.
* [update](#update) - Assign, prioritize or reopen a guarded review.
* [resolve](#resolve) - Resolve a review against an exact account risk version.
* [list_comments](#list_comments) - Read retained review comments.
* [comment](#comment) - Append a comment against the current review version.
* [list_resolutions](#list_resolutions) - Read immutable review resolution history.
* [list_views](#list_views) - List your private and shared review filters.
* [create_view](#create_view) - Save a tenant-local review filter.
* [update_view](#update_view) - Replace your saved filter with optimistic concurrency.
* [delete_view](#delete_view) - Delete your saved filter with optimistic concurrency.
* [export](#export) - Export an account review
* [list_subjects](#list_subjects) - List retained subjects linked to a review.
* [add_subject](#add_subject) - Link retained tenant-local evidence to an investigation.
* [delete_subject](#delete_subject) - Remove a linked subject using the current review version.

## list

List retained investigation reviews using filters and an authenticated cursor. Optional account_id selects one exact account in this environment before pagination. All filters are bound into the cursor.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listReviews" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Operations::ListReviewsRequest.new(
  workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  environment: Models::Shared::KeyEnvironment::TEST
)
res = s.reviews.list(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                               | Type                                                                                    | Required                                                                                | Description                                                                             |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `request`                                                                               | [Models::Operations::ListReviewsRequest](../../models/operations/listreviewsrequest.md) | :heavy_check_mark:                                                                      | The request object to use for the request.                                              |

### Response

**[T.nilable(Models::Operations::ListReviewsResponse)](../../models/operations/listreviewsresponse.md)**

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

Open a review for one account. An account can have one active review in its environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createReview" method="post" path="/v1/workspaces/{workspace_id}/reviews/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::ReviewCreateRequest.new(
  account_id: 'acct_7f3a9c',
  assignee: 'usr_customer_admin'
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
| `body`                                                                                                                                                                 | [Models::Shared::ReviewCreateRequest](../../models/shared/reviewcreaterequest.md)                                                                                      | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CreateReviewResponse)](../../models/operations/createreviewresponse.md)**

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

Read a retained review and its current version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getReview" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.get(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::GetReviewResponse)](../../models/operations/getreviewresponse.md)**

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

Change review status, priority or assignment after checking the expected version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="updateReview" method="patch" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.update(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>', body: Models::Shared::ReviewUpdateRequest.new(
  expected_version: 14_577,
  assignee: 'usr_customer_admin'
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
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewUpdateRequest](../../models/shared/reviewupdaterequest.md)                                                                                      | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::UpdateReviewResponse)](../../models/operations/updatereviewresponse.md)**

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

## resolve

Resolve a review against the exact current review and account decision versions. A resolution does not report a factual outcome or execute enforcement.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="resolveReview" method="post" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/resolve" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.resolve(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, review_id: '<id>', body: Models::Shared::ReviewResolveRequest.new(
  expected_version: 902_778,
  expected_risk_version: 385_930,
  conclusion: Models::Shared::Conclusion::BENIGN,
  note: 'Reviewed the retained account evidence and customer report.'
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
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewResolveRequest](../../models/shared/reviewresolverequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ResolveReviewResponse)](../../models/operations/resolvereviewresponse.md)**

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

## list_comments

Page through retained review comments.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listReviewComments" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/comments" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.list_comments(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>', limit: 50)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `cursor`                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListReviewCommentsResponse)](../../models/operations/listreviewcommentsresponse.md)**

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

## comment

Append a comment after checking the expected review version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="commentReview" method="post" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/comments" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.comment(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>', body: Models::Shared::ReviewCommentRequest.new(
  expected_version: 181_980,
  body: 'Reviewed the retained account evidence and customer report.'
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
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewCommentRequest](../../models/shared/reviewcommentrequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CommentReviewResponse)](../../models/operations/commentreviewresponse.md)**

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

## list_resolutions

Page through immutable review resolutions.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listReviewResolutions" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/resolutions" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.list_resolutions(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>', limit: 50)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `before_version`                                                                                                                                                       | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListReviewResolutionsResponse)](../../models/operations/listreviewresolutionsresponse.md)**

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

## list_views

List private and shared saved review filters visible to you.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listReviewViews" method="get" path="/v1/workspaces/{workspace_id}/review_views/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.list_views(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE)

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

**[T.nilable(Models::Operations::ListReviewViewsResponse)](../../models/operations/listreviewviewsresponse.md)**

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

## create_view

Save a private or shared review filter.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createReviewView" method="post" path="/v1/workspaces/{workspace_id}/review_views/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.create_view(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::ReviewViewRequest.new(
  name: 'High priority reviews',
  shared: true,
  filter: Models::Shared::Filter.new(
    account_id: 'acct_7f3a9c',
    assignee: 'usr_customer_admin',
    assignee_principal_id: 'mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
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
| `body`                                                                                                                                                                 | [Models::Shared::ReviewViewRequest](../../models/shared/reviewviewrequest.md)                                                                                          | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CreateReviewViewResponse)](../../models/operations/createreviewviewresponse.md)**

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

## update_view

Update your saved review filter after checking its expected version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="updateReviewView" method="patch" path="/v1/workspaces/{workspace_id}/review_views/{environment}/{view_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.update_view(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, view_id: '<id>', body: Models::Shared::ReviewViewRequest.new(
  name: 'High priority reviews',
  shared: false,
  filter: Models::Shared::Filter.new(
    account_id: 'acct_7f3a9c',
    assignee: 'usr_customer_admin',
    assignee_principal_id: 'mem_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
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
| `view_id`                                                                                                                                                              | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewViewRequest](../../models/shared/reviewviewrequest.md)                                                                                          | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::UpdateReviewViewResponse)](../../models/operations/updatereviewviewresponse.md)**

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

## delete_view

Delete your saved review filter after checking its expected version.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteReviewView" method="delete" path="/v1/workspaces/{workspace_id}/review_views/{environment}/{view_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.delete_view(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, view_id: '<id>', body: Models::Shared::ReviewViewDeleteRequest.new(
  expected_version: 165_419
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
| `view_id`                                                                                                                                                              | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewViewDeleteRequest](../../models/shared/reviewviewdeleterequest.md)                                                                              | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::DeleteReviewViewResponse)](../../models/operations/deletereviewviewresponse.md)**

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

## export

Export retained review details, comments, resolutions and linked subjects. Requires current reviews.read and exports.read; API keys need management together with exports, history or audit_manage. The audit event commits before any bytes are returned. Oversized exports are refused without truncation; use the bounded collection APIs.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="exportReview" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/export" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.export(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, review_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ExportReviewResponse)](../../models/operations/exportreviewresponse.md)**

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

## list_subjects

List retained subjects linked to this review. A link supplies investigation context and does not prove a relationship or change account risk.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listReviewSubjects" method="get" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.list_subjects(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, review_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListReviewSubjectsResponse)](../../models/operations/listreviewsubjectsresponse.md)**

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

## add_subject

Link an account, exact assessment revision or issued-key association within this environment. Supply the expected review version. A review permits 100 links. Erasure removes links to erased subjects. This action records context without creating feedback or enforcement.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="addReviewSubject" method="post" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.add_subject(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, review_id: '<id>', body: Models::Shared::ReviewSubjectRequest.new(
  kind: Models::Shared::ReviewSubjectKind::ACCOUNT,
  account_id: 'acct_7f3a9c',
  assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  credential_id: 'cred_01JA2Z8K6Q4V7W9XBCDEFGHJKM',
  reason: 'Linked during review of the account evidence.',
  expected_version: 691_733
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
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewSubjectRequest](../../models/shared/reviewsubjectrequest.md)                                                                                    | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::AddReviewSubjectResponse)](../../models/operations/addreviewsubjectresponse.md)**

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

## delete_subject

Remove a subject link with the expected review version. The linked account, assessment or key association remains unchanged.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteReviewSubject" method="delete" path="/v1/workspaces/{workspace_id}/reviews/{environment}/{review_id}/subjects/{subject_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.reviews.delete_subject(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, review_id: '<id>', subject_id: 'rvs_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::ReviewViewDeleteRequest.new(
  expected_version: 299_624
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
| `review_id`                                                                                                                                                            | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `subject_id`                                                                                                                                                           | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | rvs_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::ReviewViewDeleteRequest](../../models/shared/reviewviewdeleterequest.md)                                                                              | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::DeleteReviewSubjectResponse)](../../models/operations/deletereviewsubjectresponse.md)**

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