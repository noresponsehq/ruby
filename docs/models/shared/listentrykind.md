# ListEntryKind

email matches one address, whatever the case of its local part. email_domain matches every address of the registrable domain and of its subdomains.

## Example Usage

```ruby
require "noresponse"

value = ListEntryKind::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = ListEntryKind.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `EMAIL`        | email          |
| `EMAIL_DOMAIN` | email_domain   |