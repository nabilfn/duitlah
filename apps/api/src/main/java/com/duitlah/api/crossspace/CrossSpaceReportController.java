package com.duitlah.api.crossspace;

import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CrossSpaceReportController {

  private final CrossSpaceReportService reportService;

  public CrossSpaceReportController(CrossSpaceReportService reportService) {
    this.reportService = reportService;
  }

  @GetMapping("/api/v1/crossspace/net-worth")
  public CombinedNetWorthResponse combinedNetWorth(@AuthenticationPrincipal UUID userId) {
    return reportService.combinedNetWorth(userId);
  }
}
