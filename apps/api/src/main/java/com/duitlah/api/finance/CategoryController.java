package com.duitlah.api.finance;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CategoryController {

  private final CategoryService categoryService;

  public CategoryController(CategoryService categoryService) {
    this.categoryService = categoryService;
  }

  @GetMapping("/api/v1/categories")
  public List<CategoryResponse> list(@AuthenticationPrincipal UUID userId) {
    return categoryService.listForUser(userId);
  }

  @PostMapping("/api/v1/categories")
  @ResponseStatus(HttpStatus.CREATED)
  public CategoryResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateCategoryRequest request) {
    return categoryService.create(userId, request);
  }

  @DeleteMapping("/api/v1/categories/{categoryId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID categoryId) {
    categoryService.delete(userId, categoryId);
  }
}
