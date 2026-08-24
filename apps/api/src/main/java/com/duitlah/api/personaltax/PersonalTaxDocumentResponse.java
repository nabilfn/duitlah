package com.duitlah.api.personaltax;

import java.util.UUID;

public record PersonalTaxDocumentResponse(
    UUID id,
    int yearOfAssessment,
    TaxDocumentType type,
    UUID receiptId,
    boolean hasFile,
    String notes) {

  public static PersonalTaxDocumentResponse from(PersonalTaxDocument document) {
    return new PersonalTaxDocumentResponse(
        document.getId(),
        document.getYearOfAssessment(),
        document.getType(),
        document.getReceiptId(),
        document.getStorageKey() != null,
        document.getNotes());
  }
}
