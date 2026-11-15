# Investigations

## Overview

Person investigation jobs, retained results and contextual decisions.

### Available Operations

* [list](#list) - List investigation history.
* [create](#create) - Start an investigation for a person.
* [get](#get) - Read an investigation and its evidence.
* [review](#review) - Record an investigation decision.
* [cancel](#cancel) - Cancel an investigation

## list

List investigation history. The API key determines the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listInvestigations" method="get" path="/v1/investigations" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.investigations.list(limit: 100)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter              | Type                   | Required               | Description            |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| `person_id`            | *T.nilable(::String)*  | :heavy_minus_sign:     | N/A                    |
| `before`               | *T.nilable(::String)*  | :heavy_minus_sign:     | N/A                    |
| `limit`                | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |

### Response

**[T.nilable(Models::Operations::ListInvestigationsResponse)](../../models/operations/listinvestigationsresponse.md)**

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

Starts an investigation against a retained workspace person, independently of group membership. Idempotency-Key is required: the same key and input return the same retained job in its current state without repeating billable work. Different input with that key answers 409 idempotency_key_reused; a deliberate new investigation uses a new key. The response includes Location and Retry-After. The person's retention expiry limits both execution and retained history. The API key selects the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createInvestigation" method="post" path="/v1/investigations" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.investigations.create(body: Models::Shared::InvestigationRequest.new(
  depth: Models::Shared::ScreeningDepth::STANDARD,
  platforms: [
    'x',
  ],
  person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM'
), idempotency_key: 'investigation-case-1042-first')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Required                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Example                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `body`                                                                                                                                                                                                                                                                                                                                                                                                                                                          | [Models::Shared::InvestigationRequest](../../models/shared/investigationrequest.md)                                                                                                                                                                                                                                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                                                                                                                                                                                                                                                                                                              | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `idempotency_key`                                                                                                                                                                                                                                                                                                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                                                                                                                                                                                                                                                                                                           | :heavy_minus_sign:                                                                                                                                                                                                                                                                                                                                                                                                                                              | Opaque request key, 16 to 128 characters. Repeating the key and request returns the same resource in its current state while it is retained. A different request with the same key answers 409. Use a new key for a deliberate new operation. Keys are scoped to the environment and operation; person searches also scope them to the group and person. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | investigation-case-1042-first                                                                                                                                                                                                                                                                                                                                                                                                                                   |

### Response

**[T.nilable(Models::Operations::CreateInvestigationResponse)](../../models/operations/createinvestigationresponse.md)**

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

Returns this investigation's status, coverage, source records, posts, media and contextual review history. Full evidence is returned by default; explicit evidence.read denial keeps submitted person details, status, coverage and decision summaries and hides collected evidence and free-text notes. The read is durably audited as person.viewed. The API key selects the workspace and environment. Missing, foreign or expired results answer 404.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getInvestigation" method="get" path="/v1/investigations/{investigation_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.investigations.get(investigation_id: 'inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                      | Type                           | Required                       | Description                    | Example                        |
| ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ |
| `investigation_id`             | *::String*                     | :heavy_check_mark:             | N/A                            | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM |

### Response

**[T.nilable(Models::Operations::GetInvestigationResponse)](../../models/operations/getinvestigationresponse.md)**

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

## review

Record an investigation decision. The API key determines the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="reviewInvestigation" method="post" path="/v1/investigations/{investigation_id}/reviews" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.investigations.review(investigation_id: 'inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::PersonReviewRequest.new(
  decision: Models::Shared::PersonDecision::WATCH,
  note: 'Known to the venue team.'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                         | Type                                                                              | Required                                                                          | Description                                                                       | Example                                                                           |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `investigation_id`                                                                | *::String*                                                                        | :heavy_check_mark:                                                                | N/A                                                                               | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                    |
| `body`                                                                            | [Models::Shared::PersonReviewRequest](../../models/shared/personreviewrequest.md) | :heavy_check_mark:                                                                | N/A                                                                               |                                                                                   |

### Response

**[T.nilable(Models::Operations::ReviewInvestigationResponse)](../../models/operations/reviewinvestigationresponse.md)**

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

## cancel

Stops this investigation. A completed or already cancelled investigation keeps its current result. Other investigations for the person keep running.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="cancelInvestigation" method="post" path="/v1/investigations/{investigation_id}/cancel" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.investigations.cancel(investigation_id: 'inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::ScreeningCancelRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                               | Type                                                                                    | Required                                                                                | Description                                                                             | Example                                                                                 |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `investigation_id`                                                                      | *::String*                                                                              | :heavy_check_mark:                                                                      | N/A                                                                                     | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                          |
| `body`                                                                                  | [Models::Shared::ScreeningCancelRequest](../../models/shared/screeningcancelrequest.md) | :heavy_check_mark:                                                                      | N/A                                                                                     |                                                                                         |

### Response

**[T.nilable(Models::Operations::CancelInvestigationResponse)](../../models/operations/cancelinvestigationresponse.md)**

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