# ErrorCode

Why a failed search found nothing: its sources did not answer, none could be asked, or it could not run before its attempts were spent.

## Example Usage

```ruby
require "noresponse"

value = ErrorCode::NOT_ANSWERED

# Open enum: use .deserialize() to create instances from custom string values
custom = ErrorCode.deserialize("custom_value")
```


## Values

| Name                        | Value                       |
| --------------------------- | --------------------------- |
| `NOT_ANSWERED`              | not_answered                |
| `NO_SOURCE`                 | no_source                   |
| `WORKER_ATTEMPTS_EXHAUSTED` | worker_attempts_exhausted   |