package com.duitlah.api.catalog;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ProductController {

  private final ProductService products;

  public ProductController(ProductService products) {
    this.products = products;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/products")
  @ResponseStatus(HttpStatus.CREATED)
  public ProductResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateProductRequest request) {
    return products.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products")
  public List<ProductResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return products.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products/{productId}")
  public ProductResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    return products.get(userId, spaceId, productId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/products/{productId}")
  public ProductResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId,
      @Valid @RequestBody CreateProductRequest request) {
    return products.update(userId, spaceId, productId, request);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/products/{productId}")
  public void archive(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    products.archive(userId, spaceId, productId);
  }
}
