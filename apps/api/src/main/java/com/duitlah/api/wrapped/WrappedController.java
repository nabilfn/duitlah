package com.duitlah.api.wrapped;

import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WrappedController {

  private final WrappedGenerationService wrappedGenerationService;

  public WrappedController(WrappedGenerationService wrappedGenerationService) {
    this.wrappedGenerationService = wrappedGenerationService;
  }

  @GetMapping("/api/v1/wrapped/promo")
  public WrappedPromoResponse promo(@AuthenticationPrincipal UUID userId) {
    return wrappedGenerationService.pendingPromo(userId);
  }

  @GetMapping("/api/v1/wrapped")
  public List<WrappedHistoryItemResponse> history(@AuthenticationPrincipal UUID userId) {
    return wrappedGenerationService.history(userId);
  }

  @GetMapping("/api/v1/wrapped/{year}/{month}")
  public WrappedResult get(
      @AuthenticationPrincipal UUID userId, @PathVariable int year, @PathVariable int month) {
    return wrappedGenerationService.getOrGenerate(userId, year, month);
  }

  @PostMapping("/api/v1/wrapped/{year}/{month}/viewed")
  public void markViewed(
      @AuthenticationPrincipal UUID userId, @PathVariable int year, @PathVariable int month) {
    wrappedGenerationService.markViewed(userId, year, month);
  }
}
