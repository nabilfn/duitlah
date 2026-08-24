package com.duitlah.api.groups;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GroupRepository extends JpaRepository<Group, UUID> {

  Optional<Group> findByInviteTokenHash(String inviteTokenHash);

  long countByOwnerUserIdAndArchivedAtIsNull(UUID ownerUserId);
}
