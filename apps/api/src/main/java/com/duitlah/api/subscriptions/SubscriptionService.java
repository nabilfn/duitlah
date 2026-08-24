package com.duitlah.api.subscriptions;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.groups.GroupRepository;
import com.duitlah.api.receipts.ReceiptScanRepository;
import com.duitlah.api.telemetry.ProductAnalyticsService;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.temporal.TemporalAdjusters;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * FREE-tier limits (product spec section 53): up to 3 active (non-archived, owned) groups and ~5
 * receipt scans/month. PLUS (section 54) removes both. TOGETHER (section 55) is a future plan, not
 * implemented here (Phase 13's own scope, section 78, is only FREE/PLUS).
 *
 * <p>"Active groups" counts groups the user <em>owns</em>, not groups they've merely joined — being
 * invited into someone else's group must never count against an unrelated free user's own quota,
 * per the product spec's explicit "do NOT prevent free users from participating in premium-created
 * Bagilah sessions" and "never destroy the social growth loop through excessive paywalls"
 * principles (sections 53/57). This class depends on {@code groups}' and {@code receipts}'
 * repositories directly for read-only usage counts — the same "plain lookup, not a business
 * dependency" shape as {@code groups}' own dependency on {@code users.UserRepository} — and is in
 * turn depended on by {@code GroupService}/{@code ReceiptScanService} for enforcement; see
 * [architecture.md] for why this isn't circular (repositories, not services, going one way).
 */
@Service
public class SubscriptionService {

  private static final int FREE_MAX_ACTIVE_GROUPS = 3;
  private static final int FREE_MAX_RECEIPT_SCANS_PER_MONTH = 5;

  private final UserSubscriptionRepository subscriptions;
  private final SubscriptionVerifier verifier;
  private final GroupRepository groups;
  private final ReceiptScanRepository receiptScans;
  private final ProductAnalyticsService productAnalyticsService;

  public SubscriptionService(
      UserSubscriptionRepository subscriptions,
      SubscriptionVerifier verifier,
      GroupRepository groups,
      ReceiptScanRepository receiptScans,
      ProductAnalyticsService productAnalyticsService) {
    this.subscriptions = subscriptions;
    this.verifier = verifier;
    this.groups = groups;
    this.receiptScans = receiptScans;
    this.productAnalyticsService = productAnalyticsService;
  }

  public EntitlementResponse getEntitlement(UUID userId) {
    SubscriptionTier tier = tierFor(userId);
    UserSubscription subscription = subscriptions.findByUserId(userId).orElse(null);
    long activeGroupCount = groups.countByOwnerUserIdAndArchivedAtIsNull(userId);
    long receiptScansThisMonth =
        receiptScans.countByOwnerUserIdAndCreatedAtBetween(
            userId, startOfCurrentMonth(), Instant.now());

    boolean unlimited = tier == SubscriptionTier.PLUS;
    return new EntitlementResponse(
        tier,
        subscription == null ? null : subscription.getStatus(),
        subscription == null ? null : subscription.getExpiresAt(),
        unlimited ? null : FREE_MAX_ACTIVE_GROUPS,
        (int) activeGroupCount,
        unlimited ? null : FREE_MAX_RECEIPT_SCANS_PER_MONTH,
        (int) receiptScansThisMonth);
  }

  @Transactional
  public EntitlementResponse verifyPurchase(UUID userId, VerifyPurchaseRequest request) {
    VerificationResult result = verifier.verify(request.source(), request.receiptData());
    if (!result.valid()) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "PURCHASE_VERIFICATION_FAILED", result.message());
    }

    UserSubscription subscription =
        subscriptions
            .findByUserId(userId)
            .orElseGet(
                () ->
                    new UserSubscription(
                        userId,
                        SubscriptionTier.PLUS,
                        request.source(),
                        result.externalReference(),
                        SubscriptionStatus.ACTIVE,
                        Instant.now(),
                        result.expiresAt()));
    subscription.setTier(SubscriptionTier.PLUS);
    subscription.setSource(request.source());
    subscription.setExternalReference(result.externalReference());
    subscription.setStatus(SubscriptionStatus.ACTIVE);
    subscription.setExpiresAt(result.expiresAt());
    subscriptions.save(subscription);
    productAnalyticsService.track(
        userId, "subscription_purchased", Map.of("source", request.source().name()));

    return getEntitlement(userId);
  }

  /** Called by {@code GroupService} before creating or reactivating an owned group. */
  public void requireActiveGroupCapacity(UUID userId) {
    if (tierFor(userId) == SubscriptionTier.PLUS) {
      return;
    }
    long activeGroupCount = groups.countByOwnerUserIdAndArchivedAtIsNull(userId);
    if (activeGroupCount >= FREE_MAX_ACTIVE_GROUPS) {
      throw new ForbiddenException(
          "GROUP_LIMIT_REACHED",
          "Free accounts can have up to "
              + FREE_MAX_ACTIVE_GROUPS
              + " active groups. Upgrade to Duitlah+ for unlimited groups.");
    }
  }

  /** Called by {@code ReceiptScanService} before running an OCR scan. */
  public void requireReceiptScanCapacity(UUID userId) {
    if (tierFor(userId) == SubscriptionTier.PLUS) {
      return;
    }
    long scansThisMonth =
        receiptScans.countByOwnerUserIdAndCreatedAtBetween(
            userId, startOfCurrentMonth(), Instant.now());
    if (scansThisMonth >= FREE_MAX_RECEIPT_SCANS_PER_MONTH) {
      throw new ForbiddenException(
          "RECEIPT_SCAN_LIMIT_REACHED",
          "Free accounts get "
              + FREE_MAX_RECEIPT_SCANS_PER_MONTH
              + " smart receipt scans a month. Upgrade to Duitlah+ for more.");
    }
  }

  private SubscriptionTier tierFor(UUID userId) {
    return subscriptions
        .findByUserId(userId)
        .filter(UserSubscription::isCurrentlyEntitled)
        .map(UserSubscription::getTier)
        .orElse(SubscriptionTier.FREE);
  }

  private Instant startOfCurrentMonth() {
    return Instant.now()
        .atZone(ZoneOffset.UTC)
        .with(TemporalAdjusters.firstDayOfMonth())
        .toLocalDate()
        .atStartOfDay(ZoneOffset.UTC)
        .toInstant();
  }
}
