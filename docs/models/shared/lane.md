# Lane

An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.

## Example Usage

```ruby
require "noresponse"

value = Lane::ACCOUNTS

# Open enum: use .deserialize() to create instances from custom string values
custom = Lane.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `ACCOUNTS` | accounts   |
| `PHONE`    | phone      |
| `BREACH`   | breach     |
| `DOMAIN`   | domain     |
| `IP`       | ip         |