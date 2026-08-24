package com.duitlah.api.businesstax;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EInvoiceMandateRuleRepository
    extends JpaRepository<EInvoiceMandateRule, java.util.UUID> {

  List<EInvoiceMandateRule> findByEffectiveDateLessThanEqualOrderByEffectiveDateDesc(
      LocalDate asOf);

  default Optional<EInvoiceMandateRule> findCurrentRule(LocalDate asOf) {
    List<EInvoiceMandateRule> matches =
        findByEffectiveDateLessThanEqualOrderByEffectiveDateDesc(asOf);
    return matches.isEmpty() ? Optional.empty() : Optional.of(matches.get(0));
  }

  List<EInvoiceMandateRule> findByEffectiveDateGreaterThanOrderByEffectiveDateAsc(LocalDate after);
}
