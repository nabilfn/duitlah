package com.duitlah.api.bizbanking;

import com.duitlah.api.accounting.ChartOfAccountsService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Balance is always computed, never stored — see the package-info and {@code
 * finance.AccountService} for the same discipline applied to personal accounts.
 */
@Service
public class BusinessAccountService {

  private final BusinessAccountRepository accounts;
  private final BusinessAccountEntryRepository entries;
  private final SpaceService spaceService;
  private final ChartOfAccountsService chartOfAccounts;

  public BusinessAccountService(
      BusinessAccountRepository accounts,
      BusinessAccountEntryRepository entries,
      SpaceService spaceService,
      ChartOfAccountsService chartOfAccounts) {
    this.accounts = accounts;
    this.entries = entries;
    this.spaceService = spaceService;
    this.chartOfAccounts = chartOfAccounts;
  }

  @Transactional
  public BusinessAccountResponse create(
      UUID userId, UUID spaceId, CreateBusinessAccountRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessAccount account =
        new BusinessAccount(
            spaceId,
            request.name().trim(),
            request.type(),
            request.currencyOrDefault(),
            request.openingBalanceOrZero());
    accounts.save(account);
    return BusinessAccountResponse.from(account, request.openingBalanceOrZero());
  }

  public List<BusinessAccountResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return accounts.findBySpaceIdOrderByCreatedAtAsc(spaceId).stream()
        .map(account -> BusinessAccountResponse.from(account, balanceOf(account)))
        .toList();
  }

  public BusinessAccountResponse get(UUID userId, UUID spaceId, UUID accountId) {
    spaceService.requireMembership(userId, spaceId);
    BusinessAccount account = requireOwned(spaceId, accountId);
    return BusinessAccountResponse.from(account, balanceOf(account));
  }

  @Transactional
  public BusinessAccountResponse update(
      UUID userId, UUID spaceId, UUID accountId, UpdateBusinessAccountRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessAccount account = requireOwned(spaceId, accountId);
    account.setName(request.name().trim());
    account.setType(request.type());
    if (request.openingBalance() != null) {
      account.setOpeningBalance(request.openingBalance());
    }
    account.setArchivedAt(request.archived() ? Instant.now() : null);
    accounts.save(account);
    return BusinessAccountResponse.from(account, balanceOf(account));
  }

  public List<EntryResponse> listEntries(UUID userId, UUID spaceId, UUID accountId) {
    spaceService.requireMembership(userId, spaceId);
    requireOwned(spaceId, accountId);
    return entries.findByBusinessAccountIdOrderByOccurredOnDescCreatedAtDesc(accountId).stream()
        .map(EntryResponse::of)
        .toList();
  }

  /**
   * Public — {@code reconciliation}'s matching engine needs the real entities (occurredOn,
   * signedAmount) to compare against parsed statement lines, not just the response DTO. Caller is
   * expected to have already validated the account with {@link #requireOwned}.
   */
  public List<BusinessAccountEntry> listEntryEntities(UUID accountId) {
    return entries.findByBusinessAccountIdOrderByOccurredOnDescCreatedAtDesc(accountId);
  }

  @Transactional
  public EntryResponse addEntry(
      UUID userId, UUID spaceId, UUID accountId, CreateEntryRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    requireOwned(spaceId, accountId);
    BusinessAccountEntry entry =
        new BusinessAccountEntry(
            accountId,
            request.direction(),
            request.amount(),
            request.occurredOn(),
            request.description());
    entries.save(entry);
    return EntryResponse.of(entry);
  }

  @Transactional
  public void transfer(UUID userId, UUID spaceId, UUID fromAccountId, TransferRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessAccount from = requireOwned(spaceId, fromAccountId);
    BusinessAccount to = requireOwned(spaceId, request.toBusinessAccountId());
    UUID transferGroupId = UUID.randomUUID();
    BusinessAccountEntry out =
        new BusinessAccountEntry(
            from.getId(),
            EntryDirection.OUT,
            request.amount(),
            request.occurredOn(),
            request.description());
    out.setTransferGroupId(transferGroupId);
    BusinessAccountEntry in =
        new BusinessAccountEntry(
            to.getId(),
            EntryDirection.IN,
            request.amount(),
            request.occurredOn(),
            request.description());
    in.setTransferGroupId(transferGroupId);
    entries.save(out);
    entries.save(in);
  }

  public BigDecimal balanceOf(BusinessAccount account) {
    return account
        .getOpeningBalance()
        .add(entries.sumSignedAmountByBusinessAccountId(account.getId()));
  }

  /** Used by {@code bizexpenses} when a supplier bill is paid — money flows OUT of the account. */
  public void recordExpensePayment(
      UUID businessAccountId,
      BigDecimal amount,
      java.time.LocalDate occurredOn,
      String description,
      UUID expensePaymentId) {
    BusinessAccountEntry entry =
        new BusinessAccountEntry(
            businessAccountId, EntryDirection.OUT, amount, occurredOn, description);
    entry.setLinkedExpensePaymentId(expensePaymentId);
    entries.save(entry);
  }

  /** Used by {@code sales} when a customer pays an invoice — money flows IN to the account. */
  public void recordInvoicePayment(
      UUID businessAccountId,
      BigDecimal amount,
      java.time.LocalDate occurredOn,
      String description,
      UUID invoicePaymentId) {
    BusinessAccountEntry entry =
        new BusinessAccountEntry(
            businessAccountId, EntryDirection.IN, amount, occurredOn, description);
    entry.setLinkedInvoicePaymentId(invoicePaymentId);
    entries.save(entry);
  }

  /**
   * V2 Phase 6 — links this account to a Chart of Accounts entry so automatic posting (invoice/
   * expense payments) knows which ledger account to move. Gated by {@code MANAGE_BOOKS} since it's
   * an accounting-classification decision, not a banking operation.
   */
  @Transactional
  public BusinessAccountResponse mapToChartOfAccounts(
      UUID userId, UUID spaceId, UUID accountId, UUID chartOfAccountsId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    BusinessAccount account = requireOwned(spaceId, accountId);
    if (chartOfAccountsId != null) {
      chartOfAccounts.requireOwned(spaceId, chartOfAccountsId);
    }
    account.setChartOfAccountsId(chartOfAccountsId);
    accounts.save(account);
    return BusinessAccountResponse.from(account, balanceOf(account));
  }

  public BusinessAccount requireOwned(UUID spaceId, UUID accountId) {
    return accounts
        .findByIdAndSpaceId(accountId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException("BUSINESS_ACCOUNT_NOT_FOUND", "Business account not found."));
  }
}
