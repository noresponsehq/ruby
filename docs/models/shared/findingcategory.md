# FindingCategory

What a finding is about: a direct threat to the principal or the group, intent to harm without a named target, fixation on the principal, a grievance against the host, research into the venue, route or security, weapons tied to any of these, disruption or protest planning toward this group, violent extremist content or identification, prior harassment or stalking of staff or principals, or posting the principal's addresses or movements.

## Example Usage

```ruby
require "noresponse"

value = FindingCategory::DIRECT_THREAT

# Open enum: use .deserialize() to create instances from custom string values
custom = FindingCategory.deserialize("custom_value")
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `DIRECT_THREAT`     | direct_threat       |
| `HARM_INTENT`       | harm_intent         |
| `FIXATION`          | fixation            |
| `GRIEVANCE`         | grievance           |
| `SECURITY_RESEARCH` | security_research   |
| `WEAPONS`           | weapons             |
| `DISRUPTION`        | disruption          |
| `VIOLENT_EXTREMISM` | violent_extremism   |
| `HARASSMENT`        | harassment          |
| `MOVEMENT_EXPOSURE` | movement_exposure   |