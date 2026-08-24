package com.duitlah.api.inventory;

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
public class ProductRecipeController {

  private final RecipeCostingService recipeCosting;

  public ProductRecipeController(RecipeCostingService recipeCosting) {
    this.recipeCosting = recipeCosting;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/products/{productId}/recipe")
  @ResponseStatus(HttpStatus.CREATED)
  public RecipeItemResponse addItem(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId,
      @Valid @RequestBody AddRecipeItemRequest request) {
    return recipeCosting.addItem(userId, spaceId, productId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products/{productId}/recipe")
  public List<RecipeItemResponse> listItems(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    return recipeCosting.listItems(userId, spaceId, productId);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/products/{productId}/recipe/{itemId}")
  public void removeItem(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId,
      @PathVariable UUID itemId) {
    recipeCosting.removeItem(userId, spaceId, productId, itemId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products/{productId}/recipe/cost")
  public RecipeCostResponse cost(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    return recipeCosting.cost(userId, spaceId, productId);
  }
}
