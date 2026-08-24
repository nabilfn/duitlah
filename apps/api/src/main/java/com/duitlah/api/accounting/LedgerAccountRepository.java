package com.duitlah.api.accounting;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LedgerAccountRepository extends JpaRepository<LedgerAccount, UUID> {

  Optional<LedgerAccount> findByIdAndSpaceId(UUID id, UUID spaceId);

  Optional<LedgerAccount> findBySpaceIdAndCode(UUID spaceId, String code);

  List<LedgerAccount> findBySpaceIdOrderByCodeAsc(UUID spaceId);

  boolean existsBySpaceId(UUID spaceId);
}
