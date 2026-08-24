package com.duitlah.api.receipts;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.bagilah.BillResponse;
import com.duitlah.api.bagilah.BillService;
import com.duitlah.api.bagilah.CreateBillRequest;
import com.duitlah.api.bagilah.CreateReceiptItemRequest;
import com.duitlah.api.bagilah.UpdateBillRequest;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.storage.ObjectStorage;
import com.duitlah.api.subscriptions.SubscriptionService;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Owns the scan-and-review half of Bagilah's receipt pipeline (product spec section 10: upload →
 * OCR → structured items → user verification → Bagilah). Confirming a scan doesn't create any
 * receipt-specific domain rows of its own — it just calls {@link BillService}'s existing public
 * create/addItem/update methods, the same ones a manual "New bill" uses, so a confirmed scan is in
 * every way an ordinary Phase 6/7 bill from that point on.
 */
@Service
public class ReceiptScanService {

  private static final Duration IMAGE_URL_TTL = Duration.ofMinutes(15);
  private static final Set<String> ALLOWED_CONTENT_TYPES =
      Set.of("image/jpeg", "image/png", "image/webp", "image/heic");
  private static final long MAX_IMAGE_BYTES = 10L * 1024 * 1024;

  private final ReceiptScanRepository scans;
  private final ObjectStorage storage;
  private final ReceiptOcrService ocr;
  private final BillService billService;
  private final SubscriptionService subscriptionService;
  private final AuditLogService auditLogService;

  public ReceiptScanService(
      ReceiptScanRepository scans,
      ObjectStorage storage,
      ReceiptOcrService ocr,
      BillService billService,
      SubscriptionService subscriptionService,
      AuditLogService auditLogService) {
    this.scans = scans;
    this.storage = storage;
    this.ocr = ocr;
    this.billService = billService;
    this.subscriptionService = subscriptionService;
    this.auditLogService = auditLogService;
  }

