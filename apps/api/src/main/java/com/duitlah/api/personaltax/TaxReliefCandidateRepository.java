package com.duitlah.api.personaltax;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaxReliefCandidateRepository extends JpaRepository<TaxReliefCandidate, UUID> {

  Optional<TaxReliefCandidate> findByIdAndUserId(UUID id, UUID userId);

  List<TaxReliefCandidate> findByUserIdAndYearOfAssessmentOrderByCreatedAtDesc(
      UUID userId, int yearOfAssessment);

  List<TaxReliefCandidate> findByUserIdAndYearOfAssessmentAndStatusOrderByCreatedAtDesc(
      UUID userId, int yearOfAssessment, TaxReliefCandidateStatus status);

  List<TaxReliefCandidate> findByUserIdAndYearOfAssessmentAndCategoryAndStatusIn(
      UUID userId,
      int yearOfAssessment,
      PersonalTaxReliefCategory category,
      List<TaxReliefCandidateStatus> statuses);
}
