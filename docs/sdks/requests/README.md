# Requests

## Overview

Retained request diagnostics and operational summaries.

### Available Operations

* [list](#list) - Search request diagnostics
* [aggregate](#aggregate) - Summarise retained request attempts

## list

Search authenticated request attempts by time, route, status or request correlation id. The interval is at most seven days. Each attempt has a unique id and may include the exact served decision. Records are bounded best effort and exclude request bodies, secrets and source payloads. A repeated correlation id does not overwrite another attempt.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listRequestDiagnostics" method="get" path="/v1/requests" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Operations::ListRequestDiagnosticsRequest.new(
  from: '2026-10-21T00:00:00Z',
  to: '2026-10-22T00:00:00Z'
)
res = s.requests.list(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                     | Type                                                                                                          | Required                                                                                                      | Description                                                                                                   |
| ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `request`                                                                                                     | [Models::Operations::ListRequestDiagnosticsRequest](../../models/operations/listrequestdiagnosticsrequest.md) | :heavy_check_mark:                                                                                            | The request object to use for the request.                                                                    |

### Response

**[T.nilable(Models::Operations::ListRequestDiagnosticsResponse)](../../models/operations/listrequestdiagnosticsresponse.md)**

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

## aggregate

Count all retained matching request attempts and latency samples within seven days. Capture is best effort.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="aggregateRequests" method="post" path="/v1/requests/aggregate" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::RequestAggregateRequest.new(
  from: '2026-01-01T00:00:00Z',
  to: '2026-01-01T00:00:00Z',
  route: 'POST /v1/assessments',
  api_key_id: '01JA2Z8K6Q4V7W9XBCDEFGHJKM'
)
res = s.requests.aggregate(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                 | Type                                                                                      | Required                                                                                  | Description                                                                               |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `request`                                                                                 | [Models::Shared::RequestAggregateRequest](../../models/shared/requestaggregaterequest.md) | :heavy_check_mark:                                                                        | The request object to use for the request.                                                |

### Response

**[T.nilable(Models::Operations::AggregateRequestsResponse)](../../models/operations/aggregaterequestsresponse.md)**

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