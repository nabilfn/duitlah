package com.duitlah.api.personaltax;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PersonalIncomeService {

  private final PersonalIncomeRecordRepository records;
  private final SpaceService spaceService;

  public PersonalIncomeService(PersonalIncomeRecordRepository records, SpaceService spaceService) {
    this.records = records;
    this.spaceService = spaceService;
  }

  @Transactional
  public PersonalIncomeRecordResponse create(
      UUID userId, CreatePersonalIncomeRecordRequest request) {
    PersonalIncomeRecord record =
        new PersonalIncomeRecord(
            userId,
            spaceService.personalSpaceIdFor(userId),
            request.yearOfAssessment(),
            request.incomeType(),
            request.amount());
    record.setDescription(request.description());
    records.save(record);
    return PersonalIncomeRecordResponse.from(record);
  }

  public List<PersonalIncomeRecordResponse> list(UUID userId, int yearOfAssessment) {
    return records.findByUserIdAndYearOfAssessment(userId, yearOfAssessment).stream()
        .map(PersonalIncomeRecordResponse::from)
        .toList();
  }

  @Transactional
  public void delete(UUID userId, UUID recordId) {
    PersonalIncomeRecord record =
        records
            .findByIdAndUserId(recordId, userId)
            .orElseThrow(
                () -> new NotFoundException("INCOME_RECORD_NOT_FOUND", "Income record not found."));
    records.delete(record);
  }
}
