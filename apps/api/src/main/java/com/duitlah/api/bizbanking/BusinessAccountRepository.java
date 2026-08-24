package com.duitlah.api.bizbanking;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessAccountRepository extends JpaRepository<BusinessAccount, UUID> {

  Optional<BusinessAccount> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<BusinessAccount> findBySpaceIdOrderByCreatedAtAsc(UUID spaceId);
}
