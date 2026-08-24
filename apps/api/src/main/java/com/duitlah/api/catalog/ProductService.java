package com.duitlah.api.catalog;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProductService {

  private final ProductRepository products;
  private final SpaceService spaceService;

  public ProductService(ProductRepository products, SpaceService spaceService) {
    this.products = products;
    this.spaceService = spaceService;
  }

  @Transactional
  public ProductResponse create(UUID userId, UUID spaceId, CreateProductRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product =
        new Product(spaceId, request.name().trim(), request.type(), request.unitPrice());
    product.setSku(request.sku());
    if (request.unit() != null && !request.unit().isBlank()) {
      product.setUnit(request.unit().trim());
    }
    product.setDescription(request.description());
    product.setCost(request.cost());
    product.setTaxClassification(request.taxClassificationOrDefault());
    product.setTrackInventory(request.trackInventoryOrFalse());
    product.setReorderPoint(request.reorderPoint());
    products.save(product);
    return ProductResponse.of(product);
  }

  public List<ProductResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return products.findBySpaceIdOrderByNameAsc(spaceId).stream().map(ProductResponse::of).toList();
  }

  public ProductResponse get(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requireMembership(userId, spaceId);
    return ProductResponse.of(requireOwned(spaceId, productId));
  }

  @Transactional
  public ProductResponse update(
      UUID userId, UUID spaceId, UUID productId, CreateProductRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product = requireOwned(spaceId, productId);
    product.setName(request.name().trim());
    product.setSku(request.sku());
    product.setType(request.type());
    product.setUnitPrice(request.unitPrice());
    if (request.unit() != null && !request.unit().isBlank()) {
      product.setUnit(request.unit().trim());
    }
    product.setDescription(request.description());
    product.setCost(request.cost());
    product.setTaxClassification(request.taxClassificationOrDefault());
    product.setTrackInventory(request.trackInventoryOrFalse());
    product.setReorderPoint(request.reorderPoint());
    products.save(product);
    return ProductResponse.of(product);
  }

  @Transactional
  public void archive(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product = requireOwned(spaceId, productId);
    product.setActive(false);
    products.save(product);
  }

  /** Public — {@code sales} needs the real entity to validate a line item's product reference. */
  public Product requireOwned(UUID spaceId, UUID productId) {
    return products
        .findByIdAndSpaceId(productId, spaceId)
        .orElseThrow(() -> new NotFoundException("PRODUCT_NOT_FOUND", "Product not found."));
  }

  /** System-use only, for {@code inventory.LowStockAlertScheduler} — no acting-user context. */
  public List<Product> listTrackedWithReorderPoint(UUID spaceId) {
    return products.findBySpaceIdAndTrackInventoryTrueAndReorderPointIsNotNull(spaceId);
  }

  /** For {@code inventory.InventoryReportService}'s stock valuation report. */
  public List<Product> listTracked(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return products.findBySpaceIdAndTrackInventoryTrueOrderByNameAsc(spaceId);
  }

  /** System-use only, for {@code inventory.LowStockAlertScheduler}'s notify-once-per-dip dedup. */
  @Transactional
  public void markLowStockNotifiedAt(UUID productId, java.time.Instant notifiedAt) {
    products
        .findById(productId)
        .ifPresent(
            p -> {
              p.setLowStockNotifiedAt(notifiedAt);
              products.save(p);
            });
  }
}
