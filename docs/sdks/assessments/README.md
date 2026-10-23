# Assessments

## Overview

Assessments of account creation, login and purchase.

### Available Operations

* [create](#create) - Assess identifiers for a signup or gateway decision.
* [get](#get) - Poll the authoritative assessment of one assessment.
* [delete](#delete) - Delete one assessment.
* [record_outcome](#record_outcome) - Report what was later learned about an assessed account.
* [query](#query) - Page through one account's unexpired assessments.

## create

Assesses one account creation, login or purchase (flow) and answers with the account's one current risk: account.risk.decision is the decision for this flow (allow, step_up, review or block, where block means your block threshold was reached), and detail holds this assessment's own facts. depth sets how long the answer waits for sources: quick waits only for the fast ones (500 ms), full for the whole budget (3000 ms at most); it defaults to full for account_creation and purchase and quick for login. 200 carries complete or partial, 202 carries pending with Location and Retry-After. While the account's first assessment is pending, account is absent: apply your own fallback for that, 429, 503 or a timeout. NoResponse blocks nothing itself; you decide. Requires the assess scope. Idempotency-Key is optional in the SDK and is bound to the body for 24 hours: the same key with the same body replays the latest assessment with Idempotent-Replayed: true and starts no new work; the same key with a different body answers 409 idempotency_key_reused. response_mode defaults to standard; detailed needs the detailed scope.

### Example Usage: complete

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="complete" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new.user',
    phone: '+61412345678',
    name: 'Alex Example',
    ip: '203.0.113.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'AU'
  ),
  request_id: 'req-2026-10-14-0001',
  client_context: Models::Shared::AssessmentRequestClientContext.new(
    timezone: 'Australia/Sydney',
    locale: 'en-AU',
    app_version: '4.12.0',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36',
    device_id: 'dev_5c1e8a',
    session_id: 'sess_9b2d41',
    client_observed_at: '2026-10-14T08:59:58.000Z'
  ),
  auth_context: Models::Shared::AuthContext.new(
    provider: 'clerk',
    issuer: 'https://example-app.clerk.accounts.dev',
    audience: 'https://app.example.com',
    audiences: [
      'https://app.example.com',
    ],
    subject: 'user_2EXAMPLE',
    session_id: 'sess_2EXAMPLE',
    organization_id: 'org_2EXAMPLE',
    tenant_id: 'tenant_2EXAMPLE',
    token_id: '2EXAMPLEJTI',
    issued_at: '2026-10-14T08:59:40.000Z',
    expires_at: '2026-10-14T09:00:40.000Z',
    session_created_at: '2026-10-14T08:57:00.000Z',
    auth_time: '2026-10-14T08:55:00.000Z',
    account_created_at: '2026-10-14T08:56:00.000Z',
    verified: true,
    mfa: Models::Shared::AuthContextMfa.new(
      methods: [
        'totp',
      ]
    ),
    roles: [
      'admin',
    ],
    scopes: [
      'org:sys_profile:manage',
    ]
  ),
  issued_credential: Models::Shared::AssessmentRequestIssuedCredential.new(
    sha256: '2bdbf5c72f2a36df0ef40fb92203612274d4546f56dba946070a6a79c2401a1b'
  )
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: detailed

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="detailed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new.user',
    phone: '+61412345678',
    name: 'Alex Example',
    ip: '203.0.113.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'AU'
  ),
  request_id: 'req-2026-10-14-0001',
  client_context: Models::Shared::AssessmentRequestClientContext.new(
    timezone: 'Australia/Sydney',
    locale: 'en-AU',
    app_version: '4.12.0',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36',
    device_id: 'dev_5c1e8a',
    session_id: 'sess_9b2d41',
    client_observed_at: '2026-10-14T08:59:58.000Z'
  ),
  auth_context: Models::Shared::AuthContext.new(
    provider: 'clerk',
    issuer: 'https://example-app.clerk.accounts.dev',
    audience: 'https://app.example.com',
    audiences: [
      'https://app.example.com',
    ],
    subject: 'user_2EXAMPLE',
    session_id: 'sess_2EXAMPLE',
    organization_id: 'org_2EXAMPLE',
    tenant_id: 'tenant_2EXAMPLE',
    token_id: '2EXAMPLEJTI',
    issued_at: '2026-10-14T08:59:40.000Z',
    expires_at: '2026-10-14T09:00:40.000Z',
    session_created_at: '2026-10-14T08:57:00.000Z',
    auth_time: '2026-10-14T08:55:00.000Z',
    account_created_at: '2026-10-14T08:56:00.000Z',
    verified: true,
    mfa: Models::Shared::AuthContextMfa.new(
      methods: [
        'totp',
      ]
    ),
    roles: [
      'admin',
    ],
    scopes: [
      'org:sys_profile:manage',
    ]
  ),
  issued_credential: Models::Shared::AssessmentRequestIssuedCredential.new(
    sha256: '2bdbf5c72f2a36df0ef40fb92203612274d4546f56dba946070a6a79c2401a1b'
  )
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: full

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="full" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new_user_42',
    phone: '+447700900123'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'GB'
  ),
  request_id: 'req-2026-10-14-0001',
  deadline_ms: 300
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: login

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="login" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new.user',
    phone: '+61412345678',
    name: 'Alex Example',
    ip: '203.0.113.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'AU'
  ),
  request_id: 'req-2026-10-14-0001',
  client_context: Models::Shared::AssessmentRequestClientContext.new(
    timezone: 'Australia/Sydney',
    locale: 'en-AU',
    app_version: '4.12.0',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36',
    device_id: 'dev_5c1e8a',
    session_id: 'sess_9b2d41',
    client_observed_at: '2026-10-14T08:59:58.000Z'
  ),
  auth_context: Models::Shared::AuthContext.new(
    provider: 'clerk',
    issuer: 'https://example-app.clerk.accounts.dev',
    audience: 'https://app.example.com',
    audiences: [
      'https://app.example.com',
    ],
    subject: 'user_2EXAMPLE',
    session_id: 'sess_2EXAMPLE',
    organization_id: 'org_2EXAMPLE',
    tenant_id: 'tenant_2EXAMPLE',
    token_id: '2EXAMPLEJTI',
    issued_at: '2026-10-14T08:59:40.000Z',
    expires_at: '2026-10-14T09:00:40.000Z',
    session_created_at: '2026-10-14T08:57:00.000Z',
    auth_time: '2026-10-14T08:55:00.000Z',
    account_created_at: '2026-10-14T08:56:00.000Z',
    verified: true,
    mfa: Models::Shared::AuthContextMfa.new(
      methods: [
        'totp',
      ]
    ),
    roles: [
      'admin',
    ],
    scopes: [
      'org:sys_profile:manage',
    ]
  ),
  issued_credential: Models::Shared::AssessmentRequestIssuedCredential.new(
    sha256: '2bdbf5c72f2a36df0ef40fb92203612274d4546f56dba946070a6a79c2401a1b'
  )
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: minimal

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="minimal" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com'
  )
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: name_and_ip

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="name_and_ip" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_8412',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'jane.doe@example.com',
    username: 'janedoe',
    phone: '+14155550123',
    name: 'Jane A. Doe',
    ip: '73.162.18.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'US'
  ),
  request_id: 'req_01',
  deadline_ms: 500,
  response_mode: Models::Shared::ResponseMode::STANDARD
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: partial

