package com.duitlah.api.budgets;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BudgetController {

  private final BudgetService budgetService;

  public BudgetController(BudgetService budgetService) {
    this.budgetService = budgetService;
  }

  @GetMapping("/api/v1/budgets")
  public List<BudgetResponse> list(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(required = false) Integer year,
      @RequestParam(required = false) Integer month) {
    LocalDate today = LocalDate.now();
    int periodYear = year != null ? year : today.getYear();
    int periodMonth = month != null ? month : today.getMonthValue();
    return budgetService.listForPeriod(userId, periodYear, periodMonth);
  }

  @PostMapping("/api/v1/budgets")
  @ResponseStatus(HttpStatus.CREATED)
  public BudgetResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateBudgetRequest request) {
    return budgetService.create(userId, request);
  }

  @PatchMapping("/api/v1/budgets/{budgetId}")
  public BudgetResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID budgetId,
      @Valid @RequestBody UpdateBudgetRequest request) {
    return budgetService.update(userId, budgetId, request);
  }

  @DeleteMapping("/api/v1/budgets/{budgetId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID budgetId) {
    budgetService.delete(userId, budgetId);
  }
}
