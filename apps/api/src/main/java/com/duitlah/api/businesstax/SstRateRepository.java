package com.duitlah.api.businesstax;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface SstRateRepository extends JpaRepository<SstRate, java.util.UUID> {

  List<SstRate> findAllByOrderByTaxTypeAscEffectiveFromDesc();

  @Query(
      "select r from SstRate r where r.taxType = :taxType and r.effectiveFrom <= :asOf "
          + "and (r.effectiveTo is null or r.effectiveTo >= :asOf) order by r.effectiveFrom desc")
  List<SstRate> findEffectiveOn(SstTaxType taxType, LocalDate asOf);

  default Optional<SstRate> findCurrentRate(SstTaxType taxType, LocalDate asOf) {
    List<SstRate> matches = findEffectiveOn(taxType, asOf);
    return matches.isEmpty() ? Optional.empty() : Optional.of(matches.get(0));
  }
}
