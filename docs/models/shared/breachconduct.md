# BreachConduct

What a breach table's rows record against the identifier: chargeback, one or more chargebacks; declined_payment, one or more declined payments; forum_sanction, a forum ban, warning or infraction. A category and not a value: the schema has no member for one.

## Example Usage

```ruby
require "noresponse"

value = BreachConduct::CHARGEBACK

# Open enum: use .deserialize() to create instances from custom string values
custom = BreachConduct.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `CHARGEBACK`       | chargeback         |
| `DECLINED_PAYMENT` | declined_payment   |
| `FORUM_SANCTION`   | forum_sanction     |