# Assessments

## Overview

Signup and gateway assessments.

### Available Operations

* [create](#create) - Assess identifiers for a signup or gateway decision.
* [get](#get) - Poll the authoritative assessment of one assessment.
* [record_outcome](#record_outcome) - Report what was later learned about an assessed account.
* [query](#query) - Page through one account's unexpired assessments.

## create

Returns within the deadline (500 ms at most) with a complete, partial or pending assessment: 200 carries complete or partial, 202 carries pending with Location and Retry-After. A pending answer has no recommendation; apply your own fallback for pending, 429, 503 or a timeout. Requires the assess scope. Idempotency-Key is required and is bound to the body for 24 hours: the same key with the same body replays the latest assessment with Idempotent-Replayed: true and starts no new work; the same key with a different body answers 409 idempotency_key_reused. response_mode defaults to standard; detailed needs the detailed scope.

### Example Usage: complete

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="complete" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: '<id>',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new
))

unless res.nil?
  # handle response
end

```
### Example Usage: detailed

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="detailed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: '<id>',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new
))

unless res.nil?
  # handle response
end

```
### Example Usage: full

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="full" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new_user_42',
    phone: '+447700900123'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    flow: Models::Shared::Flow::SIGNUP,
    region: 'GB'
  ),
  request_id: 'req-2026-10-14-0001',
  deadline_ms: 300
))

unless res.nil?
  # handle response
end

```
### Example Usage: minimal

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="minimal" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com'
  )
))

unless res.nil?
  # handle response
end

```
### Example Usage: name_and_ip

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="name_and_ip" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_8412',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'jane.doe@example.com',
    username: 'janedoe',
    phone: '+14155550123',
    name: 'Jane A. Doe',
    ip: '73.162.18.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    flow: Models::Shared::Flow::SIGNUP,
    region: 'US'
  ),
  request_id: 'req_01',
  deadline_ms: 500,
  response_mode: Models::Shared::ResponseMode::STANDARD
))

unless res.nil?
  # handle response
end

