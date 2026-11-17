# EnrichmentMode

off: enrichment starts no search. suggest: enrichment starts no search by itself. automatic: after a workspace person's own investigation, and each time a search on that person finishes, enrichment starts searches by itself.

## Example Usage

```ruby
require "noresponse"

value = EnrichmentMode::OFF

# Open enum: use .deserialize() to create instances from custom string values
custom = EnrichmentMode.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `OFF`       | off         |
| `SUGGEST`   | suggest     |
| `AUTOMATIC` | automatic   |