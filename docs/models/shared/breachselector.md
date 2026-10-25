# BreachSelector

The submitted email or username whose own search matched the table. A submitted full name is searched as well, and what it finds feeds the identity's reasons rather than this list.

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