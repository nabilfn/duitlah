package com.duitlah.api.bizdashboard;

import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BusinessDashboardController {

  private final BusinessDashboardService dashboard;

  public BusinessDashboardController(BusinessDashboardService dashboard) {
    this.dashboard = dashboard;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-dashboard")
  public BusinessDashboardResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return dashboard.get(userId, spaceId);
  }
}
