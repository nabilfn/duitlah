package com.duitlah.api.crm;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

/**
 * Shared shape for both {@link Customer} and {@link Supplier} — see package-info for why the
 * entities themselves stay separate even though today's request/response fields are identical.
 */
public record UpsertContactRequest(
    @NotBlank String name,
    String contactPerson,
    String phone,
    String email,
    String billingAddress,
    String registrationNumber,
    String tin,
    String sstNumber,
    @Min(0) Integer paymentTermsDays,
    String notes) {}
