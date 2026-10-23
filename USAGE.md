<!-- Start SDK Example Usage [usage] -->
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch("NORESPONSE_API_KEY", "")
)
res = s.assessments.create(
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  ),
  idempotency_key: "signup-7f3a9c-0001"
)

unless res.nil?
  # handle response
end

```
<!-- End SDK Example Usage [usage] -->