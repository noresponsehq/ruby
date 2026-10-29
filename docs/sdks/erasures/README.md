# Erasures

## Overview

Durable deletion receipts.

### Available Operations

* [get](#get) - Read an erasure receipt

## get

Read retained erasure progress and downstream acknowledgements. Completion does not certify deletion from backups.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getErasureReceipt" method="get" path="/v1/erasures/{erasure_id}" example="receipt" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.erasures.get(erasure_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter          | Type               | Required           | Description        |
| ------------------ | ------------------ | ------------------ | ------------------ |
| `erasure_id`       | *::String*         | :heavy_check_mark: | N/A                |

### Response

**[T.nilable(Models::Operations::GetErasureReceiptResponse)](../../models/operations/geterasurereceiptresponse.md)**

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