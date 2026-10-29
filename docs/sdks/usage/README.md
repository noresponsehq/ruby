# Usage

## Overview

Recorded usage for your environment.

### Available Operations

* [get](#get) - Read a workspace's usage.

## get

Read daily usage units for the environments you can access. These counts are unpriced. With live access it also returns the daily console lookup cap: used, limit and resets_at.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getUsage" method="get" path="/v1/workspaces/{workspace_id}/usage" example="usage" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.usage.get(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                          | Type                                                                                                                               | Required                                                                                                                           | Description                                                                                                                        | Example                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                     | *::String*                                                                                                                         | :heavy_check_mark:                                                                                                                 | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404. | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                     |
| `from`                                                                                                                             | *T.nilable(::String)*                                                                                                              | :heavy_minus_sign:                                                                                                                 | The first UTC day, as YYYY-MM-DD.                                                                                                  |                                                                                                                                    |
| `to`                                                                                                                               | *T.nilable(::String)*                                                                                                              | :heavy_minus_sign:                                                                                                                 | The last UTC day, included, as YYYY-MM-DD; no later than today.                                                                    |                                                                                                                                    |

### Response

**[T.nilable(Models::Operations::GetUsageResponse)](../../models/operations/getusageresponse.md)**

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