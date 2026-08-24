package com.duitlah.api.crm;

import java.util.UUID;

public record ContactResponse(
    UUID id,
    String name,
    String contactPerson,
    String phone,
    String email,
    String billingAddress,
    String registrationNumber,
    String tin,
    String sstNumber,
    int paymentTermsDays,
    String notes,
    ContactStatus status) {

  static ContactResponse of(Customer c) {
    return new ContactResponse(
        c.getId(),
        c.getName(),
        c.getContactPerson(),
        c.getPhone(),
        c.getEmail(),
        c.getBillingAddress(),
        c.getRegistrationNumber(),
        c.getTin(),
        c.getSstNumber(),
        c.getPaymentTermsDays(),
        c.getNotes(),
        c.getStatus());
  }

  static ContactResponse of(Supplier s) {
    return new ContactResponse(
        s.getId(),
        s.getName(),
        s.getContactPerson(),
        s.getPhone(),
        s.getEmail(),
        s.getBillingAddress(),
        s.getRegistrationNumber(),
        s.getTin(),
        s.getSstNumber(),
        s.getPaymentTermsDays(),
        s.getNotes(),
        s.getStatus());
  }
}
