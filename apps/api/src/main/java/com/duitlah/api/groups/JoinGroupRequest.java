package com.duitlah.api.groups;

import jakarta.validation.constraints.NotBlank;

public record JoinGroupRequest(@NotBlank String token) {}
