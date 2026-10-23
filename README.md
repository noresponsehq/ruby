# NoResponse for Ruby

The NoResponse client for Ruby 3.2 and later. It assesses a signup or gateway event, polls a pending assessment, pages through an account's history, records what you later learned, rotates your API key and verifies webhooks. The client is generated from the NoResponse OpenAPI document; webhook verification and the wait helper are hand-written.

Keep the API key on your server.

## Install

The gem is named `noresponse`. RubyGems publishing is pending, so until it lands install from the GitHub tag. In your `Gemfile`:

```ruby
gem "noresponse", git: "https://github.com/noresponsehq/ruby.git", tag: "v2.1.15"
```

Use the latest tag from https://github.com/noresponsehq/ruby/tags. Once the gem is on RubyGems, the line is `gem "noresponse", "~> 2.0"`.

## Quick start

```ruby
require "noresponse"

Models = NoResponse::Models

client = NoResponse::NoResponseClient.new(api_key: ENV.fetch("NORESPONSE_API_KEY"))

response = client.assessments.create(
  body: Models::Shared::AssessmentRequest.new(
    account_id: "usr_8f2k1",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(email: "jordan.lee@example.com")
  )
)

assessment = response.result
if assessment.status == Models::Shared::Status::PENDING
  # No recommendation yet. Apply your fallback now, then wait or take the webhook.
  assessment = client.assessments.wait(assessment.assessment_id)
end

puts assessment.recommendation # allow, step_up or review
```

`NoResponse::NoResponseClient.new` with no `api_key` or `security_source` reads the key from `NORESPONSE_API_KEY`.

Every method returns an envelope: `result` holds the object and `headers` the response headers (`X-Request-ID`, `Retry-After`, `Idempotent-Replayed`). The `delete` methods answer 204 with no `result`, and their `headers` still hold `X-Request-ID`.

## Configure the client

```ruby
client = NoResponse::NoResponseClient.new(
  api_key: key,                              # default ENV["NORESPONSE_API_KEY"]; or security_source: -> { Models::Shared::Security.new(api_key: key) }
  server_url: "https://api.noresponse.org",  # the default
  timeout_ms: 10_000,                        # per request
  client: Faraday.new { |f| f.proxy = "http://proxy:8080" }, # your own Faraday connection
  retry_config: NoResponse::Utils::RetryConfig.new(strategy: "none")
)
```

Every method also takes `timeout_ms:`, `retries:` and `http_headers:` for one call.

## Assessments

```ruby
created = client.assessments.create(
  body: Models::Shared::AssessmentRequest.new(
    account_id: "usr_8f2k1",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(email: "jordan.lee@example.com"),
    response_mode: Models::Shared::ResponseMode::DETAILED # detailed needs the detailed scope
  ),
  idempotency_key: "signup-usr_8f2k1-0001"
)

latest = client.assessments.get(assessment_id: created.result.assessment_id)
settled = client.assessments.wait(created.result.assessment_id, timeout: 30)
```

`wait` polls `get` until the status is `COMPLETE`, sleeping the server's `Retry-After` (at least one second) between polls. When the timeout (default 30 s) passes it returns the latest answer if that is `PARTIAL`, with its status still `PARTIAL`, and raises `NoResponse::WaitTimeoutError`, which carries the last pending assessment as `last`, if the assessment is still `PENDING`.

### Query an account's history

```ruby
cursor = nil
loop do
  page = client.assessments.query(
    request: Models::Shared::AssessmentQuery.new(account_id: "usr_8f2k1", limit: 20, cursor: cursor)
  ).result
  page.items.each { |item| puts item.assessment_id } # newest first
  cursor = page.next_cursor
  break if cursor.nil?
end
```

### Record an outcome

```ruby
client.assessments.record_outcome(
  assessment_id: created.result.assessment_id,
  body: Models::Shared::AssessmentOutcomeRequest.new(
    outcome: Models::Shared::Outcome::CHARGEBACK,
    external_ref: "case-42"
  )
)
```

### Idempotency

`create` and `record_outcome` send a fresh UUID as the `Idempotency-Key` when you pass none, and the same key on every retry of that call, so a retried request is recorded once. Pass your own key to make a retry from your side replay the same assessment: the API answers the latest version with `Idempotent-Replayed: true`. The same key with a different body answers 409 (`ConflictError`).

`client.assessments.delete(assessment_id:)` deletes one assessment (`history` scope); the answer's `account.current_assessment_id` names the assessment the account's risk now comes from, nil when none is left, and a repeat answers 404.

## Keys

```ruby
rotation = client.keys.rotate(request: Models::Shared::KeyRotationRequest.new(overlap_seconds: 3600))
# rotation.result.key is the new key, shown once. Rotate with the new key next time.
```

## Errors

Every API error is a `NoResponse::Models::Errors::NoResponseError`. The problem-document errors carry `status`, `type`, `title`, `detail`, `code`, `request_id` and `invalid_params`.

| Class | When |
|---|---|
| `BadRequestError` | 400: the body or a header is malformed; see `invalid_params` |
| `AuthenticationError` | 401: missing, malformed, revoked or expired key |
| `PermissionDeniedError` | 403: the key lacks the operation's scope |
| `NotFoundError` | 404: unknown, expired or foreign assessment |
| `ConflictError` | 409: idempotency key reused with a different body, or a key already rotating |
| `RateLimitError` | 429, after the retries (which honour `Retry-After`) ran out |
| `APIStatusError` | any other 4xx or 5xx, including 503; has `status_code`, `body` and `raw_response` |

