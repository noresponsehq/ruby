# LastError

## Example Usage

```ruby
require "noresponse"

value = LastError::SCREENING_CAP_EXCEEDED

# Open enum: use .deserialize() to create instances from custom string values
custom = LastError.deserialize("custom_value")
```


## Values

| Name                     | Value                    |
| ------------------------ | ------------------------ |
| `SCREENING_CAP_EXCEEDED` | screening_cap_exceeded   |
| `SCREENING_UNAVAILABLE`  | screening_unavailable    |
| `PERSON_NOT_FOUND`       | person_not_found         |
| `IDEMPOTENCY_KEY_REUSED` | idempotency_key_reused   |