package com.duitlah.api.personaltax;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaxReliefRuleRepository extends JpaRepository<TaxReliefRule, UUID> {

  List<TaxReliefRule> findByTaxYearId(UUID taxYearId);

  Optional<TaxReliefRule> findByTaxYearIdAndCategory(
      UUID taxYearId, PersonalTaxReliefCategory category);
}
