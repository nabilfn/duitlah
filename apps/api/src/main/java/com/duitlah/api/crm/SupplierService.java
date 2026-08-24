package com.duitlah.api.crm;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SupplierService {

  private final SupplierRepository suppliers;
  private final SpaceService spaceService;

  public SupplierService(SupplierRepository suppliers, SpaceService spaceService) {
    this.suppliers = suppliers;
    this.spaceService = spaceService;
  }

  @Transactional
  public ContactResponse create(UUID userId, UUID spaceId, UpsertContactRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SUPPLIERS);
    Supplier supplier = new Supplier(spaceId, request.name().trim());
    apply(supplier, request);
    suppliers.save(supplier);
    return ContactResponse.of(supplier);
  }

  public List<ContactResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return suppliers.findBySpaceIdOrderByNameAsc(spaceId).stream()
        .map(ContactResponse::of)
        .toList();
  }

  public ContactResponse get(UUID userId, UUID spaceId, UUID supplierId) {
    spaceService.requireMembership(userId, spaceId);
    return ContactResponse.of(requireOwned(spaceId, supplierId));
  }

  @Transactional
  public ContactResponse update(
      UUID userId, UUID spaceId, UUID supplierId, UpsertContactRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SUPPLIERS);
    Supplier supplier = requireOwned(spaceId, supplierId);
    supplier.setName(request.name().trim());
    apply(supplier, request);
    suppliers.save(supplier);
    return ContactResponse.of(supplier);
  }

  @Transactional
  public void archive(UUID userId, UUID spaceId, UUID supplierId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SUPPLIERS);
    Supplier supplier = requireOwned(spaceId, supplierId);
    supplier.setStatus(ContactStatus.ARCHIVED);
    suppliers.save(supplier);
  }

  /** Public — {@code bizexpenses} needs the real entity to validate ownership. */
  public Supplier requireOwned(UUID spaceId, UUID supplierId) {
    return suppliers
        .findByIdAndSpaceId(supplierId, spaceId)
        .orElseThrow(() -> new NotFoundException("SUPPLIER_NOT_FOUND", "Supplier not found."));
  }

  private static void apply(Supplier supplier, UpsertContactRequest request) {
    supplier.setContactPerson(request.contactPerson());
    supplier.setPhone(request.phone());
    supplier.setEmail(request.email());
    supplier.setBillingAddress(request.billingAddress());
    supplier.setRegistrationNumber(request.registrationNumber());
    supplier.setTin(request.tin());
    supplier.setSstNumber(request.sstNumber());
    if (request.paymentTermsDays() != null) {
      supplier.setPaymentTermsDays(request.paymentTermsDays());
    }
    supplier.setNotes(request.notes());
  }
}
