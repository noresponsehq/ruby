# People

## Overview

Workspace people, submitted identity, source evidence and expiry.

### Available Operations

* [list](#list) - List workspace people.
* [create](#create) - Create or reuse a workspace person.
* [get](#get) - Read a workspace person.
* [delete](#delete) - Delete a workspace person.
* [judge_record](#judge_record) - Join one of a workspace person's records to them, or reject it.
* [start_search](#start_search) - Search again on a value of one of a workspace person's records.
* [run_search](#run_search) - Run a counted password or hash search on a workspace person.

## list

Lists retained people in the key workspace and environment, including people in no group. Each returned person records a person.viewed audit event. Expired people are excluded before background deletion. email and phone narrow the list to people holding that exact address or number, so a client can open the person it already has instead of adding a duplicate.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="listWorkspacePeople" method="get" path="/v1/people" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.list(limit: 100)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                    | Type                                                                                         | Required                                                                                     | Description                                                                                  |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `limit`                                                                                      | *T.nilable(::Integer)*                                                                       | :heavy_minus_sign:                                                                           | N/A                                                                                          |
| `after`                                                                                      | *T.nilable(::String)*                                                                        | :heavy_minus_sign:                                                                           | Pass next_cursor from the prior page.                                                        |
| `email`                                                                                      | *T.nilable(::String)*                                                                        | :heavy_minus_sign:                                                                           | Return only people whose email is this address, compared without case or surrounding spaces. |
| `phone`                                                                                      | *T.nilable(::String)*                                                                        | :heavy_minus_sign:                                                                           | Return only people whose phone is this number, compared without surrounding spaces.          |

### Response

**[T.nilable(Models::Operations::ListWorkspacePeopleResponse)](../../models/operations/listworkspacepeopleresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## create

Creates a person without a group. An explicit person_id or external_id reuses the named workspace person. A reference-only request keeps submitted details; identity supplied with that reference replaces those details. A shared email or phone only suggests a match. Suggested matches are returned only with people-read access. The workspace retention setting determines expires_at. An existing person keeps their original expiry. An Idempotency-Key returns the same retained person on retries, without creating another. Changed input with the same key answers 409 idempotency_key_reused. A customer reference that names another person or several people answers 409 person_reference_conflict.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="createWorkspacePerson" method="post" path="/v1/people" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.create(body: Models::Shared::WorkspacePersonRequest.new(
  external_id: 'case-person-1042',
  name: 'Jordan Example',
  email: 'jordan@example.com'
), idempotency_key: 'request-01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `body`                                                                                                                                                                                                                                                                                                                                                   | [Models::Shared::WorkspacePersonRequest](../../models/shared/workspacepersonrequest.md)                                                                                                                                                                                                                                                                  | :heavy_check_mark:                                                                                                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                                                                                                      | {<br/>"external_id": "case-person-1042",<br/>"name": "Jordan Example",<br/>"email": "jordan@example.com"<br/>}                                                                                                                                                                                                                                           |
| `idempotency_key`                                                                                                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                                                                                                       | Opaque request key, 16 to 128 characters. Repeating the key and request returns the same resource in its current state while it is retained. A different request with the same key answers 409. Use a new key for a deliberate new operation. Keys are scoped to the environment and operation; person searches also scope them to the group and person. | request-01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                                                                                                       |

### Response

**[T.nilable(Models::Operations::CreateWorkspacePersonResponse)](../../models/operations/createworkspacepersonresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## get

Returns submitted details, the current retention expiry and the most recent retained completed or partial investigation evidence, together with retained follow-up search evidence from all of this person's groups. Search evidence remains available after its group is deleted. Migrated results whose original per-person status is unknown may also supply evidence. Earlier results and pending jobs remain available through investigation history; each investigation retains its own collected result. Full source records, posts and media are returned by default; explicit evidence.read denial withholds collected evidence and free-text notes. Each read records person.viewed without raw evidence in the audit log. A missing or expired person answers 404.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="getWorkspacePerson" method="get" path="/v1/people/{person_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.get(person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                      | Type                           | Required                       | Description                    | Example                        |
| ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ |
| `person_id`                    | *::String*                     | :heavy_check_mark:             | N/A                            | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM |

### Response

**[T.nilable(Models::Operations::GetWorkspacePersonResponse)](../../models/operations/getworkspacepersonresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## delete

Deletes a person and their retained evidence, investigation history and group memberships. Requires the separate delete permission. The audit retains only the person id and deletion metadata.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="deleteWorkspacePerson" method="delete" path="/v1/people/{person_id}" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.delete(person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                      | Type                           | Required                       | Description                    | Example                        |
| ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ | ------------------------------ |
| `person_id`                    | *::String*                     | :heavy_check_mark:             | N/A                            | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM |

### Response

**[T.nilable(Models::Operations::DeleteWorkspacePersonResponse)](../../models/operations/deleteworkspacepersonresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## judge_record

Records a verdict on one of the records the person report holds: joined makes the record the person's whatever its likelihood, and rejected keeps it a lead that leads nowhere. The verdict belongs to the person on their own: the person report and enrichment follow it, and each group keeps its own verdicts. It sticks for as long as the person's evidence holds the same record, and a later verdict on the same record replaces it. After each verdict, enrichment reads the person again under the environment's enrichment setting: it starts no search from a rejected record or from what a search of it found, and a joined record's values lead on. A record the person report does not hold answers 404. Each verdict is audited as person.record_judged. The decisions scope grants this operation. Explicit evidence.read restrictions override default evidence access. The groups scope is also accepted for existing integrations. The API key selects the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="judgeWorkspacePersonRecord" method="post" path="/v1/people/{person_id}/records" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.judge_record(person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::RecordVerdictRequest.new(
  record_id: 'rec_3f9a1c22d4e5b6a73f9a1c22d4e5b6a7',
  verdict: Models::Shared::Verdict::REJECTED
))

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                           | Type                                                                                | Required                                                                            | Description                                                                         | Example                                                                             |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `person_id`                                                                         | *::String*                                                                          | :heavy_check_mark:                                                                  | N/A                                                                                 | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                      |
| `body`                                                                              | [Models::Shared::RecordVerdictRequest](../../models/shared/recordverdictrequest.md) | :heavy_check_mark:                                                                  | N/A                                                                                 |                                                                                     |

### Response

**[T.nilable(Models::Operations::JudgeWorkspacePersonRecordResponse)](../../models/operations/judgeworkspacepersonrecordresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## start_search

Starts a search on the person alone, outside any group, as the group route does. The person's own enrichment then follows what it finds. Its records join the person report. Starts a new search on the value of one field of one of the person's records: a lookup's, a profile's or one an earlier search found. Name the record and the field; the value itself is not sent. The field's kind must be email, phone, username, person_name, password, hash, ip or domain. A domain search finds the breach rows of every email address at the domain, which must be a registrable domain or a host under one; any other domain answers 400. After a workspace person's own investigation or a group's screening, while the environment's enrichment mode, or an investigation's override, is automatic, enrichment also starts searches by itself, with requested_by enrichment, on the distinctive values of the enrichment kinds (usernames by default; email addresses and phone numbers when named) of records more likely than min_likelihood (0.5 by default) to be the person's: each value at most once per person (once more if that search failed), at most 5 searches from one search's records and 20 per person, at most 6 searches deep, within max_spend and the deadline when set, and within the screening cap; at the screening cap it waits and tries again later. A record a search finds starts from the likelihood of the record it came from, divided by one plus the results the search found on that site, or anywhere for a name search, so a chain grows less likely with each search and stops. A group takes mode suggest while the workspace has not set a mode. In suggest mode enrichment starts none by itself, and the person report lists what it would start in suggested_searches. The search runs the breach search and the account and phone lookups that take the value's kind, under the environment's source controls, and finishes seconds later. A password or hash search counts first: it stops at counted with rows, how many breach rows hold the value, and runs only when a person runs it. Name a table, as a lookup remaining entry names it, to fetch the rows an earlier search left out, up to 100. What the search finds joins the person's lookup records as leads, each match naming the search; the person report lists the searches, each with the value and the record and field it came from, and its records are scored like the rest. Without an Idempotency-Key, starting the same open search returns it. Its estimate counts against the environment's screening_daily_cap, and one the cap cannot hold answers 409 screening_cap_exceeded. A record or field the person does not hold answers 404. Each search is audited as person.search_started. Send an Idempotency-Key to retry safely: the same key and request return the same resource in its current state while it is retained, even after work completes. Reusing the key with different input answers 409 idempotency_key_reused. Use a new key for a deliberate new operation. The investigations scope grants this operation. Explicit evidence.read restrictions override default evidence access. The groups scope is also accepted for existing integrations. The API key selects the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="startWorkspacePersonSearch" method="post" path="/v1/people/{person_id}/searches" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.start_search(person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::SearchRequest.new(
  record_id: 'rec_3f9a1c22d4e5b6a73f9a1c22d4e5b6a7',
  field: 'username',
  table: 'FORUM_EXAMPLE_COM_2019'
), idempotency_key: 'request-01JA2Z8K6Q4V7W9XBCDEFGHJKM')

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                                                                                                                                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                                                                                                     | Required                                                                                                                                                                                                                                                                                                                                                 | Description                                                                                                                                                                                                                                                                                                                                              | Example                                                                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `person_id`                                                                                                                                                                                                                                                                                                                                              | *::String*                                                                                                                                                                                                                                                                                                                                               | :heavy_check_mark:                                                                                                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                                                                                                      | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                                                                                                           |
| `body`                                                                                                                                                                                                                                                                                                                                                   | [Models::Shared::SearchRequest](../../models/shared/searchrequest.md)                                                                                                                                                                                                                                                                                    | :heavy_check_mark:                                                                                                                                                                                                                                                                                                                                       | N/A                                                                                                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                                                                                                                                                                          |
| `idempotency_key`                                                                                                                                                                                                                                                                                                                                        | *T.nilable(::String)*                                                                                                                                                                                                                                                                                                                                    | :heavy_minus_sign:                                                                                                                                                                                                                                                                                                                                       | Opaque request key, 16 to 128 characters. Repeating the key and request returns the same resource in its current state while it is retained. A different request with the same key answers 409. Use a new key for a deliberate new operation. Keys are scoped to the environment and operation; person searches also scope them to the group and person. | request-01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                                                                                                                                                                                                                                                                                       |

### Response

**[T.nilable(Models::Operations::StartWorkspacePersonSearchResponse)](../../models/operations/startworkspacepersonsearchresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |

## run_search

Runs a counted search that was started on the person alone (POST /v1/people/{person_id}/searches), as the group route does. Runs a password or hash search once a person has seen its count. A search still counting answers 409 group_conflict; one already queued, running or finished answers as it is. The body is an empty object. Its estimate counts against the environment's screening_daily_cap. Each run is audited as person.search_run. The investigations scope grants this operation. Explicit evidence.read restrictions override default evidence access. The groups scope is also accepted for existing integrations. The API key selects the workspace and environment.

### Example Usage

<!-- UsageSnippet language="ruby" operationID="runWorkspacePersonSearch" method="post" path="/v1/people/{person_id}/searches/{search_id}/run" -->
```ruby
require 'noresponse'

Models = ::NoResponse::Models
s = ::NoResponse::NoResponseClient.new(
  api_key: ENV.fetch('NORESPONSE_API_KEY', '')
)
res = s.people.run_search(person_id: 'per_01JA2Z8K6Q4V7W9XBCDEFGHJKM', search_id: 'srh_01JA2Z8K6Q4V7W9XBCDEFGHJKM', body: Models::Shared::ScreeningCancelRequest.new)

unless res.nil?
  # handle response
end

```

### Parameters

| Parameter                                                                               | Type                                                                                    | Required                                                                                | Description                                                                             | Example                                                                                 |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `person_id`                                                                             | *::String*                                                                              | :heavy_check_mark:                                                                      | N/A                                                                                     | per_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                          |
| `search_id`                                                                             | *::String*                                                                              | :heavy_check_mark:                                                                      | N/A                                                                                     | srh_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                          |
| `body`                                                                                  | [Models::Shared::ScreeningCancelRequest](../../models/shared/screeningcancelrequest.md) | :heavy_check_mark:                                                                      | N/A                                                                                     |                                                                                         |

### Response

**[T.nilable(Models::Operations::RunWorkspacePersonSearchResponse)](../../models/operations/runworkspacepersonsearchresponse.md)**

### Errors

| Error Type                            | Status Code                           | Content Type                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Models::Errors::BadRequestError       | 400                                   | application/problem+json              |
| Models::Errors::AuthenticationError   | 401                                   | application/problem+json              |
| Models::Errors::PermissionDeniedError | 403                                   | application/problem+json              |
| Models::Errors::NotFoundError         | 404                                   | application/problem+json              |
| Models::Errors::ConflictError         | 409                                   | application/problem+json              |
| Models::Errors::RateLimitError        | 429                                   | application/problem+json              |
| Errors::APIStatusError                | 4XX, 5XX                              | \*/\*                                 |