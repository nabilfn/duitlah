package com.duitlah.api.finance;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

public record CreateCategoryRequest(
    @NotBlank @Size(max = 80) String name,
    @NotNull CategoryType type,
    UUID parentId,
    @Size(max = 16) String icon) {}
