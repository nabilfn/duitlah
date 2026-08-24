package com.duitlah.api.crm;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepository extends JpaRepository<Customer, UUID> {

  Optional<Customer> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<Customer> findBySpaceIdOrderByNameAsc(UUID spaceId);

  long countBySpaceId(UUID spaceId);
}
