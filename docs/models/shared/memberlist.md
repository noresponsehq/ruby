# MemberList

GET /v1/workspaces/{workspace_id}/members: the workspace's active members, oldest first, at most 100.


## Fields

| Field                                                             | Type                                                              | Required                                                          | Description                                                       |
| ----------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------- |
| `items`                                                           | T::Array<[Models::Shared::Member](../../models/shared/member.md)> | :heavy_check_mark:                                                | N/A                                                               |