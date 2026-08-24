package com.duitlah.api.assets;

import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Runs the current month's depreciation for every active asset that hasn't had it posted yet. Same
 * thin {@code @Scheduled} wrapper around a plain, independently-callable/testable method shape as
 * {@code bills.PersonalBillScheduler}.
 */
@Component
public class AssetDepreciationScheduler {

  private static final Logger log = LoggerFactory.getLogger(AssetDepreciationScheduler.class);

  private final DepreciationService depreciationService;

  public AssetDepreciationScheduler(DepreciationService depreciationService) {
    this.depreciationService = depreciationService;
  }

  @Scheduled(cron = "0 0 3 1 * *")
  public void runMonthlyDepreciation() {
    int posted = depreciationService.runAllDueForPeriod(LocalDate.now());
    if (posted > 0) {
      log.info("Monthly depreciation posted for {} asset(s)", posted);
    }
  }
}