```
### Example Usage: partial

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="partial" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: '<id>',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new
))

unless res.nil?
  # handle response
end

```
### Example Usage: standard

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="standard" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.create(idempotency_key: '<value>', body: Models::Shared::AssessmentRequest.new(
  account_id: '<id>',
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                      | Type                                                                                                                                                           | Required                                                                                                                                                       | Description                                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `idempotency_key`                                                                                                                                              | *::String*                                                                                                                                                     | :heavy_check_mark:                                                                                                                                             | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the tenant principal and bound to the canonical body for 24 hours. |
| `body`                                                                                                                                                         | [Models::Shared::AssessmentRequest](../../models/shared/assessmentrequest.md)                                                                                  | :heavy_check_mark:                                                                                                                                             | N/A                                                                                                                                                            |

### Response

**[T.nilable(Models::Operations::CreateAssessmentResponse)](../../models/operations/createassessmentresponse.md)**

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

Returns the highest assessment_version. Requires the assess or history scope. While status is pending, or partial with a source still running, the response carries Retry-After; poll no faster than it says. Another tenant's assessment, an unknown or expired assessment and a malformed assessment_id all answer 404 not_found. response_mode=detailed needs the detailed scope.

### Example Usage: complete

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="complete" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.get(assessment_id: '<id>')

unless res.nil?
  # handle response
end

```
### Example Usage: detailed

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="detailed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.get(assessment_id: '<id>')

unless res.nil?
  # handle response
end

```
### Example Usage: partial

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="partial" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.get(assessment_id: '<id>')

unless res.nil?
  # handle response
end

```
### Example Usage: pending

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="pending" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.get(assessment_id: '<id>')

unless res.nil?
  # handle response
end

```
### Example Usage: standard

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="standard" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.get(assessment_id: '<id>')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                         | Type                                                                                                              | Required                                                                                                          | Description                                                                                                       |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                   | *::String*                                                                                                        | :heavy_check_mark:                                                                                                | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400. |
| `response_mode`                                                                                                   | [T.nilable(Models::Shared::ResponseMode)](../../models/shared/responsemode.md)                                    | :heavy_minus_sign:                                                                                                | Optional standard or separately authorised detailed customer view; raw is rejected.                               |

### Response

**[T.nilable(Models::Operations::GetAssessmentResponse)](../../models/operations/getassessmentresponse.md)**

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

## record_outcome

Records what you later learned about an assessed account: confirmed_abuse, account_takeover and chargeback report abuse; false_positive and legitimate withdraw your earlier report; unknown is recorded only. Outcomes are append-only and the latest one wins. Requires the assess scope. Idempotency-Key is required and handled as on POST /v1/assessments: a retry with the same key and body answers the same record with Idempotent-Replayed: true; a different body answers 409. An unknown, expired or foreign assessment answers 404 not_found.

### Example Usage: abuse

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="abuse" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.record_outcome(assessment_id: '<id>', idempotency_key: '<value>', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::CONFIRMED_ABUSE,
  observed_at: '2026-10-20T05:00:00Z',
  external_ref: 'case-123',
  notes: 'Card testing from this account; closed by trust and safety.'
))

unless res.nil?
  # handle response
end

```
### Example Usage: recorded

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="recorded" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.record_outcome(assessment_id: '<id>', idempotency_key: '<value>', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::LEGITIMATE
))

unless res.nil?
  # handle response
end

```
### Example Usage: withdrawn

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="withdrawn" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)
res = s.assessments.record_outcome(assessment_id: '<id>', idempotency_key: '<value>', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::FALSE_POSITIVE
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                      | Type                                                                                                                                                           | Required                                                                                                                                                       | Description                                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                                                                | *::String*                                                                                                                                                     | :heavy_check_mark:                                                                                                                                             | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.                                              |
| `idempotency_key`                                                                                                                                              | *::String*                                                                                                                                                     | :heavy_check_mark:                                                                                                                                             | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the tenant principal and bound to the canonical body for 24 hours. |
| `body`                                                                                                                                                         | [Models::Shared::AssessmentOutcomeRequest](../../models/shared/assessmentoutcomerequest.md)                                                                    | :heavy_check_mark:                                                                                                                                             | N/A                                                                                                                                                            |

### Response

**[T.nilable(Models::Operations::RecordAssessmentOutcomeResponse)](../../models/operations/recordassessmentoutcomeresponse.md)**

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

## query

History is a POST with account_id in the body so an account identifier stays out of URLs and access logs. Requires the history scope. Read-only and safe to retry. Newest first, each at its latest assessment_version. An account with no assessments answers 200 with empty items. The cursor is opaque and bound to your tenant and the account; a tampered or expired cursor answers 400 invalid_cursor. response_mode=detailed needs the detailed scope.

### Example Usage: firstPage

<!-- UsageSnippet language="ruby" operationID="queryAccountAssessments" method="post" path="/v1/assessments/query" example="firstPage" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)

req = Models::Shared::AssessmentQuery.new(
  account_id: 'acct_7f3a9c'
)
res = s.assessments.query(request: req)

unless res.nil?
  # handle response
end

```
### Example Usage: page

<!-- UsageSnippet language="ruby" operationID="queryAccountAssessments" method="post" path="/v1/assessments/query" example="page" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: '<YOUR_BEARER_TOKEN_HERE>'
)

req = Models::Shared::AssessmentQuery.new(
  account_id: '<id>'
)
res = s.assessments.query(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                 | Type                                                                      | Required                                                                  | Description                                                               |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `request`                                                                 | [Models::Shared::AssessmentQuery](../../models/shared/assessmentquery.md) | :heavy_check_mark:                                                        | The request object to use for the request.                                |

### Response

**[T.nilable(Models::Operations::QueryAccountAssessmentsResponse)](../../models/operations/queryaccountassessmentsresponse.md)**

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