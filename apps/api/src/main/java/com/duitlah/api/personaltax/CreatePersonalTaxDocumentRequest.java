package com.duitlah.api.personaltax;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

/**
 * Exactly one of {@code receiptId}/{@code storageKey} is expected — see {@link
 * PersonalTaxDocument}.
 */
public record CreatePersonalTaxDocumentRequest(
    @NotNull @Min(2000) @Max(3000) Integer yearOfAssessment,
    @NotNull TaxDocumentType type,
    UUID receiptId,
    String notes) {}
