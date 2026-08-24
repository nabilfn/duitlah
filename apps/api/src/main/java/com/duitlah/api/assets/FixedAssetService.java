package com.duitlah.api.assets;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** The asset register itself, plus disposal (spec section 50). See package-info. */
@Service
public class FixedAssetService {

  private final FixedAssetRepository assets;
  private final AssetDepreciationEntryRepository depreciationEntries;
  private final BusinessAccountService businessAccountService;
  private final AutomaticPostingService automaticPostingService;
  private final SpaceService spaceService;

  public FixedAssetService(
      FixedAssetRepository assets,
      AssetDepreciationEntryRepository depreciationEntries,
      BusinessAccountService businessAccountService,
      AutomaticPostingService automaticPostingService,
      SpaceService spaceService) {
    this.assets = assets;
    this.depreciationEntries = depreciationEntries;
    this.businessAccountService = businessAccountService;
    this.automaticPostingService = automaticPostingService;
    this.spaceService = spaceService;
  }

  @Transactional
  public FixedAssetResponse create(UUID userId, UUID spaceId, CreateFixedAssetRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    FixedAsset asset =
        new FixedAsset(
            spaceId,
            request.name().trim(),
            request.category(),
            request.acquisitionDate(),
            request.cost(),
            request.salvageValueOrZero(),
            request.usefulLifeMonths(),
            request.depreciationMethod(),
            userId);
    assets.save(asset);

    UUID businessAccountChartOfAccountsId = null;
    if (request.businessAccountId() != null) {
      BusinessAccount account =
          businessAccountService.requireOwned(spaceId, request.businessAccountId());
      businessAccountChartOfAccountsId = account.getChartOfAccountsId();
    }
    automaticPostingService.postAssetAcquired(
        spaceId,
        userId,
        asset.getId(),
        asset.getAcquisitionDate(),
        asset.getCost(),
        "Asset acquired: " + asset.getName(),
        businessAccountChartOfAccountsId);

    return toResponse(asset);
  }

  public List<FixedAssetResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return assets.findBySpaceIdOrderByAcquisitionDateDesc(spaceId).stream()
        .map(this::toResponse)
        .toList();
  }

  public FixedAssetResponse get(UUID userId, UUID spaceId, UUID assetId) {
    spaceService.requireMembership(userId, spaceId);
    return toResponse(requireOwned(spaceId, assetId));
  }

  @Transactional
  public FixedAssetResponse update(
      UUID userId, UUID spaceId, UUID assetId, CreateFixedAssetRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    FixedAsset asset = requireOwned(spaceId, assetId);
    if (asset.getStatus() == AssetStatus.DISPOSED) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "ASSET_ALREADY_DISPOSED",
          "This asset has already been disposed of.");
    }
    asset.setName(request.name().trim());
    asset.setCategory(request.category());
    boolean depreciated =
        !depreciationEntries.findByAssetIdOrderByPeriodDesc(asset.getId()).isEmpty();
    if (depreciated) {
      if (!asset.getCost().equals(request.cost())
          || !asset.getSalvageValue().equals(request.salvageValueOrZero())
          || asset.getUsefulLifeMonths() != request.usefulLifeMonths()
          || asset.getDepreciationMethod() != request.depreciationMethod()
          || !asset.getAcquisitionDate().equals(request.acquisitionDate())) {
        throw new ApiException(
            HttpStatus.CONFLICT,
            "ASSET_FINANCIALS_LOCKED",
            "Cost, salvage value, useful life, method, and acquisition date can't change once depreciation has been posted.");
      }
    } else {
      asset.setAcquisitionDate(request.acquisitionDate());
      asset.setCost(request.cost());
      asset.setSalvageValue(request.salvageValueOrZero());
      asset.setUsefulLifeMonths(request.usefulLifeMonths());
      asset.setDepreciationMethod(request.depreciationMethod());
    }
    assets.save(asset);
    return toResponse(asset);
  }

  @Transactional
  public FixedAssetResponse dispose(
      UUID userId, UUID spaceId, UUID assetId, DisposeAssetRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    FixedAsset asset = requireOwned(spaceId, assetId);
    if (asset.getStatus() == AssetStatus.DISPOSED) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "ASSET_ALREADY_DISPOSED",
          "This asset has already been disposed of.");
    }
    if (request.proceeds().signum() > 0 && request.businessAccountId() == null) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "PROCEEDS_ACCOUNT_REQUIRED",
          "Record which account the disposal proceeds were received into.");
    }

    UUID businessAccountChartOfAccountsId = null;
    if (request.businessAccountId() != null) {
      BusinessAccount account =
          businessAccountService.requireOwned(spaceId, request.businessAccountId());
      businessAccountChartOfAccountsId = account.getChartOfAccountsId();
    }

    BigDecimal accumulated = accumulatedDepreciation(asset.getId());
    asset.setStatus(AssetStatus.DISPOSED);
    asset.setDisposedOn(request.disposedOn());
    asset.setDisposalProceeds(request.proceeds());
    assets.save(asset);

    automaticPostingService.postAssetDisposal(
        spaceId,
        userId,
        asset.getId(),
        request.disposedOn(),
        asset.getCost(),
        accumulated,
        request.proceeds(),
        "Asset disposed: " + asset.getName(),
        businessAccountChartOfAccountsId);

    return toResponse(asset);
  }

  FixedAsset requireOwned(UUID spaceId, UUID assetId) {
    return assets
        .findByIdAndSpaceId(assetId, spaceId)
        .orElseThrow(() -> new NotFoundException("ASSET_NOT_FOUND", "Fixed asset not found."));
  }

  BigDecimal accumulatedDepreciation(UUID assetId) {
    return depreciationEntries.sumAmountByAssetId(assetId);
  }

  private FixedAssetResponse toResponse(FixedAsset asset) {
    BigDecimal accumulated = accumulatedDepreciation(asset.getId());
    BigDecimal netBookValue = asset.getCost().subtract(accumulated);
    return FixedAssetResponse.of(asset, new AssetValuation(accumulated, netBookValue));
  }
}
