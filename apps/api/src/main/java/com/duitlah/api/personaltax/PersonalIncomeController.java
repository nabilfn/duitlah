package com.duitlah.api.personaltax;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PersonalIncomeController {

  private final PersonalIncomeService incomeService;

  public PersonalIncomeController(PersonalIncomeService incomeService) {
    this.incomeService = incomeService;
  }

  @PostMapping("/api/v1/personal-tax/income")
  @ResponseStatus(HttpStatus.CREATED)
  public PersonalIncomeRecordResponse create(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreatePersonalIncomeRecordRequest request) {
    return incomeService.create(userId, request);
  }

  @GetMapping("/api/v1/personal-tax/income")
  public List<PersonalIncomeRecordResponse> list(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return incomeService.list(userId, yearOfAssessment);
  }

  @DeleteMapping("/api/v1/personal-tax/income/{recordId}")
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID recordId) {
    incomeService.delete(userId, recordId);
  }
}
