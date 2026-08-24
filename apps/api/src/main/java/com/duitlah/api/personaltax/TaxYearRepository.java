package com.duitlah.api.personaltax;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaxYearRepository extends JpaRepository<TaxYear, UUID> {

  Optional<TaxYear> findByYearOfAssessment(int yearOfAssessment);
}
