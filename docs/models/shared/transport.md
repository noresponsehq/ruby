# Transport

Where the context was derived: backend (also when the request named no transport), browser, or provider_hook for a hosted provider hook.

## Example Usage

```ruby
require "noresponse"

value = Transport::BACKEND

# Open enum: use .deserialize() to create instances from custom string values
custom = Transport.deserialize("custom_value")
```


## Values

| Name            | Value           |
| --------------- | --------------- |
| `BACKEND`       | backend         |
| `BROWSER`       | browser         |
| `PROVIDER_HOOK` | provider_hook   |