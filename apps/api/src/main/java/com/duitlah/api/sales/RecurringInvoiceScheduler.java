package com.duitlah.api.sales;

import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Same "thin {@code @Scheduled} wrapper around a plain, independently-callable/testable method"
 * shape as {@code recurring.RecurringTransactionScheduler}/{@code bills.PersonalBillScheduler} —
 * staggered a few minutes after both so every daily job doesn't contend for the same instant.
 */
@Component
public class RecurringInvoiceScheduler {

  private static final Logger log = LoggerFactory.getLogger(RecurringInvoiceScheduler.class);

  private final RecurringInvoiceService recurringInvoiceService;

  public RecurringInvoiceScheduler(RecurringInvoiceService recurringInvoiceService) {
    this.recurringInvoiceService = recurringInvoiceService;
  }

  @Scheduled(cron = "0 15 0 * * *")
  public void materializeDueRecurringInvoices() {
    int created = recurringInvoiceService.materializeAllDue(LocalDate.now());
    if (created > 0) {
      log.info("Materialized {} recurring invoice(s)", created);
    }
  }
}
