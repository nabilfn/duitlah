package com.duitlah.api.networth;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.AccountResponse;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.AccountType;
import com.duitlah.api.liabilities.LiabilityResponse;
import com.duitlah.api.liabilities.LiabilityService;
import com.duitlah.api.liabilities.LiabilityStatus;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * {@code Assets - Liabilities} (spec section 19), always computed fresh — see package-info for why
 * {@link NetWorthSnapshot} is the one deliberate stored exception. Every credit card account's
 * outstanding is derived straight from {@link AccountService#balanceOf}; a card doesn't need {@code
 * liabilities.CreditCardDetails} set up at all for its debt to count here — the credit limit/
 * statement dates are only needed for the card's own utilization view, not for net worth.
 */
@Service
public class NetWorthService {

  private final AccountService accountService;
  private final OtherAssetRepository otherAssets;
  private final LiabilityService liabilityService;
  private final SpaceService spaceService;
  private final NetWorthSnapshotRepository snapshots;

  public NetWorthService(
      AccountService accountService,
      OtherAssetRepository otherAssets,
      LiabilityService liabilityService,
      SpaceService spaceService,
      NetWorthSnapshotRepository snapshots) {
    this.accountService = accountService;
    this.otherAssets = otherAssets;
    this.liabilityService = liabilityService;
    this.spaceService = spaceService;
    this.snapshots = snapshots;
  }

  public NetWorthResponse compute(UUID userId) {
    List<AccountResponse> accounts = accountService.listForUser(userId);

    List<BreakdownLine> assetLines = new ArrayList<>();
    for (AccountResponse account : accounts) {
      if (account.archived() || account.type() == AccountType.CREDIT_CARD) {
        continue;
      }
      assetLines.add(new BreakdownLine(account.name(), account.balance()));
    }
    for (OtherAsset asset : otherAssets.findByUserId(userId)) {
      assetLines.add(new BreakdownLine(asset.getName(), asset.getEstimatedValue()));
    }

    List<BreakdownLine> liabilityLines = new ArrayList<>();
    for (AccountResponse account : accounts) {
      if (account.archived() || account.type() != AccountType.CREDIT_CARD) {
        continue;
      }
      BigDecimal outstanding = account.balance().negate().max(BigDecimal.ZERO);
      if (outstanding.signum() > 0) {
        liabilityLines.add(new BreakdownLine(account.name(), outstanding));
      }
    }
    for (LiabilityResponse liability : liabilityService.list(userId)) {
      if (liability.status() == LiabilityStatus.ACTIVE) {
        liabilityLines.add(new BreakdownLine(liability.name(), liability.outstandingPrincipal()));
      }
    }

    BigDecimal totalAssets = sum(assetLines);
    BigDecimal totalLiabilities = sum(liabilityLines);
    return new NetWorthResponse(
        totalAssets,
        totalLiabilities,
        totalAssets.subtract(totalLiabilities),
        assetLines,
        liabilityLines);
  }

  @Transactional
  public NetWorthSnapshotResponse takeSnapshot(UUID userId) {
    NetWorthResponse current = compute(userId);
    NetWorthSnapshot snapshot =
        new NetWorthSnapshot(
            userId,
            spaceService.personalSpaceIdFor(userId),
            current.totalAssets(),
            current.totalLiabilities(),
            LocalDate.now());
    snapshots.save(snapshot);
    return NetWorthSnapshotResponse.from(snapshot);
  }

  public List<NetWorthSnapshotResponse> history(UUID userId) {
    return snapshots.findByUserIdOrderBySnapshotDateAsc(userId).stream()
        .map(NetWorthSnapshotResponse::from)
        .toList();
  }

  @Transactional
  public OtherAssetResponse addOtherAsset(UUID userId, CreateOtherAssetRequest request) {
    OtherAsset asset =
        new OtherAsset(
            userId,
            spaceService.personalSpaceIdFor(userId),
            request.type(),
            request.name().trim(),
            request.estimatedValue());
    asset.setNotes(request.notes());
    otherAssets.save(asset);
    return OtherAssetResponse.from(asset);
  }

  public List<OtherAssetResponse> listOtherAssets(UUID userId) {
    return otherAssets.findByUserId(userId).stream().map(OtherAssetResponse::from).toList();
  }

  @Transactional
  public void deleteOtherAsset(UUID userId, UUID assetId) {
    OtherAsset asset =
        otherAssets
            .findByIdAndUserId(assetId, userId)
            .orElseThrow(() -> new NotFoundException("ASSET_NOT_FOUND", "Asset not found."));
    otherAssets.delete(asset);
  }

  private static BigDecimal sum(List<BreakdownLine> lines) {
    return lines.stream().map(BreakdownLine::amount).reduce(BigDecimal.ZERO, BigDecimal::add);
  }
}
