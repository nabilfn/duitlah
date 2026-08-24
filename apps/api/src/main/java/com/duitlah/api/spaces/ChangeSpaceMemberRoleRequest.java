package com.duitlah.api.spaces;

import jakarta.validation.constraints.NotNull;

public record ChangeSpaceMemberRoleRequest(@NotNull SpaceRole role) {}
