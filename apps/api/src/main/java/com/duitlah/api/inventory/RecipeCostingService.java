package com.duitlah.api.inventory;

import com.duitlah.api.catalog.Product;
import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Ingredient/recipe costing (spec section 49) — deliberately optional and one level deep, not
 * mandatory: a product with no {@link ProductRecipeItem} rows simply has no recipe cost to report,
 * and this never blocks any other product operation. An ingredient's own unit cost is its current
 * Weighted Average Cost if it's tracked in inventory, or its plain reference {@code cost} field
 * otherwise (e.g. a non-tracked ingredient bought in bulk and estimated by the user).
 */
@Service
public class RecipeCostingService {

  private final ProductRecipeItemRepository items;
  private final ProductService productService;
  private final InventoryValuationService valuationService;
  private final SpaceService spaceService;

  public RecipeCostingService(
      ProductRecipeItemRepository items,
      ProductService productService,
      InventoryValuationService valuationService,
      SpaceService spaceService) {
    this.items = items;
    this.productService = productService;
    this.valuationService = valuationService;
    this.spaceService = spaceService;
  }

  @Transactional
  public RecipeItemResponse addItem(
      UUID userId, UUID spaceId, UUID productId, AddRecipeItemRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product = productService.requireOwned(spaceId, productId);
    if (product.getId().equals(request.ingredientProductId())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "PRODUCT_CANNOT_BE_ITS_OWN_INGREDIENT",
          "A product cannot be its own ingredient.");
    }
    Product ingredient = productService.requireOwned(spaceId, request.ingredientProductId());
    if (items.existsByProductIdAndIngredientProductId(product.getId(), ingredient.getId())) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "RECIPE_ITEM_ALREADY_EXISTS",
          "This ingredient is already part of the recipe.");
    }
    ProductRecipeItem item =
        new ProductRecipeItem(product.getId(), ingredient.getId(), request.quantityPerUnit());
    items.save(item);
    return toResponse(item, ingredient);
  }

  public List<RecipeItemResponse> listItems(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requireMembership(userId, spaceId);
    Product product = productService.requireOwned(spaceId, productId);
    return items.findByProductId(product.getId()).stream()
        .map(
            item ->
                toResponse(
                    item, productService.requireOwned(spaceId, item.getIngredientProductId())))
        .toList();
  }

  @Transactional
  public void removeItem(UUID userId, UUID spaceId, UUID productId, UUID itemId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product = productService.requireOwned(spaceId, productId);
    ProductRecipeItem item =
        items
            .findByIdAndProductId(itemId, product.getId())
            .orElseThrow(
                () -> new NotFoundException("RECIPE_ITEM_NOT_FOUND", "Recipe item not found."));
    items.delete(item);
  }

  public RecipeCostResponse cost(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requireMembership(userId, spaceId);
    Product product = productService.requireOwned(spaceId, productId);
    List<RecipeItemResponse> lineItems = listItems(userId, spaceId, productId);
    BigDecimal unitCost =
        lineItems.stream()
            .map(RecipeItemResponse::lineCost)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal sellingPrice = product.getUnitPrice();
    BigDecimal grossMargin = sellingPrice.subtract(unitCost);
    BigDecimal grossMarginPercent =
        sellingPrice.signum() == 0
            ? BigDecimal.ZERO
            : grossMargin
                .multiply(BigDecimal.valueOf(100))
                .divide(sellingPrice, 2, RoundingMode.HALF_UP);
    return new RecipeCostResponse(
        product.getId(), lineItems, unitCost, sellingPrice, grossMargin, grossMarginPercent);
  }

  private RecipeItemResponse toResponse(ProductRecipeItem item, Product ingredient) {
    BigDecimal ingredientUnitCost =
        ingredient.isTrackInventory()
            ? valuationService.compute(ingredient.getId()).weightedAverageCost()
            : ingredient.getCost() != null ? ingredient.getCost() : BigDecimal.ZERO;
    BigDecimal lineCost = item.getQuantityPerUnit().multiply(ingredientUnitCost);
    return new RecipeItemResponse(
        item.getId(),
        ingredient.getId(),
        ingredient.getName(),
        item.getQuantityPerUnit(),
        ingredientUnitCost,
        lineCost);
  }
}
