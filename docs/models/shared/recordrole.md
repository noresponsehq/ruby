# RecordRole

Which common field a value is, where many sources share it: a join date and a birth date are both dates, with the roles joined and born. A platform account's field and a breach row's column with the same meaning carry the same kind and role. A linked_account field is named by its network. Absent for a field only its source returns.

## Example Usage

```ruby
require "noresponse"

value = RecordRole::ACCOUNT_ID

# Open enum: use .deserialize() to create instances from custom string values
custom = RecordRole.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `ACCOUNT_ID`       | account_id         |
| `ACCOUNT_STATUS`   | account_status     |
| `ACCOUNT_TYPE`     | account_type       |
| `ALTERNATE_PHONE`  | alternate_phone    |
| `BALANCE`          | balance            |
| `BANNED`           | banned             |
| `BIO`              | bio                |
| `BORN`             | born               |
| `BOT`              | bot                |
| `CALLER_CATEGORY`  | caller_category    |
| `COVER_PICTURE`    | cover_picture      |
| `DELETED`          | deleted            |
| `DELETED_ON`       | deleted_on         |
| `DEPARTMENT`       | department         |
| `DISPLAY_NAME`     | display_name       |
| `EMAIL_VERIFIED`   | email_verified     |
| `EXPIRES`          | expires            |
| `FIRST_NAME`       | first_name         |
| `FOLLOWERS`        | followers          |
| `FOLLOWING`        | following          |
| `FRIENDS`          | friends            |
| `FULL_ADDRESS`     | full_address       |
| `FULL_NAME`        | full_name          |
| `HANDLE`           | handle             |
| `HEADLINE`         | headline           |
| `INTERESTS`        | interests          |
| `JOB_TITLE`        | job_title          |
| `JOINED`           | joined             |
| `LAST_ACTIVE`      | last_active        |
| `LAST_IP`          | last_ip            |
| `LAST_NAME`        | last_name          |
| `LAST_POST`        | last_post          |
| `LAST_UPDATED`     | last_updated       |
| `LEVEL`            | level              |
| `LIKES_GIVEN`      | likes_given        |
| `LIKES_RECEIVED`   | likes_received     |
| `LINE_TYPE`        | line_type          |
| `LINKED_ACCOUNT`   | linked_account     |
| `LOCATION`         | location           |
| `MARKED_SPAM`      | marked_spam        |
| `MIDDLE_NAME`      | middle_name        |
| `NATIONALITY`      | nationality        |
| `ORGANISATION`     | organisation       |
| `OTHER_IP`         | other_ip           |
| `PAID`             | paid               |
| `PASSWORD_CHANGED` | password_changed   |
| `PICTURE`          | picture            |
| `POINTS`           | points             |
| `POSTS`            | posts              |
| `PRIVATE`          | private            |
| `PROFILE_LINK`     | profile_link       |
| `PROFILE_VIEWS`    | profile_views      |
| `RATING`           | rating             |
| `REFERRALS`        | referrals          |
| `REFERRER`         | referrer           |
| `REPORT_COUNT`     | report_count       |
| `REPUTATION`       | reputation         |
| `REPUTATION_LABEL` | reputation_label   |
| `RESIDENCE`        | residence          |
| `SALUTATION`       | salutation         |
| `SCHOOL`           | school             |
| `SIGNATURE`        | signature          |
| `SIGNUP_IP`        | signup_ip          |
| `SITE_ROLE`        | site_role          |
| `SPAM_SCORE`       | spam_score         |
| `STREET`           | street             |
| `VERIFIED`         | verified           |
| `WARNINGS`         | warnings           |
| `WEBSITE`          | website            |