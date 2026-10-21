# BreachSelector

The submitted identifier a breach table matched on: email or username. Phone and name are not breach selectors.

## Example Usage

```ruby
require "noresponse"

value = BreachSelector::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = BreachSelector.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `EMAIL`    | email      |
| `USERNAME` | username   |
| `IP`       | ip         |