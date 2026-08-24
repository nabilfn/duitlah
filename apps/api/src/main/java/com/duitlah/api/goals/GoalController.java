package com.duitlah.api.goals;

import jakarta.validation.Valid;
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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GoalController {

  private final GoalService goalService;

  public GoalController(GoalService goalService) {
    this.goalService = goalService;
  }

  @GetMapping("/api/v1/goals")
  public List<GoalResponse> list(@AuthenticationPrincipal UUID userId) {
    return goalService.listForUser(userId);
  }

  @GetMapping("/api/v1/goals/{goalId}")
  public GoalResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID goalId) {
    return goalService.getForUser(userId, goalId);
  }

  @PostMapping("/api/v1/goals")
  @ResponseStatus(HttpStatus.CREATED)
  public GoalResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateGoalRequest request) {
    return goalService.create(userId, request);
  }

  @PatchMapping("/api/v1/goals/{goalId}")
  public GoalResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID goalId,
      @Valid @RequestBody UpdateGoalRequest request) {
    return goalService.update(userId, goalId, request);
  }

  @GetMapping("/api/v1/goals/{goalId}/contributions")
  public List<ContributionResponse> listContributions(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID goalId) {
    return goalService.listContributions(userId, goalId);
  }

  @PostMapping("/api/v1/goals/{goalId}/contributions")
  @ResponseStatus(HttpStatus.CREATED)
  public GoalResponse addContribution(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID goalId,
      @Valid @RequestBody CreateContributionRequest request) {
    return goalService.addContribution(userId, goalId, request);
  }

  @DeleteMapping("/api/v1/goals/{goalId}/contributions/{contributionId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void deleteContribution(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID goalId,
      @PathVariable UUID contributionId) {
    goalService.deleteContribution(userId, goalId, contributionId);
  }
}
