# Accounts

## Overview

Your accounts, each with one current risk, and their assessment history.

### Available Operations

* [get](#get) - Read an account's one current risk.
* [list_assessments](#list_assessments) - Page through one account's unexpired assessments.

## get

An account is the account_id you send with your assessments. Its current risk is the risk of its latest assessment with a decision (status complete or partial), scored as GET /v1/assessments/{assessment_id} scores that assessment, with a decision for each flow. Every assessment updates its account: once an assessment completes, the account carries its risk. Requires the history scope. Read-only and safe to retry. An account with no unexpired assessment that has a decision answers 404 not_found, and a malformed account_id answers 400 invalid_request.

### Example Usage: blocked

<!-- UsageSnippet language="ruby" operationID="getAccount" method="get" path="/v1/accounts/{account_id}" example="blocked" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.accounts.get(account_id: 'acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: current

<!-- UsageSnippet language="ruby" operationID="getAccount" method="get" path="/v1/accounts/{account_id}" example="current" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.accounts.get(account_id: 'acct_7f3a9c')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                       | Type                                                                                                                                                                                                            | Required                                                                                                                                                                                                        | Description                                                                                                                                                                                                     | Example                                                                                                                                                                                                         |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `account_id`                                                                                                                                                                                                    | *::String*                                                                                                                                                                                                      | :heavy_check_mark:                                                                                                                                                                                              | The account_id the tenant sends with its assessments, as one path segment (percent-encode '\|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request. | acct_7f3a9c                                                                                                                                                                                                     |

### Response

**[T.nilable(Models::Operations::GetAccountResponse)](../../models/operations/getaccountresponse.md)**

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

## list_assessments

The account's history: the same page as POST /v1/assessments/query for this account_id, newest first, each at its latest assessment_version. Requires the history scope. Read-only and safe to retry. An account with no assessments answers 200 with empty items. The cursor is opaque and bound to your tenant and the account; a tampered or expired cursor answers 400 invalid_cursor. response_mode=detailed needs the detailed scope. The account_id travels in the URL; use POST /v1/assessments/query to keep it out of access logs.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listAccountAssessments" method="get" path="/v1/accounts/{account_id}/assessments" example="page" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.accounts.list_assessments(account_id: 'acct_7f3a9c', limit: 20)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                       | Type                                                                                                                                                                                                            | Required                                                                                                                                                                                                        | Description                                                                                                                                                                                                     | Example                                                                                                                                                                                                         |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `account_id`                                                                                                                                                                                                    | *::String*                                                                                                                                                                                                      | :heavy_check_mark:                                                                                                                                                                                              | The account_id the tenant sends with its assessments, as one path segment (percent-encode '\|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request. | acct_7f3a9c                                                                                                                                                                                                     |
| `limit`                                                                                                                                                                                                         | *T.nilable(::Integer)*                                                                                                                                                                                          | :heavy_minus_sign:                                                                                                                                                                                              | Items per page.                                                                                                                                                                                                 |                                                                                                                                                                                                                 |
| `cursor`                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                           | :heavy_minus_sign:                                                                                                                                                                                              | next_cursor from the previous page, unchanged.                                                                                                                                                                  |                                                                                                                                                                                                                 |
| `response_mode`                                                                                                                                                                                                 | [T.nilable(Models::Shared::ResponseMode)](../../models/shared/responsemode.md)                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                                                              | Optional standard or separately authorised detailed customer view; raw is rejected.                                                                                                                             |                                                                                                                                                                                                                 |

### Response

**[T.nilable(Models::Operations::ListAccountAssessmentsResponse)](../../models/operations/listaccountassessmentsresponse.md)**

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