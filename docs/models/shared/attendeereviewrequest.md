# AttendeeReviewRequest

Records a decision on an attendee.


## Fields

| Field                                                                       | Type                                                                        | Required                                                                    | Description                                                                 | Example                                                                     |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `decision`                                                                  | [Models::Shared::AttendeeDecision](../../models/shared/attendeedecision.md) | :heavy_check_mark:                                                          | N/A                                                                         |                                                                             |
| `note`                                                                      | *T.nilable(::String)*                                                       | :heavy_minus_sign:                                                          | Why, for the venue team and later reviewers.                                | Known to the venue team.                                                    |