<!-- UsageSnippet language="ruby" operationID="createAssessment" method="post" path="/v1/assessments" example="partial" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.create(body: Models::Shared::AssessmentRequest.new(
  account_id: 'acct_7f3a9c',
  flow: Models::Shared::Flow::ACCOUNT_CREATION,
  identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
    email: 'new.user@example.com',
    username: 'new.user',
    phone: '+61412345678',
    name: 'Alex Example',
    ip: '203.0.113.45'
  ),
  policy_context: Models::Shared::AssessmentRequestPolicyContext.new(
    region: 'AU'
  ),
  request_id: 'req-2026-10-14-0001',
  client_context: Models::Shared::AssessmentRequestClientContext.new(
    timezone: 'Australia/Sydney',
    locale: 'en-AU',
    app_version: '4.12.0',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36',
    device_id: 'dev_5c1e8a',
    session_id: 'sess_9b2d41',
    client_observed_at: '2026-10-14T08:59:58.000Z'
  ),
  auth_context: Models::Shared::AuthContext.new(
    provider: 'clerk',
    issuer: 'https://example-app.clerk.accounts.dev',
    audience: 'https://app.example.com',
    audiences: [
      'https://app.example.com',
    ],
    subject: 'user_2EXAMPLE',
    session_id: 'sess_2EXAMPLE',
    organization_id: 'org_2EXAMPLE',
    tenant_id: 'tenant_2EXAMPLE',
    token_id: '2EXAMPLEJTI',
    issued_at: '2026-10-14T08:59:40.000Z',
    expires_at: '2026-10-14T09:00:40.000Z',
    session_created_at: '2026-10-14T08:57:00.000Z',
    auth_time: '2026-10-14T08:55:00.000Z',
    account_created_at: '2026-10-14T08:56:00.000Z',
    verified: true,
    mfa: Models::Shared::AuthContextMfa.new(
      methods: [
        'totp',
      ]
    ),
    roles: [
      'admin',
    ],
    scopes: [
      'org:sys_profile:manage',
    ]
  ),
  issued_credential: Models::Shared::AssessmentRequestIssuedCredential.new(
    sha256: '2bdbf5c72f2a36df0ef40fb92203612274d4546f56dba946070a6a79c2401a1b'
  )
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::AssessmentRequest](../../models/shared/assessmentrequest.md)                                                                                                                                                                                            | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

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

