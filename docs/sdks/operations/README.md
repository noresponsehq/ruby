# Operations

## Overview

Retained outcomes, enforcement reports and review populations.

### Available Operations

* [summarize](#summarize) - Summarize retained account outcomes, enforcement reports and reviews.

## summarize

Read one retained snapshot of account outcomes, enforcement reports and review states for the environment and a window of at most 31 days. Each section declares its own population, numerator, denominator and label coverage. Current outcome heads preserve explicit unknown labels. Enforcement rows are reports from your application and do not independently verify execution. Requires history or investigate together with management scope. A result exceeding 100000 population rows or the query budget is refused without truncation.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="summarizeWorkspaceOperations" method="post" path="/v1/workspaces/{workspace_id}/operations/summary" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.operations.summarize(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::WorkspaceOperationsSummaryRequest.new(
  environment: Models::Shared::AuditSettingsEnvironment::LIVE,
  from: '2026-01-01T00:00:00Z',
  to: '2026-01-02T00:00:00Z'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `body`                                                                                                                             | [Models::Shared::WorkspaceOperationsSummaryRequest](../../models/shared/workspaceoperationssummaryrequest.md)                      | :heavy_check_mark:                                                                                                                 | N/A                                                                                                                                |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::SummarizeWorkspaceOperationsResponse)](../../models/operations/summarizeworkspaceoperationsresponse.md)**

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