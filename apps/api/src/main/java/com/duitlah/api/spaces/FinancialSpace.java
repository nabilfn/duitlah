package com.duitlah.api.spaces;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "financial_spaces")
@Getter
@Setter
@NoArgsConstructor
public class FinancialSpace extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SpaceType type;

  @Column(nullable = false)
  private String name;

  @Column(name = "owner_user_id", nullable = false)
  private UUID ownerUserId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SpaceStatus status;

  public FinancialSpace(SpaceType type, String name, UUID ownerUserId) {
    this.type = type;
    this.name = name;
    this.ownerUserId = ownerUserId;
    this.status = SpaceStatus.ACTIVE;
  }
}
