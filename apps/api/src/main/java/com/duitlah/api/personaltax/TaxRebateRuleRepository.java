package com.duitlah.api.personaltax;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaxRebateRuleRepository extends JpaRepository<TaxRebateRule, UUID> {

  List<TaxRebateRule> findByTaxYearId(UUID taxYearId);
}
