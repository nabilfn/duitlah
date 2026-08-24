package com.duitlah.api.assets;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record FixedAssetResponse(
    UUID id,
    String name,
    String category,
    LocalDate acquisitionDate,
    BigDecimal cost,
    BigDecimal salvageValue,
    int usefulLifeMonths,
    DepreciationMethod depreciationMethod,
    AssetStatus status,
    LocalDate disposedOn,
    BigDecimal disposalProceeds,
    BigDecimal accumulatedDepreciation,
    BigDecimal netBookValue) {

  public static FixedAssetResponse of(FixedAsset asset, AssetValuation valuation) {
    return new FixedAssetResponse(
        asset.getId(),
        asset.getName(),
        asset.getCategory(),
        asset.getAcquisitionDate(),
        asset.getCost(),
        asset.getSalvageValue(),
        asset.getUsefulLifeMonths(),
        asset.getDepreciationMethod(),
        asset.getStatus(),
        asset.getDisposedOn(),
        asset.getDisposalProceeds(),
        valuation.accumulatedDepreciation(),
        valuation.netBookValue());
  }
}
