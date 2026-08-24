package com.duitlah.api.liabilities;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.Account;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.AccountType;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Every "current state" number here (outstanding, available credit, utilization, statement balance)
 * is computed on read from {@link AccountService#balanceOf}/{@link AccountService#balanceAsOf} —
 * nothing is cached or stored, the same discipline as account balance itself.
 *
 * <p>A card's own {@code Account} balance goes negative as purchases (ordinary {@code EXPENSE}
 * transactions, {@code OUT} direction) accumulate, and climbs back toward zero as repayments
 * (ordinary transfers, {@code IN} direction on this account) are made — so "amount owed" is simply
 * {@code max(0, -balance)}, with no new transaction-writing logic needed anywhere.
 */
@Service
public class CreditCardService {

  private final CreditCardDetailsRepository details;
  private final AccountService accountService;

  public CreditCardService(CreditCardDetailsRepository details, AccountService accountService) {
    this.details = details;
    this.accountService = accountService;
  }

  @Transactional
  public CreditCardDetailsResponse setDetails(
      UUID userId, UUID accountId, SetCreditCardDetailsRequest request) {
    Account account = requireCreditCardAccount(userId, accountId);
    CreditCardDetails record =
        details
            .findByAccountId(accountId)
            .orElseGet(
                () ->
                    new CreditCardDetails(
                        accountId,
                        request.creditLimit(),
                        request.statementDay(),
                        request.paymentDueDay(),
                        request.minimumPaymentPercentOrDefault()));
    record.setCreditLimit(request.creditLimit());
    record.setStatementDay((short) request.statementDay());
    record.setPaymentDueDay((short) request.paymentDueDay());
    record.setMinimumPaymentPercent(request.minimumPaymentPercentOrDefault());
    details.save(record);
    return toResponse(record, account);
  }

  public CreditCardDetailsResponse get(UUID userId, UUID accountId) {
    Account account = requireCreditCardAccount(userId, accountId);
    CreditCardDetails record =
        details
            .findByAccountId(accountId)
            .orElseThrow(
                () ->
                    new NotFoundException(
                        "CREDIT_CARD_DETAILS_NOT_FOUND",
                        "Set up this card's credit limit and statement dates first."));
    return toResponse(record, account);
  }

  private CreditCardDetailsResponse toResponse(CreditCardDetails record, Account account) {
    BigDecimal currentOutstanding = accountService.balanceOf(account).negate().max(BigDecimal.ZERO);
    BigDecimal availableCredit =
        record.getCreditLimit().subtract(currentOutstanding).max(BigDecimal.ZERO);
    BigDecimal utilization =
        record.getCreditLimit().signum() == 0
            ? BigDecimal.ZERO
            : currentOutstanding.divide(record.getCreditLimit(), 4, RoundingMode.HALF_UP);

    LocalDate lastStatementDate = lastStatementDateFrom(LocalDate.now(), record.getStatementDay());
    BigDecimal statementBalance =
        accountService.balanceAsOf(account, lastStatementDate).negate().max(BigDecimal.ZERO);
    BigDecimal minimumPaymentDue =
        statementBalance
            .multiply(record.getMinimumPaymentPercent())
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

    return new CreditCardDetailsResponse(
        account.getId(),
        record.getCreditLimit(),
        record.getStatementDay(),
        record.getPaymentDueDay(),
        record.getMinimumPaymentPercent(),
        currentOutstanding,
        availableCredit,
        utilization,
        statementBalance,
        minimumPaymentDue);
  }

  /** The most recent past (or today's) occurrence of {@code statementDay}. */
  static LocalDate lastStatementDateFrom(LocalDate today, int statementDay) {
    LocalDate thisMonth = today.withDayOfMonth(statementDay);
    return thisMonth.isAfter(today) ? thisMonth.minusMonths(1) : thisMonth;
  }

  /**
   * Average utilization across every credit card that has details configured, for {@code
   * finhealth.FinancialHealthService} — {@link Optional#empty()} if the user has no configured
   * cards at all (that component is then excluded from the score rather than penalizing a user who
   * simply has no credit cards).
   */
  public Optional<BigDecimal> averageUtilizationForUser(List<Account> creditCardAccounts) {
    List<BigDecimal> utilizations = new ArrayList<>();
    for (Account account : creditCardAccounts) {
      details
          .findByAccountId(account.getId())
          .ifPresent(
              record -> {
                BigDecimal outstanding =
                    accountService.balanceOf(account).negate().max(BigDecimal.ZERO);
                if (record.getCreditLimit().signum() > 0) {
                  utilizations.add(
                      outstanding.divide(record.getCreditLimit(), 4, RoundingMode.HALF_UP));
                }
              });
    }
    if (utilizations.isEmpty()) {
      return Optional.empty();
    }
    BigDecimal sum = utilizations.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    return Optional.of(
        sum.divide(BigDecimal.valueOf(utilizations.size()), 4, RoundingMode.HALF_UP));
  }

  private Account requireCreditCardAccount(UUID userId, UUID accountId) {
    Account account = accountService.requireOwned(userId, accountId);
    if (account.getType() != AccountType.CREDIT_CARD) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "NOT_A_CREDIT_CARD_ACCOUNT", "This account isn't a credit card.");
    }
    return account;
  }
}
