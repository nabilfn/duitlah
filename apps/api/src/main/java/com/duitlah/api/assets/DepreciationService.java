package com.duitlah.api.assets;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Depreciation — spec section 50's own field list ("depreciation method", "accumulated
 * depreciation") plus the literal Phase 9 "journal generation" bullet. See package-info.
 */
@Service
public class DepreciationService {

  private final FixedAssetRepository assets;
  private final AssetDepreciationEntryRepository entries;
  private final FixedAssetService fixedAssetService;
  private final AutomaticPostingService automaticPostingService;
  private final SpaceService spaceService;

  public DepreciationService(
      FixedAssetRepository assets,
      AssetDepreciationEntryRepository entries,
      FixedAssetService fixedAssetService,
      AutomaticPostingService automaticPostingService,
      SpaceService spaceService) {
    this.assets = assets;
    this.entries = entries;
    this.fixedAssetService = fixedAssetService;
    this.automaticPostingService = automaticPostingService;
    this.spaceService = spaceService;
  }

  @Transactional
  public DepreciationEntryResponse runForPeriod(
      UUID userId, UUID spaceId, UUID assetId, RunDepreciationRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    FixedAsset asset = fixedAssetService.requireOwned(spaceId, assetId);
    if (asset.getStatus() == AssetStatus.DISPOSED) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "ASSET_ALREADY_DISPOSED",
          "This asset has already been disposed of.");
    }
    LocalDate period = request.period().withDayOfMonth(1);
    if (entries.existsByAssetIdAndPeriod(asset.getId(), period)) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "PERIOD_ALREADY_DEPRECIATED",
          "Depreciation has already been posted for this period.");
    }
    BigDecimal amount = computeNextAmount(asset);
    if (amount.signum() <= 0) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "ASSET_FULLY_DEPRECIATED",
          "This asset has already reached its salvage value.");
    }
    AssetDepreciationEntry entry =
        new AssetDepreciationEntry(asset.getId(), spaceId, period, amount, userId);
    entries.save(entry);
    automaticPostingService.postAssetDepreciation(
        spaceId, userId, entry.getId(), period, amount, "Depreciation: " + asset.getName());
    return DepreciationEntryResponse.of(entry);
  }

  public List<DepreciationEntryResponse> listEntries(UUID userId, UUID spaceId, UUID assetId) {
    spaceService.requireMembership(userId, spaceId);
    FixedAsset asset = fixedAssetService.requireOwned(spaceId, assetId);
    return entries.findByAssetIdOrderByPeriodDesc(asset.getId()).stream()
        .map(DepreciationEntryResponse::of)
        .toList();
  }

  /**
   * System-use only, for {@link AssetDepreciationScheduler} — no acting-user context; every asset's
   * own creator is attributed as the journal entry's actor, matching how the acquisition posting
   * attributed the same user. Returns how many assets were depreciated.
   */
  @Transactional
  public int runAllDueForPeriod(LocalDate period) {
    LocalDate normalizedPeriod = period.withDayOfMonth(1);
    int posted = 0;
    for (FixedAsset asset : assets.findByStatus(AssetStatus.ACTIVE)) {
      if (entries.existsByAssetIdAndPeriod(asset.getId(), normalizedPeriod)) {
        continue;
      }
      BigDecimal amount = computeNextAmount(asset);
      if (amount.signum() <= 0) {
        continue;
      }
      AssetDepreciationEntry entry =
          new AssetDepreciationEntry(
              asset.getId(),
              asset.getSpaceId(),
              normalizedPeriod,
              amount,
              asset.getCreatedByUserId());
      entries.save(entry);
      automaticPostingService.postAssetDepreciation(
          asset.getSpaceId(),
          asset.getCreatedByUserId(),
          entry.getId(),
          normalizedPeriod,
          amount,
          "Depreciation: " + asset.getName());
      posted++;
    }
    return posted;
  }

  private BigDecimal computeNextAmount(FixedAsset asset) {
    BigDecimal accumulated = fixedAssetService.accumulatedDepreciation(asset.getId());
    return DepreciationCalculator.nextPeriodAmount(
        asset.getDepreciationMethod(),
        asset.getCost(),
        asset.getSalvageValue(),
        asset.getUsefulLifeMonths(),
        accumulated);
  }
}
