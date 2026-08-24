package com.duitlah.api.crm;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SupplierRepository extends JpaRepository<Supplier, UUID> {

  Optional<Supplier> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<Supplier> findBySpaceIdOrderByNameAsc(UUID spaceId);

  long countBySpaceId(UUID spaceId);
}