  @Transactional
  public ReceiptScanResponse upload(UUID userId, byte[] imageBytes, String contentType) {
    subscriptionService.requireReceiptScanCapacity(userId);
    if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType)) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "UNSUPPORTED_IMAGE_TYPE",
          "Upload a JPEG, PNG, WEBP, or HEIC photo.");
    }
    if (imageBytes.length == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "EMPTY_IMAGE", "The uploaded file is empty.");
    }
    if (imageBytes.length > MAX_IMAGE_BYTES) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "IMAGE_TOO_LARGE", "Photos must be under 10MB.");
    }
    if (!matchesDeclaredFormat(imageBytes, contentType)) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "IMAGE_CONTENT_MISMATCH",
          "This file's content doesn't match a JPEG, PNG, WEBP, or HEIC photo.");
    }

    String storageKey = "receipts/" + userId + "/" + UUID.randomUUID() + extensionFor(contentType);
    storage.put(storageKey, imageBytes, contentType);

    ReceiptScan scan =
        new ReceiptScan(userId, storageKey, contentType, ocr.getClass().getSimpleName());
    ParsedReceipt parsed = ocr.parse(imageBytes, contentType);
    boolean readAnything =
        parsed.merchant() != null || !parsed.items().isEmpty() || parsed.total() != null;
    scan.setStatus(readAnything ? ScanStatus.PARSED : ScanStatus.FAILED);
    scan.setOverallConfidence(parsed.overallConfidence());
    scan.setParsedResultJson(ParsedReceiptCodec.toJson(parsed));
    if (!readAnything) {
      scan.setErrorMessage("Couldn't read this receipt automatically — enter it manually below.");
    }
    scans.save(scan);
    return toResponse(scan, parsed);
  }

  public ReceiptScanResponse getForUser(UUID userId, UUID scanId) {
    ReceiptScan scan = requireOwnedScan(userId, scanId);
    return toResponse(scan, ParsedReceiptCodec.fromJson(scan.getParsedResultJson()));
  }

  public List<ReceiptScanResponse> listForUser(UUID userId) {
    return scans.findByOwnerUserIdOrderByCreatedAtDesc(userId).stream()
        .map(s -> toResponse(s, ParsedReceiptCodec.fromJson(s.getParsedResultJson())))
        .toList();
  }

  @Transactional
  public BillResponse confirm(UUID userId, UUID scanId, ConfirmReceiptScanRequest request) {
    ReceiptScan scan = requireOwnedScan(userId, scanId);
    if (scan.getStatus() == ScanStatus.CONFIRMED) {
      throw new ConflictException(
          "SCAN_ALREADY_CONFIRMED", "This scan has already been turned into a bill.");
    }

    BillResponse bill =
        billService.create(
            userId,
            new CreateBillRequest(request.merchant(), request.receiptDate(), request.groupId()));
    for (CreateReceiptItemRequest item : request.items()) {
      billService.addItem(userId, bill.id(), item);
    }
    BillResponse updated =
        billService.update(
            userId,
            bill.id(),
            new UpdateBillRequest(
                request.merchant(),
                request.receiptDate(),
                request.tax(),
                request.taxStrategy(),
                request.serviceCharge(),
                request.serviceStrategy(),
                request.discount(),
                request.discountLabel(),
                request.declaredTotal()));

    scan.setBillId(updated.id());
    scan.setStatus(ScanStatus.CONFIRMED);
    scans.save(scan);
    auditLogService.record(
        userId, AuditAction.RECEIPT_EDITED, "ReceiptScan", scanId, Map.of("billId", updated.id()));
    return updated;
  }

  private ReceiptScanResponse toResponse(ReceiptScan scan, ParsedReceipt parsed) {
    String imageUrl = storage.presignedGetUrl(scan.getImageStorageKey(), IMAGE_URL_TTL);
    boolean needsReview =
        scan.getStatus() == ScanStatus.PARSED
            && scan.getOverallConfidence() != null
            && scan.getOverallConfidence() < ParsedReceipt.LOW_CONFIDENCE_THRESHOLD;
    return new ReceiptScanResponse(
        scan.getId(),
        scan.getStatus(),
        scan.getProvider(),
        scan.getOverallConfidence(),
        needsReview,
        parsed,
        imageUrl,
        scan.getErrorMessage(),
        scan.getBillId());
  }

  private ReceiptScan requireOwnedScan(UUID userId, UUID scanId) {
    return scans
        .findByIdAndOwnerUserId(scanId, userId)
        .orElseThrow(() -> new NotFoundException("SCAN_NOT_FOUND", "Scan not found."));
  }

  /**
   * A client-declared {@code Content-Type} header is just a label the client chose -- it proves
   * nothing about what the bytes actually are. Checking the real file signature (magic bytes)
   * closes that gap: something that isn't actually an image can no longer ride in under a spoofed
   * {@code image/jpeg} label, get stored, and later be served back with that same (attacker-chosen)
   * Content-Type via the presigned GET URL.
   */
  private static boolean matchesDeclaredFormat(byte[] bytes, String contentType) {
    return switch (contentType) {
      case "image/jpeg" ->
          bytes.length >= 3
              && (bytes[0] & 0xFF) == 0xFF
              && (bytes[1] & 0xFF) == 0xD8
              && (bytes[2] & 0xFF) == 0xFF;
      case "image/png" ->
          bytes.length >= 8
              && (bytes[0] & 0xFF) == 0x89
              && bytes[1] == 'P'
              && bytes[2] == 'N'
              && bytes[3] == 'G'
              && (bytes[4] & 0xFF) == 0x0D
              && (bytes[5] & 0xFF) == 0x0A
              && (bytes[6] & 0xFF) == 0x1A
              && (bytes[7] & 0xFF) == 0x0A;
      case "image/webp" ->
          bytes.length >= 12
              && bytes[0] == 'R'
              && bytes[1] == 'I'
              && bytes[2] == 'F'
              && bytes[3] == 'F'
              && bytes[8] == 'W'
              && bytes[9] == 'E'
              && bytes[10] == 'B'
              && bytes[11] == 'P';
      case "image/heic" ->
          bytes.length >= 12
              && bytes[4] == 'f'
              && bytes[5] == 't'
              && bytes[6] == 'y'
              && bytes[7] == 'p';
      default -> false;
    };
  }

  private static String extensionFor(String contentType) {
    return switch (contentType) {
      case "image/jpeg" -> ".jpg";
      case "image/png" -> ".png";
      case "image/webp" -> ".webp";
      case "image/heic" -> ".heic";
      default -> "";
    };
  }
}
