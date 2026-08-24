package com.duitlah.api.groups;

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
public class GroupGoalController {

  private final GroupGoalService goalService;

  public GroupGoalController(GroupGoalService goalService) {
    this.goalService = goalService;
  }

  @GetMapping("/api/v1/groups/{groupId}/goals")
  public List<GroupGoalResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return goalService.list(userId, groupId);
  }

  @GetMapping("/api/v1/groups/{groupId}/goals/{goalId}")
  public GroupGoalResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId, @PathVariable UUID goalId) {
    return goalService.get(userId, groupId, goalId);
  }

  @PostMapping("/api/v1/groups/{groupId}/goals")
  @ResponseStatus(HttpStatus.CREATED)
  public GroupGoalResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @Valid @RequestBody CreateGroupGoalRequest request) {
    return goalService.create(userId, groupId, request);
  }

  @PatchMapping("/api/v1/groups/{groupId}/goals/{goalId}")
  public GroupGoalResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @PathVariable UUID goalId,
      @Valid @RequestBody UpdateGroupGoalRequest request) {
    return goalService.update(userId, groupId, goalId, request);
  }

  @GetMapping("/api/v1/groups/{groupId}/goals/{goalId}/contributions")
  public List<GroupGoalContributionResponse> listContributions(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId, @PathVariable UUID goalId) {
    return goalService.listContributions(userId, groupId, goalId);
  }

  @PostMapping("/api/v1/groups/{groupId}/goals/{goalId}/contributions")
  @ResponseStatus(HttpStatus.CREATED)
  public GroupGoalResponse addContribution(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @PathVariable UUID goalId,
      @Valid @RequestBody CreateGroupGoalContributionRequest request) {
    return goalService.addContribution(userId, groupId, goalId, request);
  }

  @DeleteMapping("/api/v1/groups/{groupId}/goals/{goalId}/contributions/{contributionId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void deleteContribution(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @PathVariable UUID goalId,
      @PathVariable UUID contributionId) {
    goalService.deleteContribution(userId, groupId, goalId, contributionId);
  }
}
