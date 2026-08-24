package com.duitlah.api.receipts;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.autotrack.CandidateSourceType;
import com.duitlah.api.autotrack.TransactionCandidateService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.storage.ObjectStorage;
import com.duitlah.api.personaltax.TaxReliefCandidateService;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionRepository;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The Receipt Vault (spec section 15) — a receipt that stands on its own rather than existing only
 * as a step inside the Bagilah scan-and-confirm flow. It reuses the exact same {@link
 * ReceiptOcrService} {@link ReceiptScanService} does (spec section 14: "do not duplicate the OCR
 * engine") — the only new part is what happens to the result afterward: it's stored as its own
 * searchable, taggable row instead of being folded straight into a bill.
 */
@Service
public class ReceiptVaultService {

  private static final Duration IMAGE_URL_TTL = Duration.ofMinutes(15);
  private static final int DATE_WINDOW_DAYS = 5;
  private static final BigDecimal AMOUNT_TOLERANCE = new BigDecimal("1.00");
  private static final Set<String> ALLOWED_CONTENT_TYPES =
      Set.of("image/jpeg", "image/png", "image/webp", "image/heic");
  private static final long MAX_IMAGE_BYTES = 10L * 1024 * 1024;

  private final ReceiptRepository receipts;
  private final ObjectStorage storage;
  private final ReceiptOcrService ocr;
  private final SpaceService spaceService;
  private final TransactionCandidateService candidateService;
  private final TransactionRepository transactions;
  private final AuditLogService auditLogService;
  private final TaxReliefCandidateService taxReliefCandidateService;

  public ReceiptVaultService(
      ReceiptRepository receipts,
      ObjectStorage storage,
      ReceiptOcrService ocr,
      SpaceService spaceService,
      TransactionCandidateService candidateService,
      TransactionRepository transactions,
      AuditLogService auditLogService,
      TaxReliefCandidateService taxReliefCandidateService) {
    this.receipts = receipts;
    this.storage = storage;
    this.ocr = ocr;
    this.spaceService = spaceService;
    this.candidateService = candidateService;
    this.transactions = transactions;
    this.auditLogService = auditLogService;
    this.taxReliefCandidateService = taxReliefCandidateService;
  }

  @Transactional
  public ReceiptResponse upload(
      UUID userId,
      byte[] imageBytes,
      String contentType,
      ReceiptPurpose purpose,
      String folder,
      List<String> tags) {
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

    String storageKey =
        "receipts-vault/" + userId + "/" + UUID.randomUUID() + extensionFor(contentType);
    storage.put(storageKey, imageBytes, contentType);

    UUID spaceId = spaceService.personalSpaceIdFor(userId);
    Receipt receipt = new Receipt(userId, spaceId, storageKey, contentType, purpose);
    receipt.setFolder(folder);
    receipt.setTags(tags != null ? tags.toArray(new String[0]) : new String[0]);

    ParsedReceipt parsed = ocr.parse(imageBytes, contentType);
    boolean readAnything = parsed.merchant() != null || parsed.total() != null;
    receipt.setOcrStatus(readAnything ? VaultOcrStatus.PARSED : VaultOcrStatus.FAILED);
    receipt.setMerchant(parsed.merchant());
    receipt.setReceiptDate(parsed.receiptDate());
    receipt.setTotalAmount(parsed.total());
    receipt.setOverallConfidence(parsed.overallConfidence());
    receipts.save(receipt);

    if (parsed.total() != null
        && (purpose == ReceiptPurpose.PERSONAL_EXPENSE
            || purpose == ReceiptPurpose.BUSINESS_EXPENSE)) {
      candidateService.create(
          userId,
          spaceId,
          CandidateSourceType.RECEIPT_OCR,
          receipt.getId(),
          null,
          parsed.total(),
          "MYR",
          parsed.merchant(),
          parsed.receiptDate() != null ? parsed.receiptDate() : LocalDate.now(),
          TransactionDirection.OUT,
          null,
          BigDecimal.valueOf(parsed.overallConfidence()));
    }

    if (parsed.total() != null && purpose == ReceiptPurpose.TAX_EVIDENCE) {
      LocalDate evidenceDate =
          parsed.receiptDate() != null ? parsed.receiptDate() : LocalDate.now();
      taxReliefCandidateService.createFromReceipt(
          userId, receipt.getId(), evidenceDate.getYear(), parsed.total());
    }

    return toResponse(receipt);
  }

  public List<ReceiptResponse> search(UUID userId, String folder, String merchant) {
    String merchantPattern = merchant != null ? "%" + merchant.toLowerCase() + "%" : null;
    return receipts.search(userId, folder, merchantPattern).stream().map(this::toResponse).toList();
  }

  public ReceiptResponse get(UUID userId, UUID receiptId) {
    return toResponse(requireOwned(userId, receiptId));
  }

  @Transactional
  public ReceiptResponse attachToTransaction(UUID userId, UUID receiptId, UUID transactionId) {
    Receipt receipt = requireOwned(userId, receiptId);
    transactions
        .findByIdAndUserId(transactionId, userId)
        .orElseThrow(
            () -> new NotFoundException("TRANSACTION_NOT_FOUND", "Transaction not found."));
    receipt.setLinkedTransactionId(transactionId);
    receipts.save(receipt);
    auditLogService.record(
        userId,
        AuditAction.RECEIPT_EDITED,
        "Receipt",
        receiptId,
        Map.of("linkedTransactionId", transactionId));
    return toResponse(receipt);
  }

  /**
   * "Receipt automation" (V2 Phase 13) — suggests, but never auto-links, an existing expense
   * transaction that could correspond to this receipt (same "advisory only, a human always
   * confirms" discipline as {@code autotrack.TransactionCandidateService}). Same deterministic
   * EXACT/PROBABLE tiers as {@code reconciliation.MatchingService.suggestMatches} — same amount and
   * date is EXACT; same amount within a {@value #DATE_WINDOW_DAYS}-day window, or same date within
   * RM1.00, is PROBABLE. No fuzzy text matching, matching this codebase's established
   * "deterministic, explainable" posture for suggestion features.
   */
  public List<ReceiptTransactionMatchSuggestion> suggestTransactionMatches(
      UUID userId, UUID receiptId) {
    Receipt receipt = requireOwned(userId, receiptId);
    if (receipt.getTotalAmount() == null || receipt.getReceiptDate() == null) {
      return List.of();
    }
    LocalDate receiptDate = receipt.getReceiptDate();
    BigDecimal amount = receipt.getTotalAmount();

    List<Transaction> window =
        transactions.findByUserIdAndOccurredOnBetween(
            userId,
            receiptDate.minusDays(DATE_WINDOW_DAYS),
            receiptDate.plusDays(DATE_WINDOW_DAYS));

    List<ReceiptTransactionMatchSuggestion> exact = new ArrayList<>();
    List<ReceiptTransactionMatchSuggestion> probable = new ArrayList<>();
    for (Transaction transaction : window) {
      if (transaction.getDirection() != TransactionDirection.OUT) {
        continue;
      }
      BigDecimal transactionAmount = transaction.getAmount();
      boolean sameAmount = transactionAmount.compareTo(amount) == 0;
      boolean sameDate = transaction.getOccurredOn().isEqual(receiptDate);
      long daysBetween =
          Math.abs(ChronoUnit.DAYS.between(transaction.getOccurredOn(), receiptDate));
      boolean amountWithinTolerance =
          transactionAmount.subtract(amount).abs().compareTo(AMOUNT_TOLERANCE) <= 0;

      if (sameAmount && sameDate) {
        exact.add(toSuggestion(transaction, ReceiptMatchConfidence.EXACT));
      } else if (sameAmount && daysBetween <= DATE_WINDOW_DAYS) {
        probable.add(toSuggestion(transaction, ReceiptMatchConfidence.PROBABLE));
      } else if (sameDate && amountWithinTolerance) {
        probable.add(toSuggestion(transaction, ReceiptMatchConfidence.PROBABLE));
      }
    }
    exact.addAll(probable);
    return exact;
  }

  private static ReceiptTransactionMatchSuggestion toSuggestion(
      Transaction transaction, ReceiptMatchConfidence confidence) {
    return new ReceiptTransactionMatchSuggestion(
        transaction.getId(),
        transaction.getOccurredOn(),
        transaction.getMerchant(),
        transaction.getAmount(),
        confidence);
  }

  private ReceiptResponse toResponse(Receipt receipt) {
    String imageUrl = storage.presignedGetUrl(receipt.getStorageKey(), IMAGE_URL_TTL);
    return ReceiptResponse.from(receipt, imageUrl);
  }

  private Receipt requireOwned(UUID userId, UUID receiptId) {
    return receipts
        .findByIdAndUserId(receiptId, userId)
        .orElseThrow(() -> new NotFoundException("RECEIPT_NOT_FOUND", "Receipt not found."));
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
