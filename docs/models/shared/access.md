# Access

public profiles were read; a private or locked one exists but could not be read.

## Example Usage

```ruby
require "noresponse"

value = Access::PUBLIC

# Open enum: use .deserialize() to create instances from custom string values
custom = Access.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `PUBLIC`  | public    |
| `PRIVATE` | private   |
| `LOCKED`  | locked    |