package com.duitlah.api.inventory;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InventoryMovementController {

  private final InventoryMovementService movements;

  public InventoryMovementController(InventoryMovementService movements) {
    this.movements = movements;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/products/{productId}/movements")
  @ResponseStatus(HttpStatus.CREATED)
  public MovementResponse record(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId,
      @Valid @RequestBody CreateMovementRequest request) {
    return movements.record(userId, spaceId, productId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products/{productId}/movements")
  public List<MovementResponse> list(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    return movements.list(userId, spaceId, productId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/products/{productId}/valuation")
  public ValuationResponse valuation(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID productId) {
    return movements.valuation(userId, spaceId, productId);
  }
}
