# AttendeeReport

Everything known about one attendee.


## Fields

| Field                                                                             | Type                                                                              | Required                                                                          | Description                                                                       |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `attendee`                                                                        | [Models::Shared::Attendee](../../models/shared/attendee.md)                       | :heavy_check_mark:                                                                | An attendee and where their screening and review stand.                           |
| `profiles`                                                                        | T::Array<[Models::Shared::Profile](../../models/shared/profile.md)>               | :heavy_check_mark:                                                                | The accounts the screening matched, with how each was matched.                    |
| `findings`                                                                        | T::Array<[Models::Shared::Finding](../../models/shared/finding.md)>               | :heavy_check_mark:                                                                | What the screening flagged, with its evidence.                                    |
| `reviews`                                                                         | T::Array<[Models::Shared::AttendeeReview](../../models/shared/attendeereview.md)> | :heavy_check_mark:                                                                | Every recorded decision, oldest first.                                            |