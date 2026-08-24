package com.duitlah.api.finhealth;

import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FinancialHealthController {

  private final FinancialHealthService financialHealthService;

  public FinancialHealthController(FinancialHealthService financialHealthService) {
    this.financialHealthService = financialHealthService;
  }

  @GetMapping("/api/v1/financial-health")
  public FinancialHealthResponse compute(@AuthenticationPrincipal UUID userId) {
    return financialHealthService.compute(userId);
  }
}
