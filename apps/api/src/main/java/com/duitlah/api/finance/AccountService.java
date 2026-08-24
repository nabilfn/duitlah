package com.duitlah.api.finance;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.transactions.TransactionRepository;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Account balance is always computed, never stored: openingBalance plus the signed sum of the
 * account's own transactions (see {@link TransactionRepository#sumSignedAmountByAccountId}). A
 * denormalized running-balance column would need every transaction write (and edit, and delete) to
 * update it in lockstep — one missed path and the number quietly drifts from the truth. For
 * personal-finance transaction volumes, a derived value that can never be wrong beats a cached one
 * that might be.
 */
@Service
public class AccountService {

  private final AccountRepository accounts;
  private final TransactionRepository transactions;

  public AccountService(AccountRepository accounts, TransactionRepository transactions) {
    this.accounts = accounts;
    this.transactions = transactions;
  }

  public List<AccountResponse> listForUser(UUID userId) {
    return accounts.findByUserIdOrderByCreatedAtAsc(userId).stream()
        .map(account -> AccountResponse.from(account, balanceOf(account)))
        .toList();
  }

  public AccountResponse getForUser(UUID userId, UUID accountId) {
    Account account = requireOwned(userId, accountId);
    return AccountResponse.from(account, balanceOf(account));
  }

  @Transactional
  public AccountResponse create(UUID userId, CreateAccountRequest request) {
    Account account =
        new Account(
            userId,
            request.name(),
            request.type(),
            request.currencyOrDefault(),
            request.openingBalanceOrZero());
    accounts.save(account);
    return AccountResponse.from(account, request.openingBalanceOrZero());
  }

  @Transactional
  public AccountResponse update(UUID userId, UUID accountId, UpdateAccountRequest request) {
    Account account = requireOwned(userId, accountId);
    account.setName(request.name());
    account.setType(request.type());
    account.setOpeningBalance(request.openingBalance());
    account.setArchivedAt(request.archived() ? Instant.now() : null);
    accounts.save(account);
    return AccountResponse.from(account, balanceOf(account));
  }

  public BigDecimal balanceOf(Account account) {
    return account
        .getOpeningBalance()
        .add(transactions.sumSignedAmountByAccountId(account.getId()));
  }

  /**
   * Same formula as {@link #balanceOf}, as of a specific past date — see {@code CreditCardService}.
   */
  public BigDecimal balanceAsOf(Account account, java.time.LocalDate date) {
    return account
        .getOpeningBalance()
        .add(
            transactions.sumSignedAmountByAccountIdAndOccurredOnLessThanEqual(
                account.getId(), date));
  }

  /**
   * Summed only across non-archived MYR accounts — Duitlah is MYR-first for now (see
   * docs/database.md), and naively adding balances across currencies would produce a meaningless
   * number, not just an imprecise one. Shared by the dashboard and cash-flow forecasting so both
   * agree on what "current balance" means.
   */
  public BigDecimal totalAvailableBalance(UUID userId) {
    return listForUser(userId).stream()
        .filter(a -> !a.archived() && "MYR".equals(a.currency()))
        .map(AccountResponse::balance)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  /**
   * Real entities (not response DTOs) — used by {@code liabilities.CreditCardService}, which needs
   * each account's id to look up its {@code CreditCardDetails} row.
   */
  public List<Account> listCreditCardAccountEntities(UUID userId) {
    return accounts.findByUserIdOrderByCreatedAtAsc(userId).stream()
        .filter(a -> !a.isArchived() && a.getType() == AccountType.CREDIT_CARD)
        .toList();
  }

  public Account requireOwned(UUID userId, UUID accountId) {
    return accounts
        .findByIdAndUserId(accountId, userId)
        .orElseThrow(() -> new NotFoundException("ACCOUNT_NOT_FOUND", "Account not found."));
  }
}
