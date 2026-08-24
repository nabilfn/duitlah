package com.duitlah.api.bills;

import com.duitlah.api.notifications.NotificationService;
import java.time.LocalDate;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Daily status transitions plus reminders (spec section 16's own "reminders" requirement, wired
 * into the real notification architecture from section 24 rather than left as a TODO). Same "thin
 * `@Scheduled` wrapper around a plain, independently-callable/testable method" shape as {@code
 * recurring.RecurringTransactionScheduler}.
 */
@Component
public class PersonalBillScheduler {

  private static final Logger log = LoggerFactory.getLogger(PersonalBillScheduler.class);
  private static final int REMINDER_WINDOW_DAYS = 3;

  private final PersonalBillRepository bills;
  private final NotificationService notifications;

  public PersonalBillScheduler(PersonalBillRepository bills, NotificationService notifications) {
    this.bills = bills;
    this.notifications = notifications;
  }

  @Scheduled(cron = "0 10 0 * * *")
  @Transactional
  public void updateBillStatuses() {
    LocalDate today = LocalDate.now();

    List<PersonalBill> becomingDue =
        bills.findByStatusAndDueDateLessThanEqual(
            BillStatus.UPCOMING, today.plusDays(REMINDER_WINDOW_DAYS));
    for (PersonalBill bill : becomingDue) {
      bill.setStatus(BillStatus.DUE);
      bills.save(bill);
      notifications.notify(
          bill.getUserId(),
          "BILL_DUE_SOON",
          bill.getName() + " is due soon",
          bill.getName()
              + " (RM "
              + bill.getExpectedAmount()
              + ") is due on "
              + bill.getDueDate()
              + ".");
    }

    List<PersonalBill> becomingOverdue =
        bills.findByStatusInAndDueDateLessThan(List.of(BillStatus.UPCOMING, BillStatus.DUE), today);
    for (PersonalBill bill : becomingOverdue) {
      bill.setStatus(BillStatus.OVERDUE);
      bills.save(bill);
      notifications.notify(
          bill.getUserId(),
          "BILL_OVERDUE",
          bill.getName() + " is overdue",
          bill.getName()
              + " (RM "
              + bill.getExpectedAmount()
              + ") was due on "
              + bill.getDueDate()
              + ".");
    }

    if (!becomingDue.isEmpty() || !becomingOverdue.isEmpty()) {
      log.info(
          "Bill status update: {} became DUE, {} became OVERDUE",
          becomingDue.size(),
          becomingOverdue.size());
    }
  }
}