Returns the highest assessment_version, with the account's current risk. Requires the assess or history scope. While status is pending, or partial with a source still running, the response carries Retry-After; poll no faster than it says. Another workspace's assessment, an unknown or expired assessment and a malformed assessment_id all answer 404 not_found. response_mode=detailed needs the detailed scope.

### Example Usage: complete

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="complete" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: detailed

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="detailed" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: login

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="login" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: partial

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="partial" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: pending

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="pending" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: pending_known_account

<!-- UsageSnippet language="ruby" operationID="getAssessment" method="get" path="/v1/assessments/{assessment_id}" example="pending_known_account" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                         | Type                                                                                                              | Required                                                                                                          | Description                                                                                                       | Example                                                                                                           |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                   | *::String*                                                                                                        | :heavy_check_mark:                                                                                                | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400. | asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                    |
| `response_mode`                                                                                                   | [T.nilable(Models::Shared::ResponseMode)](../../models/shared/responsemode.md)                                    | :heavy_minus_sign:                                                                                                | Optional standard or separately authorised detailed customer view; raw is rejected.                               |                                                                                                                   |

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

## delete

Deletes one assessment in the environment of your key, with its versions, evidence and outcomes and the identity-graph marks its outcomes set, and scores its account again from what remains. Afterwards the assessment answers 404 and leaves the account's history. The answer names the account and the assessment its current risk now comes from; current_assessment_id is absent when the account has no assessment with a decision left. Requires the history scope. An unknown, expired or already deleted assessment answers 404, so a repeat answers 404; to erase a whole account idempotently, use accounts.delete.

### Example Usage: last

<!-- UsageSnippet language="ruby" operationID="deleteAssessment" method="delete" path="/v1/assessments/{assessment_id}" example="last" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.delete(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```
### Example Usage: next

<!-- UsageSnippet language="ruby" operationID="deleteAssessment" method="delete" path="/v1/assessments/{assessment_id}" example="next" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.delete(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                         | Type                                                                                                              | Required                                                                                                          | Description                                                                                                       | Example                                                                                                           |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                   | *::String*                                                                                                        | :heavy_check_mark:                                                                                                | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400. | asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                    |

### Response

**[T.nilable(Models::Operations::DeleteAssessmentResponse)](../../models/operations/deleteassessmentresponse.md)**

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

Records what you later learned about an assessed account: confirmed_abuse, account_takeover and chargeback report abuse; false_positive and legitimate withdraw your earlier report; unknown is recorded only. Outcomes are append-only and the latest one wins. Requires the assess scope. Idempotency-Key is optional in the SDK and handled as on POST /v1/assessments: a retry with the same key and body answers the same record with Idempotent-Replayed: true; a different body answers 409. An unknown, expired or foreign assessment answers 404 not_found.

### Example Usage: abuse

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="abuse" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.record_outcome(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::CONFIRMED_ABUSE,
  observed_at: '2026-10-20T05:00:00Z',
  external_ref: 'case-123',
  notes: 'Card testing from this account; closed by trust and safety.'
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: recorded

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="recorded" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.record_outcome(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::LEGITIMATE,
  observed_at: '2026-10-14T09:04:30.000Z',
  external_ref: 'case-48213',
  notes: 'Chargeback filed two days after account creation.'
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```
### Example Usage: withdrawn

<!-- UsageSnippet language="ruby" operationID="recordAssessmentOutcome" method="post" path="/v1/assessments/{assessment_id}/outcomes" example="withdrawn" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.record_outcome(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::AssessmentOutcomeRequest.new(
  outcome: Models::Shared::Outcome::FALSE_POSITIVE
), idempotency_key: 'account-acct_7f3a9c')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `assessment_id`                                                                                                                                                                                                                                                          | *::String*                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                       | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.                                                                                                                                                        | asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                           |
| `body`                                                                                                                                                                                                                                                                   | [Models::Shared::AssessmentOutcomeRequest](../../models/shared/assessmentoutcomerequest.md)                                                                                                                                                                              | :heavy_check_mark:                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                       | Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call. | account-acct_7f3a9c                                                                                                                                                                                                                                                      |

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

History is a POST with account_id in the body so an account identifier stays out of URLs and access logs. Requires the history scope. Read-only and safe to retry. Newest first, each at its latest assessment_version. An account with no assessments answers 200 with empty items. The cursor is opaque and bound to your workspace and the account; a tampered or expired cursor answers 400 invalid_cursor. response_mode=detailed needs the detailed scope.

### Example Usage: firstPage

<!-- UsageSnippet language="ruby" operationID="queryAccountAssessments" method="post" path="/v1/assessments/query" example="firstPage" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
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
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::AssessmentQuery.new(
  account_id: 'acct_7f3a9c',
  cursor: 'eyJvIjoyMH0'
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