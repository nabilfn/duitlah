package com.duitlah.api.autotrack;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class DuplicateDetectionServiceTest {

  private static Transaction transactionAt(UUID accountId, String merchant, LocalDate date) {
    return new Transaction(
        UUID.randomUUID(),
        accountId,
        TransactionType.EXPENSE,
        TransactionDirection.OUT,
        null,
        null,
        new BigDecimal("18.90"),
        merchant,
        null,
        null,
        date);
  }

  @Test
  void exactMerchantSameDaySameAccountScoresAtOrAboveFlagThreshold() {
    UUID accountId = UUID.randomUUID();
    Transaction existing = transactionAt(accountId, "ZUS Coffee", LocalDate.of(2026, 8, 22));

    BigDecimal score =
        DuplicateDetectionService.score(
            existing, "ZUS Coffee", LocalDate.of(2026, 8, 22), accountId);

    assertThat(score).isEqualByComparingTo("1.00");
    assertThat(score.compareTo(DuplicateDetectionService.FLAG_THRESHOLD)).isGreaterThanOrEqualTo(0);
  }

  @Test
  void differentMerchantSeveralDaysApartAndNoAccountHintScoresBelowThreshold() {
    Transaction existing =
        transactionAt(UUID.randomUUID(), "ZUS Coffee", LocalDate.of(2026, 8, 22));

    BigDecimal score =
        DuplicateDetectionService.score(existing, "Starbucks", LocalDate.of(2026, 8, 19), null);

    assertThat(score.compareTo(DuplicateDetectionService.FLAG_THRESHOLD)).isLessThan(0);
  }

  @Test
  void nullMerchantStillScoresOnDateAndAccountAlone() {
    UUID accountId = UUID.randomUUID();
    Transaction existing = transactionAt(accountId, null, LocalDate.of(2026, 8, 22));

    BigDecimal score =
        DuplicateDetectionService.score(existing, null, LocalDate.of(2026, 8, 22), accountId);

    // date (0.3) + account (0.2), no merchant signal either way
    assertThat(score).isEqualByComparingTo("0.50");
  }
}
