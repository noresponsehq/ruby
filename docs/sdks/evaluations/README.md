# Evaluations

## Overview

Frozen policy evaluation evidence and reviewed publication.

### Available Operations

* [list](#list) - List retained policy evaluation jobs.
* [create](#create) - Freeze an evaluation cohort and queue a bounded job.
* [get](#get) - Read evaluation state and provenance.
* [get_result](#get_result) - Read the bounded completed evaluator report.
* [cancel](#cancel) - Cancel processing and destroy retained evidence and report.
* [publish](#publish) - Publish an explicitly reviewed proposal with exact provenance.

## list

List retained policy evaluation jobs for this environment, newest first. At most five jobs are retained for their 24-hour evidence lifetime. Use next_before as before on the next page.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listPolicyEvaluations" method="get" path="/v1/workspaces/{workspace_id}/evaluations/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.list(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, limit: 20)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `limit`                                                                                                                                                                | *T.nilable(::Integer)*                                                                                                                                                 | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |
| `before`                                                                                                                                                               | *T.nilable(::String)*                                                                                                                                                  | :heavy_minus_sign:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::ListPolicyEvaluationsResponse)](../../models/operations/listpolicyevaluationsresponse.md)**

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

Create a bounded evaluation with an Idempotency-Key, expected policy version, fixed candidates, cohort, seed and cost assumptions. Evidence is frozen before evaluation and recorded by hashes. Limits are 1000 accounts, 50000 request attempts and 64 MiB. Capture completeness is currently unknown, so results are no_change and cannot be published. The evaluation fetches no new source evidence and changes no live policy.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createPolicyEvaluation" method="post" path="/v1/workspaces/{workspace_id}/evaluations/{environment}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.create(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, body: Models::Shared::PolicyEvaluationRequest.new(
  expected_policy_version: 848_473,
  from: '2026-01-01T00:00:00Z',
  to: '2026-01-02T00:00:00Z',
  candidates: [],
  costs: Models::Shared::PolicyEvaluationRequestCosts.new(
    legitimate: Models::Shared::Cost.new(
      allow: 8857.2,
      step_up: 4026.42,
      review: 3262.51,
      block: 8887.65
    ),
    abuse: Models::Shared::Cost.new(
      allow: 9853.36,
      step_up: 4011.13,
      review: 9729.18,
      block: 4702.94
    )
  ),
  limits: Models::Shared::PolicyEvaluationRequestLimits.new(
    review_rate: 1758.36,
    server_error_rate: 2521.05,
    unavailable_result_rate: 7870.49,
    p95_ms: 8530.5
  ),
  label_collection: 'Customer support reviewed the outcome labels for the selected cohort.',
  split_seed: 'reviewed-cohort-seed-01'
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `workspace_id`                                                                                                                                                                                                                                                           | *::String*                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                       | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                                                                                                                       | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                           |
| `environment`                                                                                                                                                                                                                                                            | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                                                                                                                  | :heavy_check_mark:                                                                                                                                                                                                                                                       | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404.                                                                                                   |                                                                                                                                                                                                                                                                          |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::PolicyEvaluationRequest](../../models/shared/policyevaluationrequest.md)                                                                                                                                                                                | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

### Response

**[T.nilable(Models::Operations::CreatePolicyEvaluationResponse)](../../models/operations/createpolicyevaluationresponse.md)**

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

Read a retained evaluation job and its capture and provenance metadata. Cancellation, source erasure, retention reduction and expiry can make a result unavailable.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getPolicyEvaluation" method="get" path="/v1/workspaces/{workspace_id}/evaluations/{environment}/{evaluation_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.get(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, evaluation_id: 'pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `evaluation_id`                                                                                                                                                        | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::GetPolicyEvaluationResponse)](../../models/operations/getpolicyevaluationresponse.md)**

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

## get_result

Read the completed evaluation report, including coverage, uncertainty and candidate results. Unknown capture completeness produces no_change. A completed result is not an automatic policy change.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getPolicyEvaluationResult" method="get" path="/v1/workspaces/{workspace_id}/evaluations/{environment}/{evaluation_id}/result" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.get_result(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, evaluation_id: 'pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `evaluation_id`                                                                                                                                                        | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |

### Response

**[T.nilable(Models::Operations::GetPolicyEvaluationResultResponse)](../../models/operations/getpolicyevaluationresultresponse.md)**

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

Cancel a queued or running evaluation and invalidate its stored evidence. The operation does not change policy. Send an empty JSON object.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="cancelPolicyEvaluation" method="post" path="/v1/workspaces/{workspace_id}/evaluations/{environment}/{evaluation_id}/cancel" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.cancel(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::LIVE, evaluation_id: 'pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::PolicyEvaluationCancelRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                              | Type                                                                                                                                                                   | Required                                                                                                                                                               | Description                                                                                                                                                            | Example                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspace_id`                                                                                                                                                         | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.                                     | tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `environment`                                                                                                                                                          | [Models::Shared::KeyEnvironment](../../models/shared/keyenvironment.md)                                                                                                | :heavy_check_mark:                                                                                                                                                     | The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404. |                                                                                                                                                                        |
| `evaluation_id`                                                                                                                                                        | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::PolicyEvaluationCancelRequest](../../models/shared/policyevaluationcancelrequest.md)                                                                  | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::CancelPolicyEvaluationResponse)](../../models/operations/cancelpolicyevaluationresponse.md)**

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

## publish

Publish an explicitly reviewed candidate with its exact manifest, input and result hashes and unchanged baseline policy version. Requires settings plus policy_publish, or legacy management. Publication creates a fresh policy version and immutable provenance. no_change, expired or invalidated results are refused.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="publishPolicyEvaluation" method="post" path="/v1/workspaces/{workspace_id}/evaluations/{environment}/{evaluation_id}/publish" example="changed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.evaluations.publish(workspace_id: 'tnt_01JA2Z8K6Q4V7W9XBCDEFGHJKM', environment: Models::Shared::KeyEnvironment::TEST, evaluation_id: 'pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::PolicyEvaluationPublishRequest.new(
  expected_policy_version: 818_682,
  manifest_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  input_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  result_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  candidate: Models::Shared::Thresholds.new(
    step_up: 622_475,
    review: 962_198,
    block: 229_789
  ),
  change_reason: 'Reviewed the proposal and its capture coverage.'
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
| `evaluation_id`                                                                                                                                                        | *::String*                                                                                                                                                             | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    | pev_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                         |
| `body`                                                                                                                                                                 | [Models::Shared::PolicyEvaluationPublishRequest](../../models/shared/policyevaluationpublishrequest.md)                                                                | :heavy_check_mark:                                                                                                                                                     | N/A                                                                                                                                                                    |                                                                                                                                                                        |

### Response

**[T.nilable(Models::Operations::PublishPolicyEvaluationResponse)](../../models/operations/publishpolicyevaluationresponse.md)**

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