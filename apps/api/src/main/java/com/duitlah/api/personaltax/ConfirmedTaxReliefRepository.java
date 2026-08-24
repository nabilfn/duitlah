package com.duitlah.api.personaltax;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConfirmedTaxReliefRepository extends JpaRepository<ConfirmedTaxRelief, UUID> {

  List<ConfirmedTaxRelief> findByUserIdAndYearOfAssessment(UUID userId, int yearOfAssessment);

  Optional<ConfirmedTaxRelief> findByUserIdAndYearOfAssessmentAndCategory(
      UUID userId, int yearOfAssessment, PersonalTaxReliefCategory category);

  Optional<ConfirmedTaxRelief> findByIdAndUserId(UUID id, UUID userId);
}
