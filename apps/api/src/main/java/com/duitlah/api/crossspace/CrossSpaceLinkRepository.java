package com.duitlah.api.crossspace;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CrossSpaceLinkRepository extends JpaRepository<CrossSpaceLink, UUID> {

  Optional<CrossSpaceLink> findByIdAndBusinessSpaceId(UUID id, UUID businessSpaceId);

  List<CrossSpaceLink> findByPersonalUserIdOrderByCreatedAtDesc(UUID personalUserId);

  List<CrossSpaceLink> findByBusinessSpaceIdOrderByCreatedAtDesc(UUID businessSpaceId);

  List<CrossSpaceLink> findByPersonalTransactionIdOrderByCreatedAtDesc(UUID personalTransactionId);
}
