# AggregateDimension

decision, recommendation and band: the first answer's. flow: the assessment's. list_match: the action of the list entry that decided the account when it was first answered. reason: a reason the first answer fired, with its impact band. lane: an evidence lane the first answer listed in incomplete_sources. country and asn: the submitted IP's, from the IP data.

## Example Usage

```ruby
require "noresponse"

value = AggregateDimension::DECISION

# Open enum: use .deserialize() to create instances from custom string values
custom = AggregateDimension.deserialize("custom_value")
```


## Values

| Name             | Value            |
| ---------------- | ---------------- |
| `DECISION`       | decision         |
| `FLOW`           | flow             |
| `RECOMMENDATION` | recommendation   |
| `BAND`           | band             |
| `REASON`         | reason           |
| `LANE`           | lane             |
| `COUNTRY`        | country          |
| `ASN`            | asn              |
| `LIST_MATCH`     | list_match       |