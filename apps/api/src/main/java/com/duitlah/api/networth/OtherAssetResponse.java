package com.duitlah.api.networth;

import java.math.BigDecimal;
import java.util.UUID;

public record OtherAssetResponse(
    UUID id, AssetType type, String name, BigDecimal estimatedValue, String notes) {

  public static OtherAssetResponse from(OtherAsset asset) {
    return new OtherAssetResponse(
        asset.getId(),
        asset.getType(),
        asset.getName(),
        asset.getEstimatedValue(),
        asset.getNotes());
  }
}
