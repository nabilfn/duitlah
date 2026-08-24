package com.duitlah.api.accounting;

import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AccountingPeriodService {

  private final AccountingPeriodRepository periods;
  private final SpaceService spaceService;

  public AccountingPeriodService(AccountingPeriodRepository periods, SpaceService spaceService) {
    this.periods = periods;
    this.spaceService = spaceService;
  }

  @Transactional
  public AccountingPeriodResponse create(
      UUID userId, UUID spaceId, CreateAccountingPeriodRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    if (periods.existsOverlapping(spaceId, request.periodStart(), request.periodEnd())) {
      throw new ConflictException(
          "ACCOUNTING_PERIOD_OVERLAPS", "This period overlaps an existing accounting period.");
    }
    AccountingPeriod period =
        new AccountingPeriod(spaceId, request.periodStart(), request.periodEnd());
    periods.save(period);
    return AccountingPeriodResponse.of(period);
  }

  public List<AccountingPeriodResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return periods.findBySpaceIdOrderByPeriodStartDesc(spaceId).stream()
        .map(AccountingPeriodResponse::of)
        .toList();
  }

  @Transactional
  public AccountingPeriodResponse close(UUID userId, UUID spaceId, UUID periodId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    AccountingPeriod period = requireOwned(spaceId, periodId);
    period.setStatus(PeriodStatus.CLOSED);
    period.setClosedAt(Instant.now());
    periods.save(period);
    return AccountingPeriodResponse.of(period);
  }

  /** Used by {@link JournalEntryService} to reject a posting dated inside a closed period. */
  public boolean isDateInClosedPeriod(UUID spaceId, LocalDate date) {
    return periods
        .findCoveringDate(spaceId, date)
        .map(p -> p.getStatus() == PeriodStatus.CLOSED)
        .orElse(false);
  }

  public AccountingPeriod requireOwned(UUID spaceId, UUID periodId) {
    return periods
        .findByIdAndSpaceId(periodId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException(
                    "ACCOUNTING_PERIOD_NOT_FOUND", "Accounting period not found."));
  }
}
