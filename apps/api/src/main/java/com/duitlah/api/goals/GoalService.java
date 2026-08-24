package com.duitlah.api.goals;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GoalService {

  private final GoalRepository goals;
  private final GoalContributionRepository contributions;

  public GoalService(GoalRepository goals, GoalContributionRepository contributions) {
    this.goals = goals;
    this.contributions = contributions;
  }

  public List<GoalResponse> listForUser(UUID userId) {
    return goals.findByUserIdOrderByCreatedAtAsc(userId).stream()
        .map(goal -> GoalResponse.of(goal, currentAmount(goal.getId())))
        .toList();
  }

  public GoalResponse getForUser(UUID userId, UUID goalId) {
    Goal goal = requireOwned(userId, goalId);
    return GoalResponse.of(goal, currentAmount(goal.getId()));
  }

  @Transactional
  public GoalResponse create(UUID userId, CreateGoalRequest request) {
    Goal goal =
        new Goal(
            userId, request.name(), request.type(), request.targetAmount(), request.targetDate());
    goals.save(goal);
    return GoalResponse.of(goal, BigDecimal.ZERO);
  }

  @Transactional
  public GoalResponse update(UUID userId, UUID goalId, UpdateGoalRequest request) {
    Goal goal = requireOwned(userId, goalId);
    goal.setName(request.name());
    goal.setType(request.type());
    goal.setTargetAmount(request.targetAmount());
    goal.setTargetDate(request.targetDate());
    goal.setArchivedAt(request.archived() ? Instant.now() : null);
    goals.save(goal);
    return GoalResponse.of(goal, currentAmount(goal.getId()));
  }

  public List<ContributionResponse> listContributions(UUID userId, UUID goalId) {
    requireOwned(userId, goalId);
    return contributions.findByGoalIdOrderByOccurredOnDescCreatedAtDesc(goalId).stream()
        .map(ContributionResponse::from)
        .toList();
  }

  @Transactional
  public GoalResponse addContribution(UUID userId, UUID goalId, CreateContributionRequest request) {
    Goal goal = requireOwned(userId, goalId);
    if (request.amount().signum() == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "ZERO_CONTRIBUTION", "Amount can't be zero.");
    }
    contributions.save(
        new GoalContribution(
            goal.getId(), userId, request.amount(), request.occurredOn(), request.note()));
    return GoalResponse.of(goal, currentAmount(goal.getId()));
  }

  @Transactional
  public void deleteContribution(UUID userId, UUID goalId, UUID contributionId) {
    requireOwned(userId, goalId);
    GoalContribution contribution =
        contributions
            .findByIdAndGoalId(contributionId, goalId)
            .orElseThrow(
                () -> new NotFoundException("CONTRIBUTION_NOT_FOUND", "Contribution not found."));
    contributions.delete(contribution);
  }

  private BigDecimal currentAmount(UUID goalId) {
    return contributions.sumAmountByGoalId(goalId);
  }

  private Goal requireOwned(UUID userId, UUID goalId) {
    return goals
        .findByIdAndUserId(goalId, userId)
        .orElseThrow(() -> new NotFoundException("GOAL_NOT_FOUND", "Goal not found."));
  }
}
