package com.duitlah.api.groups;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateGroupRequest(
    @NotBlank @Size(max = 120) String name, @NotNull GroupType type, boolean archived) {}
