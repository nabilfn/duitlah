package com.duitlah.api.spaces;

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
@Table(name = "space_members")
@Getter
@Setter
@NoArgsConstructor
public class SpaceMember {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SpaceRole role;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private MemberStatus status;

  @Column(name = "joined_at", nullable = false)
  private Instant joinedAt;

  public SpaceMember(UUID spaceId, UUID userId, SpaceRole role) {
    this.spaceId = spaceId;
    this.userId = userId;
    this.role = role;
    this.status = MemberStatus.ACTIVE;
    this.joinedAt = Instant.now();
  }

  public boolean isActive() {
    return status == MemberStatus.ACTIVE;
  }
}
