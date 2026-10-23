# Flow

The provider flow the assessment gates. Use the top-level flow instead; this member is ignored when the top-level flow is present. Absent means signup.

## Example Usage

```ruby
require "noresponse"

value = Flow::SIGNUP
```


## Values

| Name             | Value            |
| ---------------- | ---------------- |
| `SIGNUP`         | signup           |
| `LOGIN`          | login            |
| `RECOVERY`       | recovery         |
| `PROFILE_CHANGE` | profile_change   |