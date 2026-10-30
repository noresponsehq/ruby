# ReasonCode

A stable reason code. New codes may appear; ignore any you do not know.

## Example Usage

```ruby
require "noresponse"

value = ReasonCode::NO_DIGITAL_FOOTPRINT

# Open enum: use .deserialize() to create instances from custom string values
custom = ReasonCode.deserialize("custom_value")
```


## Values

| Name                            | Value                           |
| ------------------------------- | ------------------------------- |
| `NO_DIGITAL_FOOTPRINT`          | no_digital_footprint            |
| `VOIP_NUMBER`                   | voip_number                     |
| `DISPOSABLE_EMAIL`              | disposable_email                |
| `NEW_EMAIL`                     | new_email                       |
| `NO_EMAIL_MATCHES`              | no_email_matches                |
| `SPAM_REPORTS`                  | spam_reports                    |
| `FRAUD_FLAG`                    | fraud_flag                      |
| `IDENTITY_MISMATCH`             | identity_mismatch               |
| `COUNTRY_MISMATCH`              | country_mismatch                |
| `PROXY_IP`                      | proxy_ip                        |
| `SEEN_BEFORE`                   | seen_before                     |
| `SHARED_IP`                     | shared_ip                       |
| `MANY_RECENT_ACCOUNTS`          | many_recent_accounts            |
| `ESTABLISHED_ACCOUNTS`          | established_accounts            |
| `AGED_IDENTITY`                 | aged_identity                   |
| `BREACH_NAME_MATCH`             | breach_name_match               |
| `BREACH_COOCCURRENCE`           | breach_cooccurrence             |
| `BREACH_NAME_MISMATCH`          | breach_name_mismatch            |
| `BREACH_PHONE_MISMATCH`         | breach_phone_mismatch           |
| `RECENT_PASSWORD_EXPOSURE`      | recent_password_exposure        |
| `CREDENTIAL_LIST_EXPOSURE`      | credential_list_exposure        |
| `ABUSE_ECOSYSTEM_MEMBER`        | abuse_ecosystem_member          |
| `NO_BREACH_HISTORY`             | no_breach_history               |
| `AUTOMATION_FAST_SUBMIT`        | automation_fast_submit          |
| `CLIENT_CLOCK_SKEW`             | client_clock_skew               |
| `BOT_OR_AUTOMATION`             | bot_or_automation               |
| `AUTH_EMAIL_VERIFIED`           | auth_email_verified             |
| `AUTH_PHONE_VERIFIED`           | auth_phone_verified             |
| `AUTH_MFA_RECENT`               | auth_mfa_recent                 |
| `AUTH_NEW_SESSION`              | auth_new_session                |
| `AUTH_NEW_ACCOUNT`              | auth_new_account                |
| `AUTH_IMPERSONATED`             | auth_impersonated               |
| `CONTEXT_TIMEZONE_MISMATCH`     | context_timezone_mismatch       |
| `CONTEXT_LOCALE_MISMATCH`       | context_locale_mismatch         |
| `CONTEXT_LINE_COUNTRY_MISMATCH` | context_line_country_mismatch   |
| `PRIOR_ABUSE_LINK`              | prior_abuse_link                |
| `TEST_SCENARIO`                 | test_scenario                   |
| `SHARED_API_KEY`                | shared_api_key                  |
| `LIST_MATCH`                    | list_match                      |
| `YOUNG_EMAIL_DOMAIN`            | young_email_domain              |
| `EMAIL_DOMAIN_NO_MX`            | email_domain_no_mx              |
| `EMAIL_DOMAIN_NONEXISTENT`      | email_domain_nonexistent        |
| `GOOGLE_ACCOUNT_MISSING`        | google_account_missing          |
| `GOOGLE_EMPTY_ACCOUNT`          | google_empty_account            |
| `GOOGLE_ACTIVE_PROFILE`         | google_active_profile           |
| `GOOGLE_AGED_ACCOUNT`           | google_aged_account             |
| `GOOGLE_NAME_MATCH`             | google_name_match               |
| `GOOGLE_NAME_MISMATCH`          | google_name_mismatch            |
| `GOOGLE_COUNTRY_MATCH`          | google_country_match            |
| `GOOGLE_COUNTRY_MISMATCH`       | google_country_mismatch         |
| `FORUM_SANCTIONED`              | forum_sanctioned                |
| `PRIOR_PAYMENT_ABUSE`           | prior_payment_abuse             |
| `IP_HISTORY_MATCH`              | ip_history_match                |
| `IDENTITY_ATTRIBUTE_CONFLICT`   | identity_attribute_conflict     |
| `IMPOSSIBLE_IDENTITY_AGE`       | impossible_identity_age         |
| `BREACH_SHARED_IP`              | breach_shared_ip                |
| `NATIONALITY_MISMATCH`          | nationality_mismatch            |
| `MINOR_IDENTITY`                | minor_identity                  |
| `REPORTED_ACCOUNT_ABUSE`        | reported_account_abuse          |