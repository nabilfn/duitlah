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
public class CustomerController {

  private final CustomerService customers;

  public CustomerController(CustomerService customers) {
    this.customers = customers;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/customers")
  @ResponseStatus(HttpStatus.CREATED)
  public ContactResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody UpsertContactRequest request) {
    return customers.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/customers")
  public List<ContactResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return customers.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/customers/{customerId}")
  public ContactResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID customerId) {
    return customers.get(userId, spaceId, customerId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/customers/{customerId}")
  public ContactResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID customerId,
      @Valid @RequestBody UpsertContactRequest request) {
    return customers.update(userId, spaceId, customerId, request);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/customers/{customerId}")
  public void archive(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID customerId) {
    customers.archive(userId, spaceId, customerId);
  }
}
