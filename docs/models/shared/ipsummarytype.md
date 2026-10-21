# IpSummaryType

The address's network type.

## Example Usage

```ruby
require "noresponse"

value = IpSummaryType::RESIDENTIAL

# Open enum: use .deserialize() to create instances from custom string values
custom = IpSummaryType.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `RESIDENTIAL` | residential   |
| `HOSTING`     | hosting       |
| `VPN`         | vpn           |
| `PROXY`       | proxy         |
| `TOR`         | tor           |
| `MOBILE`      | mobile        |
| `UNKNOWN`     | unknown       |