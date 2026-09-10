package com.duitlah.api.wrapped;

import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.time.YearMonth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Pre-generates every user's just-completed month the moment it's over (spec section 24: "1
 * September -&gt; generate August Wrapped"), so the Home promo card and history are already
 * populated rather than generating on first access. Same "thin {@code @Scheduled} wrapper around a
 * plain, independently-callable/testable method" shape as every other daily job in this codebase
 * ({@code recurring.RecurringTransactionScheduler}, {@code bills.PersonalBillScheduler}). {@link
 * WrappedGenerationService#getOrGenerate} is still the safety net for anyone this run misses (a
 * user who registers after it runs, a job that fails partway through) — it lazily generates on
 * first real request either way.
 */
@Component
public class MonthlyWrappedScheduler {

  private static final Logger log = LoggerFactory.getLogger(MonthlyWrappedScheduler.class);

  private final UserRepository users;
  private final WrappedGenerationService wrappedGenerationService;

  public MonthlyWrappedScheduler(
      UserRepository users, WrappedGenerationService wrappedGenerationService) {
    this.users = users;
    this.wrappedGenerationService = wrappedGenerationService;
  }

  @Scheduled(cron = "0 30 1 1 * *")
  public void generateLastMonthForEveryUser() {
    YearMonth lastMonth = YearMonth.now().minusMonths(1);
    int generated = 0;
    for (User user : users.findAll()) {
      try {
        wrappedGenerationService.getOrGenerate(
            user.getId(), lastMonth.getYear(), lastMonth.getMonthValue());
        generated++;
      } catch (Exception e) {
        log.warn("Failed to generate Monthly Wrapped for user {}", user.getId(), e);
      }
    }
    log.info("Generated {} Monthly Wrapped result(s) for {}", generated, lastMonth);
  }
}
