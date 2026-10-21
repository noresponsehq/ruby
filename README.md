# noresponse

Developer-friendly & type-safe Ruby SDK specifically catered to leverage *noresponse* API.


<br /><br />
> [!IMPORTANT]
> This SDK is not yet ready for production use. Delete this section before > publishing to a package manager.

<!-- Start Summary [summary] -->
## Summary

NoResponse API: Server-side signup and gateway risk assessment: a recommendation, polling and signed webhooks.

Assess a signup or gateway event, poll a pending assessment, page through an account's history, record what you later learned, and rotate your API key. Every response carries X-Request-ID; every error is an RFC 9457 problem document. Keep the API key on your server.
<!-- End Summary [summary] -->

<!-- Start Table of Contents [toc] -->
## Table of Contents
<!-- $toc-max-depth=2 -->
* [noresponse](#noresponse)
  * [SDK Installation](#sdk-installation)
  * [SDK Example Usage](#sdk-example-usage)
  * [Authentication](#authentication)
  * [Available Resources and Operations](#available-resources-and-operations)
  * [Retries](#retries)
  * [Error Handling](#error-handling)
  * [Server Selection](#server-selection)
* [Development](#development)
  * [Maturity](#maturity)
  * [Contributions](#contributions)

<!-- End Table of Contents [toc] -->

<!-- Start SDK Installation [installation] -->
## SDK Installation

The SDK can be installed using [RubyGems](https://rubygems.org/):

```bash
gem install specific_install
gem specific_install  
```
<!-- End SDK Installation [installation] -->

<!-- Start SDK Example Usage [usage] -->
## SDK Example Usage

### Example

```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  idempotency_key: "<value>",
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  )
)

unless res.nil?
  # handle response
end

```
<!-- End SDK Example Usage [usage] -->

<!-- Start Authentication [security] -->
## Authentication

### Per-Client Security Schemes

This SDK supports the following security scheme globally:

| Name      | Type | Scheme      |
| --------- | ---- | ----------- |
| `api_key` | http | HTTP Bearer |

To authenticate with the API the `api_key` parameter must be set when initializing the SDK client instance. For example:
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  idempotency_key: "<value>",
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  )
)

unless res.nil?
  # handle response
end

```
<!-- End Authentication [security] -->

<!-- Start Available Resources and Operations [operations] -->
## Available Resources and Operations

<details open>
<summary>Available methods</summary>

### [Assessments](docs/sdks/assessments/README.md)

* [create](docs/sdks/assessments/README.md#create) - Assess identifiers for a signup or gateway decision.
* [get](docs/sdks/assessments/README.md#get) - Poll the authoritative assessment of one assessment.
* [record_outcome](docs/sdks/assessments/README.md#record_outcome) - Report what was later learned about an assessed account.
* [query](docs/sdks/assessments/README.md#query) - Page through one account's unexpired assessments.

### [Keys](docs/sdks/keys/README.md)

* [rotate](docs/sdks/keys/README.md#rotate) - Rotate the API key that signs the request.

</details>
<!-- End Available Resources and Operations [operations] -->

<!-- Start Retries [retries] -->
## Retries

Some of the endpoints in this SDK support retries. If you use the SDK without any configuration, it will fall back to the default retry strategy provided by the API. However, the default retry strategy can be overridden on a per-operation basis, or across the entire SDK.

To change the default retry strategy for a single API call, simply provide a `RetryConfig` object to the call:
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  idempotency_key: "<value>",
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  )
)

unless res.nil?
  # handle response
end

```

If you'd like to override the default retry strategy for all operations that support retries, you can use the `retry_config` optional parameter when initializing the SDK:
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  retry_config: Utils::RetryConfig.new(
    backoff: Utils::BackoffStrategy.new(
      exponent: 1.1,
      initial_interval: 1,
      max_elapsed_time: 100,
      max_interval: 50
    ),
    retry_connection_errors: false,
    strategy: "backoff"
  ),
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  idempotency_key: "<value>",
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  )
)

unless res.nil?
  # handle response
end

```
<!-- End Retries [retries] -->

<!-- Start Error Handling [errors] -->
## Error Handling

Handling errors in this SDK should largely match your expectations. All operations return a response object or raise an error.

By default an API error will raise a `Errors::APIStatusError`, which has the following properties:

| Property       | Type                                    | Description           |
|----------------|-----------------------------------------|-----------------------|
| `message`     | *string*                                 | The error message     |
| `status_code`  | *int*                                   | The HTTP status code  |
| `raw_response` | *Faraday::Response*                     | The raw HTTP response |
| `body`        | *string*                                 | The response content  |

When custom error responses are specified for an operation, the SDK may also throw their associated exception. You can refer to respective *Errors* tables in SDK docs for more details on possible exception types for each operation. For example, the `create` method throws the following exceptions:

| Error Type                            | Status Code | Content Type             |
| ------------------------------------- | ----------- | ------------------------ |
| Models::Errors::BadRequestError       | 400         | application/problem+json |
| Models::Errors::AuthenticationError   | 401         | application/problem+json |
| Models::Errors::PermissionDeniedError | 403         | application/problem+json |
| Models::Errors::NotFoundError         | 404         | application/problem+json |
| Models::Errors::ConflictError         | 409         | application/problem+json |
| Models::Errors::RateLimitError        | 429         | application/problem+json |
| Errors::APIStatusError                | 4XX, 5XX    | \*/\*                    |

### Example

```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)

begin
  res = s.assessments.create(
    idempotency_key: "<value>",
    body: Models::Shared::AssessmentRequest.new(
      account_id: "acct_7f3a9c",
      identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
        email: "new.user@example.com"
      )
    )
  )

  unless res.nil?
    # handle response
  end

rescue Models::Errors::BadRequestError => e
  # handle e.container data
  raise e
rescue Models::Errors::AuthenticationError => e
  # handle e.container data
  raise e
rescue Models::Errors::PermissionDeniedError => e
  # handle e.container data
  raise e
rescue Models::Errors::NotFoundError => e
  # handle e.container data
  raise e
rescue Models::Errors::ConflictError => e
  # handle e.container data
  raise e
rescue Models::Errors::RateLimitError => e
  # handle e.container data
  raise e
rescue Errors::APIStatusError => e
  # handle default exception
  raise e
end

```
<!-- End Error Handling [errors] -->

<!-- Start Server Selection [server] -->
## Server Selection

### Override Server URL Per-Client

The default server can be overridden globally by passing a URL to the `server_url (String)` optional parameter when initializing the SDK client instance. For example:
```ruby
require "noresponse"

Models = ::NoResponse::Models
s = ::NoResponse::NoResponse.new(
  server_url: "https://api.noresponse.org",
  api_key: "<YOUR_BEARER_TOKEN_HERE>"
)
res = s.assessments.create(
  idempotency_key: "<value>",
  body: Models::Shared::AssessmentRequest.new(
    account_id: "acct_7f3a9c",
    identifiers: Models::Shared::AssessmentRequestIdentifiers.new(
      email: "new.user@example.com"
    )
  )
)

unless res.nil?
  # handle response
end

```
<!-- End Server Selection [server] -->

<!-- Placeholder for Future NoResponse SDK Sections -->

# Development

## Maturity

This SDK is in beta, and there may be breaking changes between versions without a major version update. Therefore, we recommend pinning usage
to a specific package version. This way, you can install the same version each time without breaking changes unless you are intentionally
looking for the latest version.

## Contributions

While we value open-source contributions to this SDK, this library is generated programmatically. Any manual changes added to internal files will be overwritten on the next generation. 
We look forward to hearing your feedback. Feel free to open a PR or an issue with a proof of concept and we'll do our best to include it in a future release. 
