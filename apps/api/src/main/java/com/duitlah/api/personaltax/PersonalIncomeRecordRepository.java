package com.duitlah.api.personaltax;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonalIncomeRecordRepository extends JpaRepository<PersonalIncomeRecord, UUID> {

  Optional<PersonalIncomeRecord> findByIdAndUserId(UUID id, UUID userId);

  List<PersonalIncomeRecord> findByUserIdAndYearOfAssessment(UUID userId, int yearOfAssessment);
}
