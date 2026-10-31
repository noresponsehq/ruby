<a href="https://noresponse.org"><img src="https://raw.githubusercontent.com/noresponsehq/.github/main/profile/sdk-header.png" alt="NoResponse · Identity Intelligence" width="100%"></a>

# NoResponse for Ruby

Assess sign-ups, logins and purchases with the NoResponse Identity Intelligence API.

Ruby 3.2+ · Bundler.

[Documentation](https://docs.noresponse.org/sdks/ruby) · [API reference](https://docs.noresponse.org/api-reference) · [Releases](https://github.com/noresponsehq/ruby/releases)

## Install

The gem is named `noresponse`. RubyGems publishing is pending, so until it lands install from the GitHub tag. In your `Gemfile`:

```ruby
gem "noresponse", git: "https://github.com/noresponsehq/ruby.git", tag: "v10.0.3"
```

Use the latest tag from https://github.com/noresponsehq/ruby/tags. Once the gem is on RubyGems, the line is `gem "noresponse", "~> 3.0"`.

## Quick start

```ruby
require "noresponse"

Models = NoResponse::Models

client = NoResponse::NoResponseClient.new(api_key: ENV.fetch("NORESPONSE_API_KEY"))

response = client.assessments.create(
  body: Models::Shared::AssessmentRequest.new(
    flow: Models::Shared::Flow::ACCOUNT_CREATION,
    account_id: "usr_8f2k1",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(email: "jordan.lee@example.com")
  )
)

assessment = response.result
if assessment.status == Models::Shared::Status::PENDING
  # No decision yet. Apply your fallback now, then wait or take the webhook.
  assessment = client.assessments.wait(assessment.id)
end

puts assessment.account.risk.decision # allow, step_up, review or block
puts assessment.detail.risk.score     # this assessment's own score
```

`NoResponse::NoResponseClient.new` with no `api_key` or `security_source` reads the key from `NORESPONSE_API_KEY`.

Every method returns an envelope: `result` holds the object and `headers` the response headers (`X-Request-ID`, `Retry-After`, `Idempotent-Replayed`). The `delete` methods answer 204 with no `result`, and their `headers` still hold `X-Request-ID`.

## Go further

| Task | Guide |
| --- | --- |
| Configure this client and explore its methods | [Ruby SDK guide](https://docs.noresponse.org/sdks/ruby) |
| Act when an account's decision changes | [Late results](https://docs.noresponse.org/guides/late-results) |
| Explore request and response fields | [API reference](https://docs.noresponse.org/api-reference) |

<details>
<summary><strong>SDK reference</strong> · configuration, methods, errors and webhooks</summary>

[Configure the client](#configure-the-client) · [Assessments](#assessments) · [Keys](#keys) · [Errors](#errors) · [Retries](#retries) · [Issued keys](#issued-keys) · [Webhooks](#webhooks) · [Changes since 2.0.0](#changes-since-200)

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
    flow: Models::Shared::Flow::ACCOUNT_CREATION,
    account_id: "usr_8f2k1",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(email: "jordan.lee@example.com"),
    response_mode: Models::Shared::ResponseMode::DETAILED # detailed needs the detailed scope
  ),
  idempotency_key: "account-usr_8f2k1-0001"
)

latest = client.assessments.get(assessment_id: created.result.id)
settled = client.assessments.wait(created.result.id, timeout: 30)
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
  assessment_id: created.result.id,
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

When your platform issues an API key to the new account, send only its hash, as `issued_credential.sha256`; the key itself never leaves your backend.

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
) # your receiver sees event.test == true
```

`list`, `rotate_signing_key(endpoint_id:, body:)` (the old key verifies for 7 more days) and `delete(endpoint_id:)` manage it afterwards.

Verify the exact bytes you received, then act on the typed event. `secrets` maps each `whk_` key id we give you to its secret; hold both during a rotation.

```ruby
# Rack or Sinatra: post "/webhooks/noresponse"
payload = request.body.read
# Rack names a header HTTP_NR_WEBHOOK_ID: give each NR-Webhook-* header its own name back.
headers = request.env.filter_map { |name, value| [name.delete_prefix("HTTP_").tr("_", "-"), value] if name.start_with?("HTTP_NR_WEBHOOK_") }.to_h
begin
  event = NoResponse::WebhookVerification.construct_event(payload, headers, { key_id => secret })
rescue NoResponse::WebhookVerification::VerificationError => e
  halt 400, e.code
end

case event
when NoResponse::Models::Shared::EndpointVerificationEvent
  content_type :json
  halt 200, { "challenge" => event.data.challenge }.to_json
when NoResponse::Models::Shared::AssessmentUpdatedEvent
  if event.test
    # send_test_event's fixed example assessment: apply nothing
  elsif event.data.is_a?(NoResponse::Models::Shared::AssessmentExpired)
    # forget the assessment: GET now answers 404
  end
  # any other assessment.updated reports progress only: apply nothing
when NoResponse::Models::Shared::AccountDeletedEvent
  # you erased event.data.account_id with accounts.delete
when NoResponse::Models::Shared::WorkspaceDeletedEvent
  # the workspace is deleted: the last event this endpoint receives, once per event.data.environment
when NoResponse::Models::Shared::WebhookEndpointDisabledEvent
  # event.data.endpoint_id failed for 72 hours and is disabled: fix it and verify it again
when NoResponse::Models::Shared::AccountRiskChangedEvent
  # the one event to act on: a flow's decision changed, at event.data.account.risk_version.
  # This verifier alone does not enforce it: use handle_risk_change (below) as this endpoint's receiver.
end
status 204
```

`NoResponse::WebhookVerification.construct_event(payload, headers, secrets, tolerance_seconds: 300, now: nil)` takes the raw body and a hash of headers in any letter case, and returns one typed event class per `type` from `NoResponse::Models::Shared`. It refuses a missing or repeated header, a stale delivery, an unknown key id, a bad signature or a body that is not a known event, and `VerificationError#code` says which: `"missing_header"`, `"duplicate_header"`, `"invalid_timestamp"`, `"unknown_key"`, `"invalid_signature"` or `"invalid_payload"`. Deliveries are at least once: deduplicate on `event.id`. `event.test` is true only on an `assessment.updated` event sent by `send_test_event`; its `data` is a fixed example assessment, so acknowledge it and apply nothing.

### Late results

Deliveries can overlap. Give `with_account_lock:` a lock on the account that all your workers share. Store the result's risk version inside it. Without the lock, an old decision can undo a newer one. [Overlapping deliveries](https://docs.noresponse.org/guides/late-results#overlapping-deliveries) says what the lock must do.

`account.risk_changed` only wakes your handler. `NoResponse::LateResults.handle_risk_change` verifies the delivery with `construct_event`, reads the account's current risk with `accounts.get` (the event's own decision is ignored), asks your `get_account_state` where the account is in your flow, and acts through Clerk, WorkOS or Auth0 from the table every SDK shares: an onboarding account fails onboarding, a provisional one is refused activation, an active one is restricted on `block` or signed out on `review`, and each also has its sessions revoked. Every action, or `none`, is recorded with `accounts.record_enforcement` at the `risk_version` read.

