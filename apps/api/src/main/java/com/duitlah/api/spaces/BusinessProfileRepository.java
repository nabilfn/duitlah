package com.duitlah.api.spaces;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessProfileRepository extends JpaRepository<BusinessProfile, UUID> {

  Optional<BusinessProfile> findBySpaceId(UUID spaceId);
}
