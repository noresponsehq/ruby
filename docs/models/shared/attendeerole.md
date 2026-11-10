# AttendeeRole

The attendee's role at the event: guest (a ticket holder), crew, vendor or press. Leave it out when you do not know it: an attendee without one has no role, not guest. A later row naming the same attendee replaces it, and a change of role alone keeps the attendee's screening results.

## Example Usage

```ruby
require "noresponse"

value = AttendeeRole::GUEST

# Open enum: use .deserialize() to create instances from custom string values
custom = AttendeeRole.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `GUEST`  | guest    |
| `CREW`   | crew     |
| `VENDOR` | vendor   |
| `PRESS`  | press    |