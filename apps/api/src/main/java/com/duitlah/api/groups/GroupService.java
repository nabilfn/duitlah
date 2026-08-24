package com.duitlah.api.groups;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.money.EqualSplitter;
import com.duitlah.api.common.security.SecureTokens;
import com.duitlah.api.settlements.DebtSimplifier;
import com.duitlah.api.settlements.SettlementResponse;
import com.duitlah.api.settlements.SettlementService;
import com.duitlah.api.settlements.SourceType;
import com.duitlah.api.subscriptions.SubscriptionService;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GroupService {

  /** Housemate mode's dashboard categories (product spec section 30) — a fixed subset. */
  private static final List<GroupExpenseCategory> HOUSEMATE_CATEGORIES =
      List.of(
          GroupExpenseCategory.RENT,
          GroupExpenseCategory.ELECTRICITY,
          GroupExpenseCategory.WATER,
          GroupExpenseCategory.INTERNET,
          GroupExpenseCategory.GROCERIES,
          GroupExpenseCategory.CLEANING,
          GroupExpenseCategory.HOUSEHOLD,
          GroupExpenseCategory.STREAMING);

  private final GroupRepository groups;
  private final GroupMemberRepository members;
  private final GroupExpenseRepository expenses;
  private final GroupExpenseShareRepository shares;
  private final GroupBudgetRepository budgets;
  private final UserRepository users;
  private final SettlementService settlementService;
  private final SubscriptionService subscriptionService;
  private final AuditLogService auditLogService;

  public GroupService(
      GroupRepository groups,
      GroupMemberRepository members,
      GroupExpenseRepository expenses,
      GroupExpenseShareRepository shares,
      GroupBudgetRepository budgets,
      UserRepository users,
      SettlementService settlementService,
      SubscriptionService subscriptionService,
      AuditLogService auditLogService) {
    this.groups = groups;
    this.members = members;
    this.expenses = expenses;
    this.shares = shares;
    this.budgets = budgets;
    this.users = users;
    this.settlementService = settlementService;
    this.subscriptionService = subscriptionService;
    this.auditLogService = auditLogService;
  }

  public List<GroupResponse> listForUser(UUID userId) {
    List<GroupMember> memberships = members.findByUserId(userId);
    Map<UUID, Group> groupsById =
        groups.findAllById(memberships.stream().map(GroupMember::getGroupId).toList()).stream()
            .collect(Collectors.toMap(Group::getId, Function.identity()));
    return memberships.stream()
        .map(
            m ->
                GroupResponse.of(
                    groupsById.get(m.getGroupId()),
                    m.getRole(),
                    members.findByGroupIdOrderByJoinedAtAsc(m.getGroupId()).size()))
        .toList();
  }

  public GroupResponse getForUser(UUID userId, UUID groupId) {
    Group group = requireGroup(groupId);
    GroupMember membership = requireMembership(userId, groupId);
    return GroupResponse.of(
        group, membership.getRole(), members.findByGroupIdOrderByJoinedAtAsc(groupId).size());
  }

  @Transactional
  public GroupResponse create(UUID userId, CreateGroupRequest request) {
    subscriptionService.requireActiveGroupCapacity(userId);
    Group group = new Group(userId, request.name(), request.type());
    groups.save(group);
    members.save(new GroupMember(group.getId(), userId, GroupMemberRole.OWNER));
    return GroupResponse.of(group, GroupMemberRole.OWNER, 1);
  }

  @Transactional
  public GroupResponse update(UUID userId, UUID groupId, UpdateGroupRequest request) {
    Group group = requireOwnedGroup(userId, groupId);
    boolean reactivating = group.isArchived() && !request.archived();
    if (reactivating) {
      subscriptionService.requireActiveGroupCapacity(userId);
    }
    group.setName(request.name());
    group.setType(request.type());
    group.setArchivedAt(request.archived() ? Instant.now() : null);
    groups.save(group);
    return GroupResponse.of(
        group, GroupMemberRole.OWNER, members.findByGroupIdOrderByJoinedAtAsc(groupId).size());
  }

  @Transactional
  public InviteTokenResponse regenerateInviteToken(UUID userId, UUID groupId) {
    Group group = requireOwnedGroup(userId, groupId);
    String rawToken = SecureTokens.generate();
    group.setInviteTokenHash(SecureTokens.hash(rawToken));
    groups.save(group);
    return new InviteTokenResponse(rawToken);
  }

  @Transactional
  public GroupResponse join(UUID userId, JoinGroupRequest request) {
    Group group =
        groups
            .findByInviteTokenHash(SecureTokens.hash(request.token()))
            .orElseThrow(
                () -> new NotFoundException("INVALID_INVITE", "This invite link is invalid."));
    if (!members.existsByGroupIdAndUserId(group.getId(), userId)) {
      members.save(new GroupMember(group.getId(), userId, GroupMemberRole.MEMBER));
    }
    GroupMemberRole role =
        members
            .findByGroupIdAndUserId(group.getId(), userId)
            .map(GroupMember::getRole)
            .orElse(GroupMemberRole.MEMBER);
    return GroupResponse.of(
        group, role, members.findByGroupIdOrderByJoinedAtAsc(group.getId()).size());
  }

  public List<GroupMemberResponse> listMembers(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    List<GroupMember> memberRows = members.findByGroupIdOrderByJoinedAtAsc(groupId);
    Map<UUID, User> usersById =
        users.findAllById(memberRows.stream().map(GroupMember::getUserId).toList()).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));
    return memberRows.stream()
        .map(
            m -> {
              User user = usersById.get(m.getUserId());
              return new GroupMemberResponse(
                  m.getUserId(),
                  user.getDisplayName(),
                  user.getEmail(),
                  m.getRole(),
                  m.getJoinedAt());
            })
        .toList();
  }

  @Transactional
  public void removeMember(UUID actingUserId, UUID groupId, UUID targetUserId) {
    requireGroup(groupId);
    GroupMember actingMembership = requireMembership(actingUserId, groupId);
    GroupMember target =
        members
            .findByGroupIdAndUserId(groupId, targetUserId)
            .orElseThrow(
                () -> new NotFoundException("MEMBER_NOT_FOUND", "This person isn't in the group."));

    boolean isSelf = actingUserId.equals(targetUserId);
    if (target.getRole() == GroupMemberRole.OWNER) {
      throw new ForbiddenException(
          "CANNOT_REMOVE_OWNER",
          "The group owner can't be removed. Transfer ownership isn't supported yet.");
    }
    if (!isSelf && actingMembership.getRole() != GroupMemberRole.OWNER) {
      throw new ForbiddenException(
          "NOT_GROUP_OWNER", "Only the group owner can remove other members.");
    }
    members.delete(target);
    auditLogService.record(
        actingUserId,
        AuditAction.PARTICIPANT_REMOVED,
        "Group",
        groupId,
        Map.of("removedUserId", targetUserId));
  }

  @Transactional
  public GroupExpenseResponse createExpense(
      UUID userId, UUID groupId, CreateGroupExpenseRequest request) {
    requireMembership(userId, groupId);
    List<GroupMember> allMembers = members.findByGroupIdOrderByJoinedAtAsc(groupId);
    Set<UUID> memberIds =
        allMembers.stream().map(GroupMember::getUserId).collect(Collectors.toSet());

    UUID paidByUserId = request.paidByUserId() != null ? request.paidByUserId() : userId;
    if (!memberIds.contains(paidByUserId)) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "PAYER_NOT_A_MEMBER",
          "The payer must be a member of this group.");
    }

    List<UUID> participantIds =
        (request.participantUserIds() == null || request.participantUserIds().isEmpty())
            ? allMembers.stream().map(GroupMember::getUserId).toList()
            : new ArrayList<>(new LinkedHashSet<>(request.participantUserIds()));
    for (UUID participantId : participantIds) {
      if (!memberIds.contains(participantId)) {
        throw new ApiException(
            HttpStatus.BAD_REQUEST,
            "PARTICIPANT_NOT_A_MEMBER",
            "Every participant must be a member of this group.");
      }
    }

    boolean anyCurrencyField =
        request.originalCurrency() != null
            || request.originalAmount() != null
            || request.exchangeRate() != null;
    boolean allCurrencyFields =
        request.originalCurrency() != null
            && request.originalAmount() != null
            && request.exchangeRate() != null;
    if (anyCurrencyField && !allCurrencyFields) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "INCOMPLETE_CURRENCY_SNAPSHOT",
          "originalCurrency, originalAmount, and exchangeRate must all be provided together.");
    }
    String normalizedCurrency = null;
    if (allCurrencyFields) {
      normalizedCurrency = request.originalCurrency().trim().toUpperCase();
      if (!normalizedCurrency.matches("[A-Z]{3}")) {
        throw new ApiException(
            HttpStatus.BAD_REQUEST,
            "INVALID_CURRENCY_CODE",
            "originalCurrency must be a 3-letter code, e.g. JPY.");
      }
    }

    GroupExpense expense =
        new GroupExpense(
            groupId,
            paidByUserId,
            userId,
            request.description(),
            request.amount(),
            request.occurredOn());
    expense.setCategory(request.category());
    if (allCurrencyFields) {
      expense.setOriginalCurrency(normalizedCurrency);
      expense.setOriginalAmount(request.originalAmount());
      expense.setExchangeRate(request.exchangeRate());
    }
    expenses.save(expense);

    List<BigDecimal> splitAmounts = EqualSplitter.split(request.amount(), participantIds.size());
    for (int i = 0; i < participantIds.size(); i++) {
      shares.save(
          new GroupExpenseShare(expense.getId(), participantIds.get(i), splitAmounts.get(i)));
    }

    return toExpenseResponse(expense);
  }

  public List<GroupExpenseResponse> listExpenses(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    return expenses.findByGroupIdOrderByOccurredOnDescCreatedAtDesc(groupId).stream()
        .map(this::toExpenseResponse)
        .toList();
  }

  @Transactional
  public void deleteExpense(UUID userId, UUID groupId, UUID expenseId) {
    GroupMember membership = requireMembership(userId, groupId);
    GroupExpense expense =
        expenses
            .findByIdAndGroupId(expenseId, groupId)
            .orElseThrow(() -> new NotFoundException("EXPENSE_NOT_FOUND", "Expense not found."));
    boolean canDelete =
        membership.getRole() == GroupMemberRole.OWNER
            || expense.getCreatedByUserId().equals(userId);
    if (!canDelete) {
      throw new ForbiddenException(
          "CANNOT_DELETE_EXPENSE",
          "Only the group owner or the person who logged this can delete it.");
    }
    expenses.delete(expense);
  }

  /**
   * {@code net} is the *currently unsettled* position: {@code totalPaid - totalShare} minus
   * whatever has already been carved out into fixed {@code Settlement} rows by a previous {@link
   * #settleGroup} call (see {@link SettlementService#netAlreadyGenerated}). Before this group has
   * ever been settled, that subtraction is always zero, so this is exactly the same number Phase 5
   * computed — the refinement only changes behavior once settling up actually happens.
   */
  public List<GroupBalanceResponse> getBalances(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    List<GroupMember> allMembers = members.findByGroupIdOrderByJoinedAtAsc(groupId);
    Map<UUID, User> usersById =
        users.findAllById(allMembers.stream().map(GroupMember::getUserId).toList()).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));

    return allMembers.stream()
        .map(
            m -> {
              BigDecimal totalPaid =
                  expenses.sumAmountByGroupIdAndPaidByUserId(groupId, m.getUserId());
              BigDecimal totalShare = shares.sumAmountByUserIdAndGroupId(m.getUserId(), groupId);
              BigDecimal alreadySettled =
                  settlementService.netAlreadyGenerated(SourceType.GROUP, groupId, m.getUserId());
              User user = usersById.get(m.getUserId());
              return new GroupBalanceResponse(
                  m.getUserId(),
                  user.getDisplayName(),
                  totalPaid,
                  totalShare,
                  totalPaid.subtract(totalShare).subtract(alreadySettled));
            })
        .toList();
  }

  /**
   * "Settle up": freezes the group's current unsettled net positions into fixed, independent {@link
   * com.duitlah.api.settlements.Settlement} obligations (product spec section 9), the same
   * moment-of-truth snapshot Bagilah bills get automatically at {@code finalize()}. Repeatable —
   * each call only settles whatever net delta has accumulated since the last call, never
   * double-counting (see {@link #getBalances}).
   */
  @Transactional
  public List<SettlementResponse> settleGroup(UUID userId, UUID groupId) {
    requireOwnedGroup(userId, groupId);
    List<GroupBalanceResponse> balances = getBalances(userId, groupId);
    List<DebtSimplifier.NetPosition> positions =
        balances.stream().map(b -> new DebtSimplifier.NetPosition(b.userId(), b.net())).toList();
    return settlementService.generateSettlements(SourceType.GROUP, groupId, positions);
  }

  private GroupExpenseResponse toExpenseResponse(GroupExpense expense) {
    List<GroupExpenseShare> expenseShares = shares.findByGroupExpenseId(expense.getId());
    Set<UUID> peopleIds = new LinkedHashSet<>();
    peopleIds.add(expense.getPaidByUserId());
    expenseShares.forEach(s -> peopleIds.add(s.getUserId()));
    Map<UUID, User> usersById =
        users.findAllById(peopleIds).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));

    List<GroupExpenseShareResponse> shareResponses =
        expenseShares.stream()
            .map(
                s ->
                    new GroupExpenseShareResponse(
                        s.getUserId(),
                        usersById.get(s.getUserId()).getDisplayName(),
                        s.getAmount()))
            .toList();

    return new GroupExpenseResponse(
        expense.getId(),
        expense.getDescription(),
        expense.getAmount(),
        expense.getOccurredOn(),
        expense.getPaidByUserId(),
        usersById.get(expense.getPaidByUserId()).getDisplayName(),
        shareResponses,
        expense.getCategory(),
        expense.getOriginalCurrency(),
        expense.getOriginalAmount(),
        expense.getExchangeRate());
  }

  /** Trip mode's overall budget (product spec section 32) — any member may set/update it. */
  @Transactional
  public GroupBudgetResponse setBudget(UUID userId, UUID groupId, SetGroupBudgetRequest request) {
    requireMembership(userId, groupId);
    GroupBudget budget =
        budgets
            .findByGroupId(groupId)
            .orElseGet(() -> new GroupBudget(groupId, request.amount(), userId));
    budget.setAmount(request.amount());
    budget.setUpdatedAt(Instant.now());
    budgets.save(budget);
    return toBudgetResponse(budget);
  }

  public GroupBudgetResponse getBudget(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    GroupBudget budget =
        budgets
            .findByGroupId(groupId)
            .orElseThrow(
                () -> new NotFoundException("BUDGET_NOT_SET", "This group has no budget set yet."));
    return toBudgetResponse(budget);
  }

  private GroupBudgetResponse toBudgetResponse(GroupBudget budget) {
    BigDecimal spent = expenses.sumAmountByGroupId(budget.getGroupId());
    return new GroupBudgetResponse(budget.getAmount(), spent, budget.getAmount().subtract(spent));
  }

  /**
   * Trip mode's summary (product spec section 32): the same overall budget/spent/remaining as
   * {@link #getBudget}, plus a category breakdown. {@code budgetAmount}/{@code remaining} are null
   * when no budget has been set yet — this endpoint still works for a trip that hasn't set one.
   */
  public TripSummaryResponse tripSummary(UUID userId, UUID groupId) {
    requireMembership(userId, groupId);
    BigDecimal spent = expenses.sumAmountByGroupId(groupId);
    GroupBudget budget = budgets.findByGroupId(groupId).orElse(null);
    BigDecimal budgetAmount = budget == null ? null : budget.getAmount();
    BigDecimal remaining = budget == null ? null : budget.getAmount().subtract(spent);
    List<TripSummaryResponse.CategoryAmount> byCategory =
        expenses.sumAmountGroupedByCategory(groupId).stream()
            .map(
                row ->
                    new TripSummaryResponse.CategoryAmount(
                        (GroupExpenseCategory) row[0], (BigDecimal) row[1]))
            .toList();
    return new TripSummaryResponse(budgetAmount, spent, remaining, byCategory);
  }

  /**
   * Housemate mode's dashboard (product spec section 30): for each fixed household category, was at
   * least one expense logged this month? A category with zero expenses reads "unpaid" even though
   * no bill may exist yet — an honest limitation of deriving payment status from expense existence
   * rather than tracking a real recurring-bill lifecycle, which Phase 10's recurring transactions
   * cover for personal finance but groups don't have yet.
   */
  public HousemateDashboardResponse housemateDashboard(
      UUID userId, UUID groupId, int year, int month) {
    requireMembership(userId, groupId);
    YearMonth ym = YearMonth.of(year, month);
    LocalDate from = ym.atDay(1);
    LocalDate to = ym.atEndOfMonth();
    Set<GroupExpenseCategory> present =
        new LinkedHashSet<>(expenses.findDistinctCategoriesInRange(groupId, from, to));
    List<HousemateDashboardResponse.CategoryStatus> statuses =
        HOUSEMATE_CATEGORIES.stream()
            .map(
                category ->
                    new HousemateDashboardResponse.CategoryStatus(
                        category, present.contains(category)))
            .toList();
    return new HousemateDashboardResponse(year, month, statuses);
  }

  private Group requireGroup(UUID groupId) {
    return groups
        .findById(groupId)
        .orElseThrow(() -> new NotFoundException("GROUP_NOT_FOUND", "Group not found."));
  }

  private GroupMember requireMembership(UUID userId, UUID groupId) {
    return members
        .findByGroupIdAndUserId(groupId, userId)
        .orElseThrow(() -> new NotFoundException("GROUP_NOT_FOUND", "Group not found."));
  }

  private Group requireOwnedGroup(UUID userId, UUID groupId) {
    Group group = requireGroup(groupId);
    GroupMember membership = requireMembership(userId, groupId);
    if (membership.getRole() != GroupMemberRole.OWNER) {
      throw new ForbiddenException("NOT_GROUP_OWNER", "Only the group owner can do this.");
    }
    return group;
  }
}
