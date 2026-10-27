# ListEntryAction

block decides block for the accounts the entry matches; allow decides allow. Block wins when both match.

## Example Usage

```ruby
require "noresponse"

value = ListEntryAction::BLOCK

# Open enum: use .deserialize() to create instances from custom string values
custom = ListEntryAction.deserialize("custom_value")
```


## Values

| Name    | Value   |
| ------- | ------- |
| `BLOCK` | block   |
| `ALLOW` | allow   |