package com.duitlah.api.groups;

import java.time.Instant;
import java.util.UUID;

public record GroupMemberResponse(
    UUID userId, String displayName, String email, GroupMemberRole role, Instant joinedAt) {}
