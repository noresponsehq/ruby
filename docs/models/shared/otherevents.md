# OtherEvents

Where else in the environment the attendee appears, read live from those events: deleting one removes it here.


## Fields

| Field                                                                              | Type                                                                               | Required                                                                           | Description                                                                        |
| ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `total`                                                                            | *::Integer*                                                                        | :heavy_check_mark:                                                                 | How many attendees of other events match, of which items lists the 20 most recent. |
| `items`                                                                            | T::Array<[Models::Shared::OtherEvent](../../models/shared/otherevent.md)>          | :heavy_check_mark:                                                                 | The 20 attendees of the most recent other events, newest event first.              |