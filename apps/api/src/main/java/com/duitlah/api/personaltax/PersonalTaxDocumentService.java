package com.duitlah.api.personaltax;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.storage.ObjectStorage;
import com.duitlah.api.receipts.ReceiptRepository;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PersonalTaxDocumentService {

  private static final long MAX_FILE_BYTES = 10L * 1024 * 1024;

  private final PersonalTaxDocumentRepository documents;
  private final SpaceService spaceService;
  private final ObjectStorage storage;
  private final ReceiptRepository receipts;

  public PersonalTaxDocumentService(
      PersonalTaxDocumentRepository documents,
      SpaceService spaceService,
      ObjectStorage storage,
      ReceiptRepository receipts) {
    this.documents = documents;
    this.spaceService = spaceService;
    this.storage = storage;
    this.receipts = receipts;
  }

  /** Links an existing Receipt Vault entry — no new file, reuses its OCR/storage. */
  @Transactional
  public PersonalTaxDocumentResponse linkReceipt(
      UUID userId, CreatePersonalTaxDocumentRequest request) {
    if (request.receiptId() == null) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "RECEIPT_ID_REQUIRED", "receiptId is required.");
    }
    receipts
        .findByIdAndUserId(request.receiptId(), userId)
        .orElseThrow(() -> new NotFoundException("RECEIPT_NOT_FOUND", "Receipt not found."));
    PersonalTaxDocument document =
        new PersonalTaxDocument(
            userId,
            spaceService.personalSpaceIdFor(userId),
            request.yearOfAssessment(),
            request.type(),
            request.receiptId(),
            null);
    document.setNotes(request.notes());
    documents.save(document);
    return PersonalTaxDocumentResponse.from(document);
  }

  /**
   * Direct upload for document types that aren't naturally receipts (an EA form, an EPF statement).
   */
  @Transactional
  public PersonalTaxDocumentResponse upload(
      UUID userId,
      int yearOfAssessment,
      TaxDocumentType type,
      byte[] fileBytes,
      String contentType,
      String notes) {
    if (fileBytes.length == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "EMPTY_FILE", "The uploaded file is empty.");
    }
    if (fileBytes.length > MAX_FILE_BYTES) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "FILE_TOO_LARGE", "Documents must be under 10MB.");
    }
    String storageKey = "tax-documents/" + userId + "/" + UUID.randomUUID();
    storage.put(
        storageKey, fileBytes, contentType != null ? contentType : "application/octet-stream");

    PersonalTaxDocument document =
        new PersonalTaxDocument(
            userId,
            spaceService.personalSpaceIdFor(userId),
            yearOfAssessment,
            type,
            null,
            storageKey);
    document.setNotes(notes);
    documents.save(document);
    return PersonalTaxDocumentResponse.from(document);
  }

  public List<PersonalTaxDocumentResponse> list(UUID userId, int yearOfAssessment) {
    return documents.findByUserIdAndYearOfAssessment(userId, yearOfAssessment).stream()
        .map(PersonalTaxDocumentResponse::from)
        .toList();
  }

  public boolean hasDocumentOfType(UUID userId, int yearOfAssessment, TaxDocumentType type) {
    return documents.existsByUserIdAndYearOfAssessmentAndType(userId, yearOfAssessment, type);
  }

  @Transactional
  public void delete(UUID userId, UUID documentId) {
    PersonalTaxDocument document =
        documents
            .findByIdAndUserId(documentId, userId)
            .orElseThrow(
                () -> new NotFoundException("TAX_DOCUMENT_NOT_FOUND", "Document not found."));
    documents.delete(document);
  }
}
