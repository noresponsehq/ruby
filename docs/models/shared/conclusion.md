# Conclusion

## Example Usage

```ruby
require "noresponse"

value = Conclusion::BENIGN

# Open enum: use .deserialize() to create instances from custom string values
custom = Conclusion.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `BENIGN`       | benign         |
| `ABUSE`        | abuse          |
| `INCONCLUSIVE` | inconclusive   |