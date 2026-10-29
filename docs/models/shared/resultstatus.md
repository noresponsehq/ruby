# ResultStatus

## Example Usage

```ruby
require "noresponse"

value = ResultStatus::NO_CHANGE

# Open enum: use .deserialize() to create instances from custom string values
custom = ResultStatus.deserialize("custom_value")
```


## Values

| Name                       | Value                      |
| -------------------------- | -------------------------- |
| `NO_CHANGE`                | no_change                  |
| `PROPOSAL_REQUIRES_REVIEW` | proposal_requires_review   |