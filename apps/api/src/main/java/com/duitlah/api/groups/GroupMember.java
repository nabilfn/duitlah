package com.duitlah.api.groups;

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
@Table(name = "group_members")
@Getter
@Setter
@NoArgsConstructor
public class GroupMember {

  @Id @GeneratedValue private UUID id;

  @Column(name = "group_id", nullable = false)
  private UUID groupId;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private GroupMemberRole role;

  @Column(name = "joined_at", nullable = false)
  private Instant joinedAt;

  public GroupMember(UUID groupId, UUID userId, GroupMemberRole role) {
    this.groupId = groupId;
    this.userId = userId;
    this.role = role;
    this.joinedAt = Instant.now();
  }
}