```ruby
Errors = NoResponse::Models::Errors

begin
  client.assessments.create(body: request)
rescue Errors::RateLimitError => e
  apply_fallback(e.request_id) # retries already honoured Retry-After and ran out
rescue Errors::NoResponseError => e
  warn "#{e.class}: #{e.message}"
rescue Faraday::Error
  # DNS, TLS or connection failure: apply your fallback.
end
```

## Retries

Connection errors, 408, 429 and every 5xx are retried with exponential backoff (500 ms to 8 s, 30 s in all). 409 and other 4xx are not retried. Override for the client with `retry_config:` or for one call with `retries:`:

```ruby
client.assessments.create(body: request, retries: NoResponse::Utils::RetryConfig.new(strategy: "none"))
```

## Issued keys

When your signup gate issues an API key to the new account, send only its hash, as `issued_credential.sha256`; the key itself never leaves your backend.

```ruby
sha256 = NoResponse::IssuedCredential.sha256(issued_key)
```

## Webhooks

Register an endpoint (the key needs the `webhooks` scope), store its signing secret, then send it a test event.

```ruby
created = client.webhook_endpoints.create(
  request: Models::Shared::WebhookEndpointRequest.new(url: "https://app.example.com/webhooks/noresponse")
).result
secret_store.write(created.signing_secret.key_id, created.signing_secret.secret) # shown once

endpoint_id = created.endpoint.endpoint_id
check = client.webhook_endpoints.send_test_event(
  endpoint_id: endpoint_id,
  body: Models::Shared::WebhookTestRequest.new(event: Models::Shared::WebhookTestRequestEvent::ENDPOINT_VERIFICATION)
).result # check.verified
client.webhook_endpoints.send_test_event(
  endpoint_id: endpoint_id,
  body: Models::Shared::WebhookTestRequest.new(event: Models::Shared::WebhookTestRequestEvent::ASSESSMENT_UPDATED)
) # your receiver sees event.test? == true
```

`list`, `rotate_signing_key(endpoint_id:, body:)` (the old key verifies for 7 more days) and `delete(endpoint_id:)` manage it afterwards.

Verify the exact bytes you received, then act on the typed event. `secrets` maps each `whk_` key id we give you to its secret; hold both during a rotation.

```ruby
# Rack or Sinatra: post "/webhooks/noresponse"
payload = request.body.read
begin
  event = NoResponse::Webhooks.construct_event(payload, request.env, { key_id => secret })
rescue NoResponse::Webhooks::VerificationError => e
  halt 400, e.code.to_s
end

case event.type
when "endpoint.verification"
  content_type :json
  NoResponse::Webhooks.verification_response(event).to_json
else
  if event.test?
    # send_test_event's fixed example assessment: apply nothing
  elsif event.type == "account.deleted"
    # you erased event.data.account_id with accounts.delete
  elsif event.expired?
    # forget the assessment: GET now answers 404
  else
    # event.data is the full assessment; keep the highest assessment_version
  end
  status 204
end
```

`construct_event(payload, headers, secrets, tolerance_seconds: 300)` takes the raw body and a hash of headers in any letter case. It refuses a missing or repeated header, a stale delivery, an unknown key id or a bad signature, and `VerificationError#code` says which. Deliveries are at least once: deduplicate on `event.id`. `event.test?` is true only on an `assessment.updated` event sent by `send_test_event`; its `data` is a fixed example assessment, so acknowledge it and apply nothing.

### Late results

An assessment can be revised after you allowed the signup. `NoResponse::LateResults.handle` verifies the `assessment.updated` delivery with `construct_event`, applies your policy and revokes the user's sessions or bans the user through your auth provider (`LateResults.clerk`, `.workos` or `.auth0`). The default policy revokes sessions on `review` only; WorkOS has no block, so its ban deletes the user permanently.

```ruby
provider = NoResponse::LateResults.clerk(secret_key: ENV.fetch('CLERK_SECRET_KEY'))
result = NoResponse::LateResults.handle(payload, request.env, { key_id => secret }, provider,
                                        policy: { review: 'ban' })
```

A refused provider call raises `LateResults::ProviderActionError`; answer 5xx so we retry.

If your app has its own login, `NoResponse::LateResults.log_only` logs what it would revoke or ban (to standard error, or pass `log:` a callable) and calls nothing. Use it to try the handler, then pass your own provider: any object with `name`, `revoke_sessions(user_id)` and `ban(user_id)`.

## Changes since 2.0.0

Names that changed:

| 2.0.0 | Now |
|---|---|
| `NoResponse::NoResponse` | `NoResponse::NoResponseClient` |
| no shared parent for errors | `NoResponse::Models::Errors::NoResponseError`, the parent of every error class and of `APIStatusError` |
| `NoResponse::Wait.wait(client, id)` | `client.assessments.wait(id)`; `NoResponse::Wait.wait(client, id)` still works |
| `create(body:, idempotency_key:)` with the key required | `idempotency_key:` is optional |
| `record_outcome(body:, assessment_id:, idempotency_key:)` with the key required | `idempotency_key:` is optional |

Issues: https://github.com/noresponsehq/ruby/issues. Quote `request_id` when you write to us.
