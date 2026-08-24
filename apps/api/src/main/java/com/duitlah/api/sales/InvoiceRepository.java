package com.duitlah.api.sales;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvoiceRepository extends JpaRepository<Invoice, UUID> {

  Optional<Invoice> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<Invoice> findBySpaceIdOrderByIssueDateDesc(UUID spaceId);

  long countBySpaceId(UUID spaceId);
}
