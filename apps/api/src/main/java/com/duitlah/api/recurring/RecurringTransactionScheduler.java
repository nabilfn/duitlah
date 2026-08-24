package com.duitlah.api.recurring;

import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Posts due recurring transactions once a day. Deliberately a thin wrapper around {@link
 * RecurringTransactionService#materializeAllDue} — the actual logic lives in a plain
 * `@Transactional` method precisely so it stays callable (and testable) without a scheduler
 * trigger, rather than living inline in a `@Scheduled` method where only a full Spring context with
 * real wall-clock time could ever exercise it.
 */
@Component
public class RecurringTransactionScheduler {

  private static final Logger log = LoggerFactory.getLogger(RecurringTransactionScheduler.class);

  private final RecurringTransactionService recurringTransactionService;

  public RecurringTransactionScheduler(RecurringTransactionService recurringTransactionService) {
    this.recurringTransactionService = recurringTransactionService;
  }

  @Scheduled(cron = "0 5 0 * * *")
  public void materializeDueRecurringTransactions() {
    int created = recurringTransactionService.materializeAllDue(LocalDate.now());
    if (created > 0) {
      log.info("Materialized {} recurring transaction(s)", created);
    }
  }
}
