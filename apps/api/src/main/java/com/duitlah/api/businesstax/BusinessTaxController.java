package com.duitlah.api.businesstax;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BusinessTaxController {

  private final SstRateService sstRateService;
  private final SstReportService sstReportService;
  private final EInvoiceReadinessService readinessService;

  public BusinessTaxController(
      SstRateService sstRateService,
      SstReportService sstReportService,
      EInvoiceReadinessService readinessService) {
    this.sstRateService = sstRateService;
    this.sstReportService = sstReportService;
    this.readinessService = readinessService;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-tax/sst-rates")
  public List<SstRateResponse> sstRates(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return sstRateService.listAll(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-tax/sst-report")
  public SstReportResponse sstReport(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return sstReportService.reportForPeriod(userId, spaceId, from, to);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-tax/einvoice-readiness")
  public EInvoiceReadinessResponse einvoiceReadiness(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return readinessService.evaluate(userId, spaceId);
  }
}
