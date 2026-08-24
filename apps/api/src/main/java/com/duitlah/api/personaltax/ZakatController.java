package com.duitlah.api.personaltax;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ZakatController {

  private final ZakatService zakatService;

  public ZakatController(ZakatService zakatService) {
    this.zakatService = zakatService;
  }

  @PostMapping("/api/v1/personal-tax/zakat")
  @ResponseStatus(HttpStatus.CREATED)
  public ZakatPaymentResponse record(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody RecordZakatPaymentRequest request) {
    return zakatService.record(userId, request);
  }

  @GetMapping("/api/v1/personal-tax/zakat")
  public List<ZakatPaymentResponse> list(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return zakatService.list(userId, yearOfAssessment);
  }
}
