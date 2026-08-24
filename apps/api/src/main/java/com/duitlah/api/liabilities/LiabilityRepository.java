package com.duitlah.api.liabilities;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LiabilityRepository extends JpaRepository<Liability, UUID> {

  Optional<Liability> findByIdAndUserId(UUID id, UUID userId);

  List<Liability> findByUserIdOrderByCreatedAtDesc(UUID userId);

  List<Liability> findByUserIdAndStatus(UUID userId, LiabilityStatus status);
}
