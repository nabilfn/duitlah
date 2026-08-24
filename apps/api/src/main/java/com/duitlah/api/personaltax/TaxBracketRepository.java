package com.duitlah.api.personaltax;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaxBracketRepository extends JpaRepository<TaxBracket, UUID> {

  List<TaxBracket> findByTaxYearIdOrderByLowerBoundAsc(UUID taxYearId);
}
