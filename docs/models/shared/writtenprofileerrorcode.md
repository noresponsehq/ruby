# WrittenProfileErrorCode

Present only when status is failed. no_writer: no profile writer serves this environment. refused: the model refused. not_written: the answer was not a profile, or no statement survived grounding. uncited_statement: a statement or lead cited a record the person does not hold. not_answered: the writer did not answer. worker_attempts_exhausted: the worker stopped retrying.

## Example Usage

```ruby
require "noresponse"

value = WrittenProfileErrorCode::NO_WRITER

# Open enum: use .deserialize() to create instances from custom string values
custom = WrittenProfileErrorCode.deserialize("custom_value")
```


## Values

| Name                        | Value                       |
| --------------------------- | --------------------------- |
| `NO_WRITER`                 | no_writer                   |
| `REFUSED`                   | refused                     |
| `NOT_WRITTEN`               | not_written                 |
| `UNCITED_STATEMENT`         | uncited_statement           |
| `NOT_ANSWERED`              | not_answered                |
| `WORKER_ATTEMPTS_EXHAUSTED` | worker_attempts_exhausted   |