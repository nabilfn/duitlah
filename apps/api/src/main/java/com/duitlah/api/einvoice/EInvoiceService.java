package com.duitlah.api.einvoice;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.sales.Invoice;
import com.duitlah.api.sales.InvoiceService;
import com.duitlah.api.sales.InvoiceStatus;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Spec section 56's workflow, split into two explicit user actions — {@code prepare} (eligibility +
 * TIN validation, no external call) and {@code submit} (the real, consequential call to LHDN) — see
 * package-info for why.
 */
@Service
public class EInvoiceService {

  private static final Duration CANCELLATION_WINDOW = Duration.ofHours(72);

  private final EInvoiceDocumentRepository documents;
  private final EInvoiceProviderLogRepository providerLogs;
  private final EInvoiceProviderLogRecorder providerLogRecorder;
  private final EInvoiceProvider provider;
  private final EInvoicePayloadBuilder payloadBuilder;
  private final InvoiceService invoiceService;
  private final SpaceService spaceService;
  private final AuditLogService auditLogService;

  public EInvoiceService(
      EInvoiceDocumentRepository documents,
      EInvoiceProviderLogRepository providerLogs,
      EInvoiceProviderLogRecorder providerLogRecorder,
      EInvoiceProvider provider,
      EInvoicePayloadBuilder payloadBuilder,
      InvoiceService invoiceService,
      SpaceService spaceService,
      AuditLogService auditLogService) {
    this.documents = documents;
    this.providerLogs = providerLogs;
    this.providerLogRecorder = providerLogRecorder;
    this.provider = provider;
    this.payloadBuilder = payloadBuilder;
    this.invoiceService = invoiceService;
    this.spaceService = spaceService;
    this.auditLogService = auditLogService;
  }