```ruby
provider = NoResponse::LateResults.identity_provider('clerk', token: ENV.fetch('CLERK_SECRET_KEY'))
result = NoResponse::LateResults.handle_risk_change(
  client, payload, headers, { key_id => secret },
  provider: provider,
  get_account_state: lambda { |account|
    user = User.find_by(noresponse_account_id: account.id) or next nil
    NoResponse::LateResults::AccountStateAnswer.new(state: user.state, user_id: user.clerk_id,
                                                    enforced_risk_version: user.enforced_risk_version)
  },
  flows: { 'login' => NoResponse::LateResults::FlowPolicy.new(reinstate: true) }
)
# Store result.risk_version and return it as enforced_risk_version: a replayed or older event then changes nothing.
```

Nothing deletes a user. Clerk bans (undone by unban); Auth0 sets `blocked`; WorkOS has no block on a user, so it writes `noresponse_state` to the user's metadata and revokes every session: gate sign-in on that key. Lifting a restriction when the risk falls is opt-in per flow (`reinstate`). A refused provider call is recorded as failed and raises `LateResults::ProviderActionError`; answer 5xx so we deliver again. For your own user store, `LateResults.custom_provider('restrict' => ->(user_id) { ... }, ...)` takes one callable per action. To catch up after missed deliveries, page `accounts.list_changed(unenforced: true)` and pass each account to `LateResults.enforce_account`.

A held flow (workspace settings `admission: held`) answers `held` until its investigation completes or `hold_seconds` pass, and the handler records `none` for it. When the final decision arrives as `account.risk_changed`, an `onboarding` or `provisional` account fails onboarding or is refused activation on `review` or `block`. On `allow` the handler records `activate` (no provider call; a custom provider runs its own `activate`), so admit the account when the result's enforcements hold it. An account at `allow` that needs no change, such as an `active` one after a held login, is recorded as `none`. Either way the account leaves the unenforced list. See https://docs.noresponse.org/guides/late-results.

## Changes since 2.0.0

Names that changed:

| 2.0.0 | Now |
|---|---|
| `NoResponse::NoResponse` | `NoResponse::NoResponseClient` |
| no shared parent for errors | `NoResponse::Models::Errors::NoResponseError`, the parent of every error class and of `APIStatusError` |
| `NoResponse::Wait.wait(client, id)` | `client.assessments.wait(id)`; `NoResponse::Wait.wait(client, id)` still works |
| `create(body:, idempotency_key:)` with the key required | `idempotency_key:` is optional |
| `record_outcome(body:, assessment_id:, idempotency_key:)` with the key required | `idempotency_key:` is optional |

</details>

## Combine submitted identifiers

Search accounts and assessments with explicit AND/OR combinations of submitted
email, phone and customer-namespace username terms. Use `IdentifierExpression`
and its required `scope`: `assessment` requires one submission to satisfy the
whole expression; `account` can combine different retained submissions of the
same account and is accepted only by account search. Pass the expression through the generated search request `identifier_expression` field.

Expressions have at most eight raw terms and three group levels. The original
exact, canonical and explicit mailbox matching rules still apply to each term.
Expression results contain indexed `IdentifierTermMatch` records with the
original submitted value and originating assessment, separate from current
account risk. Single-identifier and legacy email filters retain their behavior.

See the [combined-search contract and examples](https://docs.noresponse.org/reference/investigation#combine-submitted-identifiers)
for the expression shape, scope differences, permissions and pagination.

## Support

[Open an issue](https://github.com/noresponsehq/ruby/issues) and include the request ID from the response or error.
Keep API keys and personal data out of issues.

[Apache-2.0](LICENSE).
