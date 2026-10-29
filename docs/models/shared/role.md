# Role

A built-in capability set. Specialist roles are independent; effective access is returned by GET /v1/workspaces/{workspace_id}/capabilities.

## Example Usage

```ruby
require "noresponse"

value = Role::OWNER

# Open enum: use .deserialize() to create instances from custom string values
custom = Role.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `OWNER`        | owner          |
| `ADMIN`        | admin          |
| `DEVELOPER`    | developer      |
| `VIEWER`       | viewer         |
| `INVESTIGATOR` | investigator   |
| `AUDITOR`      | auditor        |
| `BILLING`      | billing        |