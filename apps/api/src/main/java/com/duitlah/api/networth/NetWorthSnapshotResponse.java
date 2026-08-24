package com.duitlah.api.networth;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record NetWorthSnapshotResponse(
    UUID id,
    BigDecimal totalAssets,
    BigDecimal totalLiabilities,
    BigDecimal netWorth,
    LocalDate snapshotDate) {

  public static NetWorthSnapshotResponse from(NetWorthSnapshot snapshot) {
    return new NetWorthSnapshotResponse(
        snapshot.getId(),
        snapshot.getTotalAssets(),
        snapshot.getTotalLiabilities(),
        snapshot.getNetWorth(),
        snapshot.getSnapshotDate());
  }
}
