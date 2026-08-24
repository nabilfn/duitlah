package com.duitlah.api.crm;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomerService {

  private final CustomerRepository customers;
  private final SpaceService spaceService;

  public CustomerService(CustomerRepository customers, SpaceService spaceService) {
    this.customers = customers;
    this.spaceService = spaceService;
  }

  @Transactional
  public ContactResponse create(UUID userId, UUID spaceId, UpsertContactRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_CUSTOMERS);
    Customer customer = new Customer(spaceId, request.name().trim());
    apply(customer, request);
    customers.save(customer);
    return ContactResponse.of(customer);
  }

  public List<ContactResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return customers.findBySpaceIdOrderByNameAsc(spaceId).stream()
        .map(ContactResponse::of)
        .toList();
  }

  public ContactResponse get(UUID userId, UUID spaceId, UUID customerId) {
    spaceService.requireMembership(userId, spaceId);
    return ContactResponse.of(requireOwned(spaceId, customerId));
  }

  @Transactional
  public ContactResponse update(
      UUID userId, UUID spaceId, UUID customerId, UpsertContactRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_CUSTOMERS);
    Customer customer = requireOwned(spaceId, customerId);
    customer.setName(request.name().trim());
    apply(customer, request);
    customers.save(customer);
    return ContactResponse.of(customer);
  }

  @Transactional
  public void archive(UUID userId, UUID spaceId, UUID customerId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_CUSTOMERS);
    Customer customer = requireOwned(spaceId, customerId);
    customer.setStatus(ContactStatus.ARCHIVED);
    customers.save(customer);
  }

  /**
   * Public — {@code sales} needs the real entity (not just the response DTO) to validate ownership.
   */
  public Customer requireOwned(UUID spaceId, UUID customerId) {
    return customers
        .findByIdAndSpaceId(customerId, spaceId)
        .orElseThrow(() -> new NotFoundException("CUSTOMER_NOT_FOUND", "Customer not found."));
  }

  private static void apply(Customer customer, UpsertContactRequest request) {
    customer.setContactPerson(request.contactPerson());
    customer.setPhone(request.phone());
    customer.setEmail(request.email());
    customer.setBillingAddress(request.billingAddress());
    customer.setRegistrationNumber(request.registrationNumber());
    customer.setTin(request.tin());
    customer.setSstNumber(request.sstNumber());
    if (request.paymentTermsDays() != null) {
      customer.setPaymentTermsDays(request.paymentTermsDays());
    }
    customer.setNotes(request.notes());
  }
}
