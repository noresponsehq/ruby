# ScreeningLookupCheckStatus

found: a source found the identifier. not_found: every source answered and none found it. partial: the sources that answered found nothing and the others did not answer. not_covered: no source answered. A lookup that failed reads partial or not_covered, not not_found.

## Example Usage

```ruby
require "noresponse"

value = ScreeningLookupCheckStatus::FOUND

# Open enum: use .deserialize() to create instances from custom string values
custom = ScreeningLookupCheckStatus.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `FOUND`       | found         |
| `NOT_FOUND`   | not_found     |
| `PARTIAL`     | partial       |
| `NOT_COVERED` | not_covered   |