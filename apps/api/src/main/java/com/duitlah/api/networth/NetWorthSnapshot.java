package com.duitlah.api.networth;

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

@Entity
@Table(name = "net_worth_snapshots")
@Getter
@Setter
@NoArgsConstructor
public class NetWorthSnapshot {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "total_assets", nullable = false)
  private BigDecimal totalAssets;

  @Column(name = "total_liabilities", nullable = false)
  private BigDecimal totalLiabilities;

  @Column(name = "net_worth", nullable = false)
  private BigDecimal netWorth;

  @Column(name = "snapshot_date", nullable = false)
  private LocalDate snapshotDate;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  public NetWorthSnapshot(
      UUID userId,
      UUID spaceId,
      BigDecimal totalAssets,
      BigDecimal totalLiabilities,
      LocalDate snapshotDate) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.totalAssets = totalAssets;
    this.totalLiabilities = totalLiabilities;
    this.netWorth = totalAssets.subtract(totalLiabilities);
    this.snapshotDate = snapshotDate;
  }

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }
}
