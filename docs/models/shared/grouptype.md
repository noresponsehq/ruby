# GroupType

What the group's people share: an event, an organisation, a place or another attribute.

## Example Usage

```ruby
require "noresponse"

value = GroupType::EVENT

# Open enum: use .deserialize() to create instances from custom string values
custom = GroupType.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `EVENT`        | event          |
| `ORGANISATION` | organisation   |
| `PLACE`        | place          |
| `CUSTOM`       | custom         |