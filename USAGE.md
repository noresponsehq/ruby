<!-- Start SDK Example Usage [usage] -->
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  ),
  idempotency_key: "<value>"
)

unless res.nil?
  # handle response
end

```
<!-- End SDK Example Usage [usage] -->