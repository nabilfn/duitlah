package com.duitlah.api.spaces;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FinancialSpaceRepository extends JpaRepository<FinancialSpace, UUID> {

  Optional<FinancialSpace> findByOwnerUserIdAndType(UUID ownerUserId, SpaceType type);

  List<FinancialSpace> findByType(SpaceType type);
}
