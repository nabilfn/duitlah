package com.duitlah.api.finance;

import java.util.UUID;

public record CategoryResponse(
    UUID id, UUID parentId, CategoryType type, String name, String icon, boolean custom) {

  public static CategoryResponse from(Category category) {
    return new CategoryResponse(
        category.getId(),
        category.getParentId(),
        category.getType(),
        category.getName(),
        category.getIcon(),
        !category.isSystemDefault());
  }
}
