package com.duitlah.api.groups;

import com.duitlah.api.settlements.SettlementResponse;
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
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GroupController {

  private final GroupService groupService;

  public GroupController(GroupService groupService) {
    this.groupService = groupService;
  }

  @GetMapping("/api/v1/groups")
  public List<GroupResponse> list(@AuthenticationPrincipal UUID userId) {
    return groupService.listForUser(userId);
  }

  @GetMapping("/api/v1/groups/{groupId}")
  public GroupResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.getForUser(userId, groupId);
  }

  @PostMapping("/api/v1/groups")
  @ResponseStatus(HttpStatus.CREATED)
  public GroupResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateGroupRequest request) {
    return groupService.create(userId, request);
  }

  @PatchMapping("/api/v1/groups/{groupId}")
  public GroupResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @Valid @RequestBody UpdateGroupRequest request) {
    return groupService.update(userId, groupId, request);
  }

  @PostMapping("/api/v1/groups/{groupId}/invite-token")
  public InviteTokenResponse regenerateInviteToken(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.regenerateInviteToken(userId, groupId);
  }

  @PostMapping("/api/v1/groups/join")
  public GroupResponse join(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody JoinGroupRequest request) {
    return groupService.join(userId, request);
  }

  @GetMapping("/api/v1/groups/{groupId}/members")
  public List<GroupMemberResponse> listMembers(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.listMembers(userId, groupId);
  }

  @DeleteMapping("/api/v1/groups/{groupId}/members/{targetUserId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removeMember(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @PathVariable UUID targetUserId) {
    groupService.removeMember(userId, groupId, targetUserId);
  }

  @GetMapping("/api/v1/groups/{groupId}/expenses")
  public List<GroupExpenseResponse> listExpenses(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.listExpenses(userId, groupId);
  }

  @PostMapping("/api/v1/groups/{groupId}/expenses")
  @ResponseStatus(HttpStatus.CREATED)
  public GroupExpenseResponse createExpense(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @Valid @RequestBody CreateGroupExpenseRequest request) {
    return groupService.createExpense(userId, groupId, request);
  }

  @DeleteMapping("/api/v1/groups/{groupId}/expenses/{expenseId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void deleteExpense(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @PathVariable UUID expenseId) {
    groupService.deleteExpense(userId, groupId, expenseId);
  }

  @GetMapping("/api/v1/groups/{groupId}/balances")
  public List<GroupBalanceResponse> getBalances(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.getBalances(userId, groupId);
  }

  @PostMapping("/api/v1/groups/{groupId}/settle")
  public List<SettlementResponse> settle(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.settleGroup(userId, groupId);
  }

  @PutMapping("/api/v1/groups/{groupId}/budget")
  public GroupBudgetResponse setBudget(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @Valid @RequestBody SetGroupBudgetRequest request) {
    return groupService.setBudget(userId, groupId, request);
  }

  @GetMapping("/api/v1/groups/{groupId}/budget")
  public GroupBudgetResponse getBudget(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.getBudget(userId, groupId);
  }

  @GetMapping("/api/v1/groups/{groupId}/trip-summary")
  public TripSummaryResponse tripSummary(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID groupId) {
    return groupService.tripSummary(userId, groupId);
  }

  @GetMapping("/api/v1/groups/{groupId}/housemate-dashboard")
  public HousemateDashboardResponse housemateDashboard(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID groupId,
      @RequestParam int year,
      @RequestParam int month) {
    return groupService.housemateDashboard(userId, groupId, year, month);
  }
}
