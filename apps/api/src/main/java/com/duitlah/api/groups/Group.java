package com.duitlah.api.groups;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "groups")
@Getter
@Setter
@NoArgsConstructor
public class Group extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "owner_user_id", nullable = false)
  private UUID ownerUserId;

  @Column(nullable = false)
  private String name;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private GroupType type;

  @Column(name = "invite_token_hash")
  private String inviteTokenHash;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public Group(UUID ownerUserId, String name, GroupType type) {
    this.ownerUserId = ownerUserId;
    this.name = name;
    this.type = type;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
