# BreachKind

Who is in the table: site_breach, a site's own users; credential_list, a combolist or compilation; stealer_log, malware or botnet victims; scrape; hacking_forum, a criminal hacking, cracking or carding community; abuse_service, the customers of DDoS-for-hire, account generators, dump or card shops, darknet markets, stalkerware or breach-lookup services; darkweb_site, an onion site of unknown purpose.

## Example Usage

```ruby
require "noresponse"

value = BreachKind::SITE_BREACH

# Open enum: use .deserialize() to create instances from custom string values
custom = BreachKind.deserialize("custom_value")
```


## Values

| Name              | Value             |
| ----------------- | ----------------- |
| `SITE_BREACH`     | site_breach       |
| `CREDENTIAL_LIST` | credential_list   |
| `STEALER_LOG`     | stealer_log       |
| `SCRAPE`          | scrape            |
| `HACKING_FORUM`   | hacking_forum     |
| `ABUSE_SERVICE`   | abuse_service     |
| `DARKWEB_SITE`    | darkweb_site      |