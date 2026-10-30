# Assessments

## Overview

Assessments of account creation, login and purchase.

### Available Operations

* [create](#create) - Assess identifiers for a signup or gateway decision.
* [get](#get) - Poll the authoritative assessment of one assessment.
* [delete](#delete) - Delete one assessment.
* [record_outcome](#record_outcome) - Report what was later learned about an assessed account.
* [query](#query) - Page through one account's unexpired assessments.
* [aggregate](#aggregate) - Count assessments by time, decision and reason
* [search](#search) - Search assessments across this environment
* [retrieve_version](#retrieve_version) - Retrieve an exact assessment revision
* [bind_account](#bind_account) - Bind a provisional signup account

## create

Assesses one account creation, login or purchase (flow) and answers with the account's one current risk: account.risk.decision is the decision for this flow (allow, step_up, review or block, where block means your block threshold was reached), and detail holds this assessment's own facts. depth sets how long the answer waits for sources: quick waits only for the fast ones (500 ms), full for the whole budget (3000 ms at most); it defaults to full for account_creation and purchase and quick for login. 200 carries complete or partial, 202 carries pending with Location and Retry-After. While the account's first assessment is pending, account is absent: apply your own fallback for that, 429, 503 or a timeout. NoResponse blocks nothing itself; you decide. Requires the assess scope. Idempotency-Key is optional in the SDK and is bound to the body for 24 hours: the same key with the same body replays the latest assessment with Idempotent-Replayed: true and starts no new work; the same key with a different body answers 409 idempotency_key_reused. response_mode defaults to standard; detailed needs the detailed scope. The answer leaves out detail.identifiers: you hold what you sent, and a key with the history scope gets them back with GET.

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
    verified: false,
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
    verified: false,
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
    verified: false,
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
    verified: false,
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

Returns the highest assessment_version, with the account's current risk. Requires the assess or history scope. While status is pending, or partial with a source still running, the response carries Retry-After; poll no faster than it says. Another workspace's assessment, an unknown or expired assessment and a malformed assessment_id all answer 404 not_found. response_mode=detailed needs the detailed scope. A key with the history scope also gets detail.identifiers, the identifiers the assessment was sent, exactly as received.

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
  outcome: Models::Shared::Outcome::UNKNOWN,
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

History is a POST with account_id in the body so an account identifier stays out of URLs and access logs. Requires the history scope. Read-only and safe to retry. Newest first, each at its latest assessment_version. An account with no assessments answers 200 with empty items. The cursor is opaque and bound to your workspace and the account; a tampered or expired cursor answers 400 invalid_cursor. response_mode=detailed needs the detailed scope. Each item's identifiers holds the identifiers its assessment was sent, exactly as received.

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
  cursor: nil
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

## aggregate

Count this environment's assessments created in [from,to) by UTC hour, or by day or week from local midnight in time_zone (an IANA name, UTC by default; at most 92 days in a zone other than UTC), grouped by up to two of decision, flow, recommendation, band, reason, lane, country, asn and list_match. Each assessment counts once, by its first answer; late results do not count it again and appear in late_flips. Optional metrics add a score histogram per flow, that histogram by the latest reported outcome, and late account decision changes. from and to start a bucket and cover at most 366 days (31 for hour buckets) inside the retention period. The filters are search's and describe the first answer: send them to search with revision first to list a cell's assessments. Counts hold no identifier, stay when an assessment or account is deleted, and report reasons by code and impact band. No Idempotency-Key.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="aggregateAssessments" method="post" path="/v1/assessments/aggregate" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::AssessmentAggregateRequest.new(
  from: '2026-10-19T00:00:00Z',
  to: '2026-10-26T00:00:00Z',
  bucket: Models::Shared::Bucket::WEEK,
  country: 'GB'
)
res = s.assessments.aggregate(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                       | Type                                                                                            | Required                                                                                        | Description                                                                                     |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `request`                                                                                       | [Models::Shared::AssessmentAggregateRequest](../../models/shared/assessmentaggregaterequest.md) | :heavy_check_mark:                                                                              | The request object to use for the request.                                                      |

### Response

**[T.nilable(Models::Operations::AggregateAssessmentsResponse)](../../models/operations/aggregateassessmentsresponse.md)**

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

## search

Search retained assessments created in [from,to), at most 366 days. identifier directly matches that assessment's submitted email, phone or customer-namespace username using exact, canonical or explicitly selected email mailbox matching. matched_identifier explains the original value and match basis. Legacy email keeps its account-wide mailbox semantics and cannot be combined with identifier. Other filters combine using AND and describe assessment decisions, separate from current account decisions. Each item carries the original submitted identifiers and its first_decision when available. Newest-created order has an assessment-ID tie break. Results are live across pages; each page's total and items use one database snapshot. Totals are exact below 10000 and capped at 10000. Requires history or investigate authority and identifier-read permission for identifier, identifier_expression or email filters; detailed mode also requires detailed permission. No Idempotency-Key. identifier_expression combines submitted terms with bounded AND/OR, at most 8 raw terms and 3 group levels. Each node selects exactly one of term, and, or. Groups have 2 to 8 operands. Duplicate normalized terms are idempotent and still count toward the limit. identifier_expression, identifier and email are mutually exclusive. Expression results use matched_identifiers with original submitted witnesses and zero-based depth-first term_index. All satisfied unique terms are returned in first-occurrence order. Cursors bind scope, ordered structure, original values, matching modes and all other filters; changing only page limit is allowed. Expression scope must be assessment: each returned assessment itself satisfies the complete expression. Scope account is rejected with 400 invalid_request; use account search for historical combinations.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="searchAssessments" method="post" path="/v1/assessments/search" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)

req = Models::Shared::AssessmentSearchRequest.new(
  from: '2026-10-01T00:00:00Z',
  to: '2026-10-02T00:00:00Z',
  identifier_expression: Models::Shared::IdentifierExpression.new(
    scope: Models::Shared::ScopeEnum::ASSESSMENT,
    expression: Models::Shared::IdentifierExpressionNode.new(
      and_: [
        Models::Shared::IdentifierExpressionNodeLevelTwo.new(
          term: Models::Shared::IdentifierSearch.new(
            kind: Models::Shared::IdentifierSearchKind::PHONE,
            value: '+14155552671',
            match: Models::Shared::Match::CANONICAL
          )
        ),
        Models::Shared::IdentifierExpressionNodeLevelTwo.new(
          or_: [
            Models::Shared::IdentifierExpressionNodeLevelOne.new(
              term: Models::Shared::IdentifierSearch.new(
                kind: Models::Shared::IdentifierSearchKind::EMAIL,
                value: 'case@example.com',
                match: Models::Shared::Match::EXACT
              )
            ),
            Models::Shared::IdentifierExpressionNodeLevelOne.new(
              term: Models::Shared::IdentifierSearch.new(
                kind: Models::Shared::IdentifierSearchKind::EMAIL,
                value: 'other@example.com',
                match: Models::Shared::Match::EXACT
              )
            ),
          ]
        ),
      ]
    )
  )
)
res = s.assessments.search(request: req)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                 | Type                                                                                      | Required                                                                                  | Description                                                                               |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `request`                                                                                 | [Models::Shared::AssessmentSearchRequest](../../models/shared/assessmentsearchrequest.md) | :heavy_check_mark:                                                                        | The request object to use for the request.                                                |

### Response

**[T.nilable(Models::Operations::SearchAssessmentsResponse)](../../models/operations/searchassessmentsresponse.md)**

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

## retrieve_version

Retrieve a retained assessment version with its original decision, policy, flow and depth. This response excludes the current account decision. Current retention and response-mode permissions still apply. detail.identifiers holds the identifiers the assessment was sent, exactly as received.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getAssessmentVersion" method="get" path="/v1/assessments/{assessment_id}/versions/{version}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.retrieve_version(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', version: 849_915)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                         | Type                                                                                                              | Required                                                                                                          | Description                                                                                                       | Example                                                                                                           |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                   | *::String*                                                                                                        | :heavy_check_mark:                                                                                                | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400. | asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                    |
| `version`                                                                                                         | *::Integer*                                                                                                       | :heavy_check_mark:                                                                                                | The stored assessment_version, in canonical decimal form. An unavailable or malformed version answers 404.        |                                                                                                                   |
| `response_mode`                                                                                                   | [T.nilable(Models::Shared::ResponseMode)](../../models/shared/responsemode.md)                                    | :heavy_minus_sign:                                                                                                | Optional standard or separately authorised detailed customer view; raw is rejected.                               |                                                                                                                   |

### Response

**[T.nilable(Models::Operations::GetAssessmentVersionResponse)](../../models/operations/getassessmentversionresponse.md)**

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

## bind_account

One-time association to an opaque stable customer account. The assessment is its natural idempotency key. Repeating the same binding returns its first receipt; a conflicting target is refused. No arbitrary account merging.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="bindProvisionalAccount" method="post" path="/v1/assessments/{assessment_id}/bind" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.assessments.bind_account(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::AccountBindingRequest.new(
  account_id: 'acct_7f3a9c'
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                         | Type                                                                                                              | Required                                                                                                          | Description                                                                                                       | Example                                                                                                           |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `assessment_id`                                                                                                   | *::String*                                                                                                        | :heavy_check_mark:                                                                                                | Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400. | asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                    |
| `body`                                                                                                            | [Models::Shared::AccountBindingRequest](../../models/shared/accountbindingrequest.md)                             | :heavy_check_mark:                                                                                                | N/A                                                                                                               |                                                                                                                   |

### Response

**[T.nilable(Models::Operations::BindProvisionalAccountResponse)](../../models/operations/bindprovisionalaccountresponse.md)**

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