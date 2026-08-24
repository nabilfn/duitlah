package com.duitlah.api.finance;

import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.common.error.NotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CategoryService {

  private final CategoryRepository categories;

  public CategoryService(CategoryRepository categories) {
    this.categories = categories;
  }

  public List<CategoryResponse> listForUser(UUID userId) {
    return categories.findByUserIdIsNullOrUserId(userId).stream()
        .map(CategoryResponse::from)
        .toList();
  }

  /** Validates a category is usable by this user for a transaction of the given type. */
  public Category requireUsable(UUID userId, UUID categoryId, CategoryType type) {
    Category category =
        categories
            .findById(categoryId)
            .filter(c -> c.isSystemDefault() || userId.equals(c.getUserId()))
            .orElseThrow(() -> new NotFoundException("CATEGORY_NOT_FOUND", "Category not found."));
    if (category.getType() != type) {
      throw new ForbiddenException(
          "CATEGORY_TYPE_MISMATCH", "This category can't be used for a transaction of this type.");
    }
    return category;
  }

  /**
   * The category id(s) a budget on this category should aggregate spending across: itself if it's a
   * leaf, or itself plus every child if it's a parent — a transaction is only ever tagged to a leaf
   * category, so a budget on a parent (e.g. "Food") would otherwise always show RM0 spent.
   */
  public List<UUID> expandToSelfAndChildren(Category category) {
    if (category.getParentId() != null) {
      return List.of(category.getId());
    }
    List<UUID> ids = new ArrayList<>();
    ids.add(category.getId());
    categories.findByParentId(category.getId()).forEach(child -> ids.add(child.getId()));
    return ids;
  }

  @Transactional
  public CategoryResponse create(UUID userId, CreateCategoryRequest request) {
    if (request.parentId() != null) {
      Category parent =
          categories
              .findById(request.parentId())
              .filter(c -> c.isSystemDefault() || userId.equals(c.getUserId()))
              .orElseThrow(
                  () ->
                      new NotFoundException(
                          "PARENT_CATEGORY_NOT_FOUND", "Parent category not found."));
      if (parent.getParentId() != null) {
        throw new ForbiddenException(
            "CATEGORY_TOO_DEEP", "A category can only be nested one level under a parent.");
      }
      if (parent.getType() != request.type()) {
        throw new ForbiddenException(
            "CATEGORY_TYPE_MISMATCH", "A category must have the same type as its parent.");
      }
    }

    Category category =
        new Category(userId, request.parentId(), request.type(), request.name(), request.icon());
    categories.save(category);
    return CategoryResponse.from(category);
  }

  @Transactional
  public void delete(UUID userId, UUID categoryId) {
    Category category = requireOwnedCustomCategory(userId, categoryId);
    categories.delete(category);
  }

  private Category requireOwnedCustomCategory(UUID userId, UUID categoryId) {
    Category category =
        categories
            .findById(categoryId)
            .orElseThrow(() -> new NotFoundException("CATEGORY_NOT_FOUND", "Category not found."));
    if (category.isSystemDefault()) {
      throw new ForbiddenException(
          "CANNOT_MODIFY_DEFAULT_CATEGORY", "Default categories can't be changed.");
    }
    if (!userId.equals(category.getUserId())) {
      throw new NotFoundException("CATEGORY_NOT_FOUND", "Category not found.");
    }
    return category;
  }
}
