# ScreeningPlatformCoverageStatus

covered read at least one profile; none_found looked and found no account; inaccessible found accounts that are private or locked; failed could not finish looking; unavailable has no resolver or collector enabled.

## Example Usage

```ruby
require "noresponse"

value = ScreeningPlatformCoverageStatus::COVERED

# Open enum: use .deserialize() to create instances from custom string values
custom = ScreeningPlatformCoverageStatus.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `COVERED`      | covered        |
| `NONE_FOUND`   | none_found     |
| `INACCESSIBLE` | inaccessible   |
| `FAILED`       | failed         |
| `UNAVAILABLE`  | unavailable    |