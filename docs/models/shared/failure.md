# Failure

Why the attempt failed: the URL is no longer valid, the host did not resolve, it resolved to an address that is not public, no answer within 5 seconds, the connection failed, a 3xx (redirects are not followed) or another non-2xx status. Absent for a delivered attempt.

## Example Usage

```ruby
require "noresponse"

value = Failure::INVALID_URL

# Open enum: use .deserialize() to create instances from custom string values
custom = Failure.deserialize("custom_value")
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `INVALID_URL`       | invalid_url         |
| `RESOLVE_FAILED`    | resolve_failed      |
| `ADDRESS_REFUSED`   | address_refused     |
| `TIMEOUT`           | timeout             |
| `CONNECTION_FAILED` | connection_failed   |
| `REDIRECT`          | redirect            |
| `NON_2XX`           | non_2xx             |