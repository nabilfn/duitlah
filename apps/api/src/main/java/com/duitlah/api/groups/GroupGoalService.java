package com.duitlah.api.groups;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Shared goals (product spec section 27) — the group-scoped counterpart to {@link
 * com.duitlah.api.goals.GoalService}. Any member may create a goal or contribute to it; only the
 * group owner or the contributor themselves may delete a contribution, the same permission shape as
 * {@link GroupService#deleteExpense}.
 */
@Service
public class GroupGoalService {

  private final GroupGoalRepository goals;
  private final GroupGoalContributionRepository contributions;
  private final GroupRepository groups;
  private final GroupMemberRepository members;
  private final UserRepository users;

  public GroupGoalService(
      GroupGoalRepository goals,
      GroupGoalContributionRepository contributions,
      GroupRepository groups,
      GroupMemberRepository members,
      UserRepository users) {
    this.goals = goals;
    this.contributions = contributions;
    this.groups = groups;
    this.members = members;
    this.users = users;
  }

  public List<GroupGoalResponse> list(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    return goals.findByGroupIdOrderByCreatedAtAsc(groupId).stream().map(this::toResponse).toList();
  }

  public GroupGoalResponse get(UUID userId, UUID groupId, UUID goalId) {
    requireMembership(userId, groupId);
    return toResponse(requireGoal(groupId, goalId));
  }

  @Transactional
  public GroupGoalResponse create(UUID userId, UUID groupId, CreateGroupGoalRequest request) {
    requireMembership(userId, groupId);
    GroupGoal goal =
        new GroupGoal(
            groupId, request.name(), request.targetAmount(), request.targetDate(), userId);
    goals.save(goal);
    return GroupGoalResponse.of(goal, BigDecimal.ZERO, List.of());
  }

  @Transactional
  public GroupGoalResponse update(
      UUID userId, UUID groupId, UUID goalId, UpdateGroupGoalRequest request) {
    requireMembership(userId, groupId);
    GroupGoal goal = requireGoal(groupId, goalId);
    goal.setName(request.name());
    goal.setTargetAmount(request.targetAmount());
    goal.setTargetDate(request.targetDate());
    goal.setArchivedAt(request.archived() ? Instant.now() : null);
    goals.save(goal);
    return toResponse(goal);
  }

  public List<GroupGoalContributionResponse> listContributions(
      UUID userId, UUID groupId, UUID goalId) {
    requireMembership(userId, groupId);
    requireGoal(groupId, goalId);
    List<GroupGoalContribution> rows =
        contributions.findByGroupGoalIdOrderByOccurredOnDescCreatedAtDesc(goalId);
    Map<UUID, User> usersById =
        users.findAllById(rows.stream().map(GroupGoalContribution::getUserId).toList()).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));
    return rows.stream()
        .map(
            c ->
                new GroupGoalContributionResponse(
                    c.getId(),
                    c.getUserId(),
                    usersById.get(c.getUserId()).getDisplayName(),
                    c.getAmount(),
                    c.getOccurredOn(),
                    c.getNote()))
        .toList();
  }

  @Transactional
  public GroupGoalResponse addContribution(
      UUID userId, UUID groupId, UUID goalId, CreateGroupGoalContributionRequest request) {
    requireMembership(userId, groupId);
    GroupGoal goal = requireGoal(groupId, goalId);
    if (request.amount().signum() == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "ZERO_CONTRIBUTION", "Amount can't be zero.");
    }
    contributions.save(
        new GroupGoalContribution(
            goal.getId(), userId, request.amount(), request.occurredOn(), request.note()));
    return toResponse(goal);
  }

  @Transactional
  public void deleteContribution(UUID userId, UUID groupId, UUID goalId, UUID contributionId) {
    GroupMember membership = requireMembership(userId, groupId);
    requireGoal(groupId, goalId);
    GroupGoalContribution contribution =
        contributions
            .findByIdAndGroupGoalId(contributionId, goalId)
            .orElseThrow(
                () -> new NotFoundException("CONTRIBUTION_NOT_FOUND", "Contribution not found."));
    boolean canDelete =
        membership.getRole() == GroupMemberRole.OWNER || contribution.getUserId().equals(userId);
    if (!canDelete) {
      throw new ForbiddenException(
          "CANNOT_DELETE_CONTRIBUTION",
          "Only the group owner or the person who logged this can delete it.");
    }
    contributions.delete(contribution);
  }

  private GroupGoalResponse toResponse(GroupGoal goal) {
    BigDecimal currentAmount = contributions.sumAmountByGroupGoalId(goal.getId());
    List<Object[]> grouped = contributions.sumAmountGroupedByUser(goal.getId());
    Map<UUID, User> usersById =
        users.findAllById(grouped.stream().map(row -> (UUID) row[0]).toList()).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));
    List<GroupGoalResponse.MemberContribution> byMember =
        grouped.stream()
            .map(
                row -> {
                  UUID memberId = (UUID) row[0];
                  BigDecimal total = (BigDecimal) row[1];
                  return new GroupGoalResponse.MemberContribution(
                      memberId, usersById.get(memberId).getDisplayName(), total);
                })
            .toList();
    return GroupGoalResponse.of(goal, currentAmount, byMember);
  }

  private GroupGoal requireGoal(UUID groupId, UUID goalId) {
    return goals
        .findByIdAndGroupId(goalId, groupId)
        .orElseThrow(() -> new NotFoundException("GOAL_NOT_FOUND", "Goal not found."));
  }

  private GroupMember requireMembership(UUID userId, UUID groupId) {
    groups
        .findById(groupId)
        .orElseThrow(() -> new NotFoundException("GROUP_NOT_FOUND", "Group not found."));
    return members
        .findByGroupIdAndUserId(groupId, userId)
        .orElseThrow(() -> new NotFoundException("GROUP_NOT_FOUND", "Group not found."));
  }
}
