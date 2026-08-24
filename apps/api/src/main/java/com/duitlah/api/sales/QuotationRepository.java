package com.duitlah.api.sales;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuotationRepository extends JpaRepository<Quotation, UUID> {

  Optional<Quotation> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<Quotation> findBySpaceIdOrderByIssueDateDesc(UUID spaceId);

  long countBySpaceId(UUID spaceId);
}
