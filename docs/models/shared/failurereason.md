# FailureReason

Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.

## Example Usage

```ruby
require "noresponse"

value = FailureReason::TIMED_OUT

# Open enum: use .deserialize() to create instances from custom string values
custom = FailureReason.deserialize("custom_value")
```


## Values

| Name                    | Value                   |
| ----------------------- | ----------------------- |
| `TIMED_OUT`             | timed_out               |
| `RATE_LIMITED`          | rate_limited            |
| `BLOCKED`               | blocked                 |
| `SOURCE_ERROR`          | source_error            |
| `UNAVAILABLE`           | unavailable             |
| `DEFERRED`              | deferred                |
| `INSUFFICIENT_EVIDENCE` | insufficient_evidence   |