package com.duitlah.api.analytics;

import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DashboardController {

  private final DashboardService dashboardService;

  public DashboardController(DashboardService dashboardService) {
    this.dashboardService = dashboardService;
  }

  @GetMapping("/api/v1/dashboard")
  public DashboardResponse dashboard(@AuthenticationPrincipal UUID userId) {
    return dashboardService.forUser(userId);
  }
}
