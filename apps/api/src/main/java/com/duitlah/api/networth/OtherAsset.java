package com.duitlah.api.networth;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Manually-entered assets {@code finance.Account} doesn't cover — property, vehicles, other. */
@Entity
@Table(name = "other_assets")
@Getter
@Setter
@NoArgsConstructor
public class OtherAsset extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private AssetType type;

  @Column(nullable = false)
  private String name;

  @Column(name = "estimated_value", nullable = false)
  private BigDecimal estimatedValue;

  private String notes;

  public OtherAsset(
      UUID userId, UUID spaceId, AssetType type, String name, BigDecimal estimatedValue) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.type = type;
    this.name = name;
    this.estimatedValue = estimatedValue;
  }
}
