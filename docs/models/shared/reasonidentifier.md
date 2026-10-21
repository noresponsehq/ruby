# ReasonIdentifier

The submitted identifier or client context field a reason concerns; absent when it concerns the whole assessment. Client context is a claimed hint, not a device fingerprint.

## Example Usage

```ruby
require "noresponse"

value = ReasonIdentifier::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = ReasonIdentifier.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `EMAIL`    | email      |
| `USERNAME` | username   |
| `PHONE`    | phone      |
| `NAME`     | name       |
| `IP`       | ip         |
| `CONTEXT`  | context    |