package com.duitlah.api.assets;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

public record DepreciationEntryResponse(
    UUID id, UUID assetId, LocalDate period, BigDecimal amount, Instant createdAt) {

  public static DepreciationEntryResponse of(AssetDepreciationEntry entry) {
    return new DepreciationEntryResponse(
        entry.getId(),
        entry.getAssetId(),
        entry.getPeriod(),
        entry.getAmount(),
        entry.getCreatedAt());
  }
}
