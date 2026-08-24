package com.duitlah.api.assets;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * The asset register (spec section 50). {@code cost}/{@code salvageValue}/{@code
 * usefulLifeMonths}/{@code depreciationMethod}/{@code acquisitionDate} are immutable once any
 * {@link AssetDepreciationEntry} has been posted against this asset — changing them retroactively
 * would silently invalidate every period already depreciated, the same "don't switch valuation
 * methods historically" discipline {@code inventory} applies to Weighted Average Cost.
 */
@Entity
@Table(name = "fixed_assets")
@Getter
@Setter
@NoArgsConstructor
public class FixedAsset extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String name;

  private String category;

  @Column(name = "acquisition_date", nullable = false)
  private LocalDate acquisitionDate;

  @Column(nullable = false)
  private BigDecimal cost;

  @Column(name = "salvage_value", nullable = false)
  private BigDecimal salvageValue;

  @Column(name = "useful_life_months", nullable = false)
  private int usefulLifeMonths;

  @Enumerated(EnumType.STRING)
  @Column(name = "depreciation_method", nullable = false)
  private DepreciationMethod depreciationMethod;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private AssetStatus status;

  @Column(name = "disposed_on")
  private LocalDate disposedOn;

  @Column(name = "disposal_proceeds")
  private BigDecimal disposalProceeds;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  public FixedAsset(
      UUID spaceId,
      String name,
      String category,
      LocalDate acquisitionDate,
      BigDecimal cost,
      BigDecimal salvageValue,
      int usefulLifeMonths,
      DepreciationMethod depreciationMethod,
      UUID createdByUserId) {
    this.spaceId = spaceId;
    this.name = name;
    this.category = category;
    this.acquisitionDate = acquisitionDate;
    this.cost = cost;
    this.salvageValue = salvageValue;
    this.usefulLifeMonths = usefulLifeMonths;
    this.depreciationMethod = depreciationMethod;
    this.status = AssetStatus.ACTIVE;
    this.createdByUserId = createdByUserId;
  }
}
