package com.duitlah.api.groups;

import java.util.UUID;

public record GroupResponse(
    UUID id,
    String name,
    GroupType type,
    GroupMemberRole yourRole,
    int memberCount,
    boolean archived) {

  public static GroupResponse of(Group group, GroupMemberRole yourRole, int memberCount) {
    return new GroupResponse(
        group.getId(), group.getName(), group.getType(), yourRole, memberCount, group.isArchived());
  }
}
