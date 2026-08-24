package com.duitlah.api.inventory;

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
public class InventoryReportController {

  private final InventoryReportService reports;

  public InventoryReportController(InventoryReportService reports) {
    this.reports = reports;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/inventory/stock-valuation")
  public List<StockValuationRow> stockValuation(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return reports.stockValuation(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/inventory/cogs")
  public CogsReportResponse cogs(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return reports.cogsForPeriod(userId, spaceId, from, to);
  }
}
