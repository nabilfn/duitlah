package com.duitlah.api.assets;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Append-only — see package-info. One row per period an asset was depreciated for. */
@Entity
@Table(name = "asset_depreciation_entries")
@Getter
@Setter
@NoArgsConstructor
public class AssetDepreciationEntry {

  @Id @GeneratedValue private UUID id;

  @Column(name = "asset_id", nullable = false)
  private UUID assetId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private LocalDate period;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public AssetDepreciationEntry(
      UUID assetId, UUID spaceId, LocalDate period, BigDecimal amount, UUID createdByUserId) {
    this.assetId = assetId;
    this.spaceId = spaceId;
    this.period = period;
    this.amount = amount;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
  }
}
