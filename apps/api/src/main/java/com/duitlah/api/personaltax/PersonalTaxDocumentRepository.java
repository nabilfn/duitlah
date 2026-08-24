package com.duitlah.api.personaltax;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonalTaxDocumentRepository extends JpaRepository<PersonalTaxDocument, UUID> {

  Optional<PersonalTaxDocument> findByIdAndUserId(UUID id, UUID userId);

  List<PersonalTaxDocument> findByUserIdAndYearOfAssessment(UUID userId, int yearOfAssessment);

  boolean existsByUserIdAndYearOfAssessmentAndType(
      UUID userId, int yearOfAssessment, TaxDocumentType type);
}
