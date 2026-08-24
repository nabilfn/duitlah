package com.duitlah.api.finance;

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

/**
 * userId null = system default, available to every user and not user-editable. See V3 migration.
 */
@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
public class Category extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id")
  private UUID userId;

  @Column(name = "parent_id")
  private UUID parentId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private CategoryType type;

  @Column(nullable = false)
  private String name;

  private String icon;

  public Category(UUID userId, UUID parentId, CategoryType type, String name, String icon) {
    this.userId = userId;
    this.parentId = parentId;
    this.type = type;
    this.name = name;
    this.icon = icon;
  }

  public boolean isSystemDefault() {
    return userId == null;
  }
}
