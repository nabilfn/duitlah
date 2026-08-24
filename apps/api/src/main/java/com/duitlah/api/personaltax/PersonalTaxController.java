package com.duitlah.api.personaltax;

import java.util.UUID;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PersonalTaxController {

  private final PersonalTaxCalculationService calculationService;
  private final FilingReadinessService filingReadinessService;
  private final TaxPreparationSummaryService summaryService;

  public PersonalTaxController(
      PersonalTaxCalculationService calculationService,
      FilingReadinessService filingReadinessService,
      TaxPreparationSummaryService summaryService) {
    this.calculationService = calculationService;
    this.filingReadinessService = filingReadinessService;
    this.summaryService = summaryService;
  }

  @GetMapping("/api/v1/personal-tax/calculation")
  public PersonalTaxCalculationResponse calculate(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return calculationService.calculate(userId, yearOfAssessment);
  }

  @GetMapping("/api/v1/personal-tax/filing-readiness")
  public FilingReadinessResponse filingReadiness(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return filingReadinessService.compute(userId, yearOfAssessment);
  }

  @GetMapping("/api/v1/personal-tax/preparation-summary")
  public ResponseEntity<byte[]> preparationSummary(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    byte[] pdf = summaryService.generate(userId, yearOfAssessment);
    return ResponseEntity.ok()
        .contentType(MediaType.APPLICATION_PDF)
        .header(
            HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment()
                .filename("tax-preparation-ya" + yearOfAssessment + ".pdf")
                .build()
                .toString())
        .body(pdf);
  }
}
