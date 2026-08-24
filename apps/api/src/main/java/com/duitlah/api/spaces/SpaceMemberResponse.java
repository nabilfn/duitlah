package com.duitlah.api.spaces;

import java.util.UUID;

public record SpaceMemberResponse(
    UUID id, UUID userId, String displayName, String email, SpaceRole role, MemberStatus status) {}
