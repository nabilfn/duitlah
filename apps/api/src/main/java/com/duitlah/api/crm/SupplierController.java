package com.duitlah.api.crm;

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
public class SupplierController {

  private final SupplierService suppliers;

  public SupplierController(SupplierService suppliers) {
    this.suppliers = suppliers;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/suppliers")
  @ResponseStatus(HttpStatus.CREATED)
  public ContactResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody UpsertContactRequest request) {
    return suppliers.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/suppliers")
  public List<ContactResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return suppliers.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/suppliers/{supplierId}")
  public ContactResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID supplierId) {
    return suppliers.get(userId, spaceId, supplierId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/suppliers/{supplierId}")
  public ContactResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID supplierId,
      @Valid @RequestBody UpsertContactRequest request) {
    return suppliers.update(userId, spaceId, supplierId, request);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/suppliers/{supplierId}")
  public void archive(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID supplierId) {
    suppliers.archive(userId, spaceId, supplierId);
  }
}