  @Transactional
  public EInvoiceDocumentResponse prepare(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    Invoice invoice = invoiceService.requireOwned(spaceId, invoiceId);
    if (invoice.getStatus() != InvoiceStatus.SENT) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "INVOICE_NOT_ISSUED",
          "Only an issued invoice can be submitted as an e-Invoice.");
    }
    payloadBuilder.build(spaceId, invoice);

    EInvoiceDocument doc = documents.findByInvoiceIdAndSpaceId(invoiceId, spaceId).orElse(null);
    if (doc == null) {
      doc = new EInvoiceDocument(spaceId, invoiceId, userId);
      documents.save(doc);
    } else if (doc.getStatus() != EInvoiceStatus.READY) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_ALREADY_IN_PROGRESS",
          "This invoice already has an e-Invoice document with status " + doc.getStatus() + ".");
    }
    return EInvoiceDocumentResponse.of(doc);
  }

  @Transactional
  public EInvoiceDocumentResponse submit(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    EInvoiceDocument doc = requireDocument(spaceId, invoiceId);
    if (doc.getStatus() != EInvoiceStatus.READY) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_NOT_READY",
          "Prepare this invoice's e-Invoice before submitting.");
    }
    requireAvailable(doc, EInvoiceOperation.SUBMIT);

    Invoice invoice = invoiceService.requireOwned(spaceId, invoiceId);
    EInvoicePayload payload = payloadBuilder.build(spaceId, invoice);
    SubmissionResult result = provider.submit(payload);
    logAttempt(
        doc.getId(),
        EInvoiceOperation.SUBMIT,
        result.accepted(),
        result.accepted() ? result.submissionUid() : result.errorMessage());
    if (!result.accepted()) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_SUBMISSION_REJECTED",
          result.errorMessage() != null
              ? result.errorMessage()
              : "MyInvois rejected the submission.");
    }
    doc.setStatus(EInvoiceStatus.SUBMITTED);
    doc.setSubmissionUid(result.submissionUid());
    doc.setDocumentUuid(result.documentUuid());
    documents.save(doc);
    auditLogService.record(
        userId,
        AuditAction.EINVOICE_SUBMITTED,
        "EInvoiceDocument",
        doc.getId(),
        Map.of("invoiceId", invoiceId));
    return EInvoiceDocumentResponse.of(doc);
  }

  @Transactional
  public EInvoiceDocumentResponse syncStatus(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    EInvoiceDocument doc = requireDocument(spaceId, invoiceId);
    if (doc.getStatus() != EInvoiceStatus.SUBMITTED) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_NOT_SUBMITTED",
          "This e-Invoice hasn't been submitted yet.");
    }
    requireAvailable(doc, EInvoiceOperation.STATUS_CHECK);

    DocumentStatusResult result = provider.checkStatus(doc.getDocumentUuid());
    logAttempt(doc.getId(), EInvoiceOperation.STATUS_CHECK, true, result.status().name());
    doc.setStatus(result.status());
    if (result.status() == EInvoiceStatus.VALID) {
      doc.setValidatedAt(result.validatedAt());
      doc.setLongId(result.longId());
      auditLogService.record(
          userId, AuditAction.EINVOICE_VALIDATED, "EInvoiceDocument", doc.getId(), Map.of());
    } else if (result.status() == EInvoiceStatus.INVALID) {
      doc.setInvalidReason(result.invalidReason());
      auditLogService.record(
          userId,
          AuditAction.EINVOICE_INVALID,
          "EInvoiceDocument",
          doc.getId(),
          Map.of("reason", String.valueOf(result.invalidReason())));
    }
    documents.save(doc);
    return EInvoiceDocumentResponse.of(doc);
  }

  @Transactional
  public EInvoiceDocumentResponse cancel(
      UUID userId, UUID spaceId, UUID invoiceId, CancelEInvoiceRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    EInvoiceDocument doc = requireDocument(spaceId, invoiceId);
    requireWithinWindow(doc);
    requireAvailable(doc, EInvoiceOperation.CANCEL);

    provider.cancel(doc.getDocumentUuid(), request.reason());
    logAttempt(doc.getId(), EInvoiceOperation.CANCEL, true, request.reason());
    doc.setStatus(EInvoiceStatus.CANCELLED);
    doc.setCancelledAt(Instant.now());
    doc.setCancellationReason(request.reason());
    documents.save(doc);
    auditLogService.record(
        userId,
        AuditAction.EINVOICE_CANCELLED,
        "EInvoiceDocument",
        doc.getId(),
        Map.of("reason", request.reason()));
    return EInvoiceDocumentResponse.of(doc);
  }

  @Transactional
  public EInvoiceDocumentResponse reject(
      UUID userId, UUID spaceId, UUID invoiceId, RejectEInvoiceRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    EInvoiceDocument doc = requireDocument(spaceId, invoiceId);
    requireWithinWindow(doc);
    requireAvailable(doc, EInvoiceOperation.REJECT);

    provider.reject(doc.getDocumentUuid(), request.reason());
    logAttempt(doc.getId(), EInvoiceOperation.REJECT, true, request.reason());
    doc.setStatus(EInvoiceStatus.REJECTED);
    doc.setRejectedAt(Instant.now());
    doc.setRejectionReason(request.reason());
    documents.save(doc);
    auditLogService.record(
        userId,
        AuditAction.EINVOICE_REJECTED,
        "EInvoiceDocument",
        doc.getId(),
        Map.of("reason", request.reason()));
    return EInvoiceDocumentResponse.of(doc);
  }

  public EInvoiceDocumentResponse get(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requireMembership(userId, spaceId);
    return EInvoiceDocumentResponse.of(requireDocument(spaceId, invoiceId));
  }

  public List<EInvoiceProviderLogResponse> providerLogs(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requireMembership(userId, spaceId);
    EInvoiceDocument doc = requireDocument(spaceId, invoiceId);
    return providerLogs.findByEinvoiceDocumentIdOrderByCreatedAtDesc(doc.getId()).stream()
        .map(EInvoiceProviderLogResponse::of)
        .toList();
  }

  private void requireWithinWindow(EInvoiceDocument doc) {
    if (doc.getStatus() != EInvoiceStatus.VALID) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_NOT_VALID",
          "Only a validated e-Invoice can be cancelled or rejected.");
    }
    if (doc.getValidatedAt() == null
        || doc.getValidatedAt().plus(CANCELLATION_WINDOW).isBefore(Instant.now())) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "EINVOICE_WINDOW_EXPIRED",
          "The 72-hour cancellation/rejection window has passed; issue a credit note instead.");
    }
  }

  private void requireAvailable(EInvoiceDocument doc, EInvoiceOperation operation) {
    if (!provider.isAvailable()) {
      logAttempt(doc.getId(), operation, false, "Provider unavailable");
      throw new ApiException(
          HttpStatus.SERVICE_UNAVAILABLE,
          "EINVOICE_PROVIDER_UNAVAILABLE",
          "MyInvois isn't configured for this environment yet.");
    }
  }

  private EInvoiceDocument requireDocument(UUID spaceId, UUID invoiceId) {
    return documents
        .findByInvoiceIdAndSpaceId(invoiceId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException(
                    "EINVOICE_DOCUMENT_NOT_FOUND",
                    "No e-Invoice document exists for this invoice yet."));
  }

  private void logAttempt(
      UUID documentId, EInvoiceOperation operation, boolean success, String detail) {
    providerLogRecorder.record(documentId, operation, provider.providerName(), success, detail);
  }
}
