package com.duitlah.api.analytics;

import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AnalyticsController {

  private final AnalyticsService analyticsService;

  public AnalyticsController(AnalyticsService analyticsService) {
    this.analyticsService = analyticsService;
  }

  @GetMapping("/api/v1/analytics/spending-by-category")
  public List<CategorySpendingResponse> spendingByCategory(
      @AuthenticationPrincipal UUID userId, @RequestParam int year, @RequestParam int month) {
    return analyticsService.spendingByCategory(userId, year, month);
  }

  @GetMapping("/api/v1/analytics/monthly-trend")
  public List<MonthlyTrendResponse> monthlyTrend(
      @AuthenticationPrincipal UUID userId, @RequestParam(defaultValue = "6") int months) {
    return analyticsService.monthlyTrend(userId, months);
  }

  @GetMapping("/api/v1/analytics/merchants")
  public List<MerchantSpendingResponse> topMerchants(
      @AuthenticationPrincipal UUID userId, @RequestParam int year, @RequestParam int month) {
    return analyticsService.topMerchants(userId, year, month);
  }

  @GetMapping("/api/v1/analytics/calendar")
  public List<CalendarEntryResponse> calendar(
      @AuthenticationPrincipal UUID userId, @RequestParam int year, @RequestParam int month) {
    return analyticsService.calendar(userId, year, month);
  }

  @GetMapping("/api/v1/analytics/forecast")
  public ForecastResponse forecast(@AuthenticationPrincipal UUID userId) {
    return analyticsService.forecast(userId);
  }
}
