package com.duitlah.api.autotrack;

import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Server-side duplicate detection (spec section 12). This never discards a candidate on its own —
 * it only attaches a confidence-scored guess of which existing transaction it might already be;
 * {@link TransactionCandidateService} still records the candidate either way, and a human always
 * makes the final call (Keep Both / Merge / Ignore).
 *
 * <p>Amount is treated as a hard filter, not a scored signal: two genuinely different real-world
 * transactions sharing an exact amount, merchant, and a date within days of each other is rare
 * enough that requiring an exact match keeps this simple and precise, at the cost of never flagging
 * a duplicate whose amount was mis-parsed — an acceptable trade for a suggestion feature that a
 * human reviews anyway.
 */
@Service
public class DuplicateDetectionService {

  /**
   * Below this, a candidate is just PENDING — not every coincidental amount match is worth a
   * banner.
   */
  static final BigDecimal FLAG_THRESHOLD = new BigDecimal("0.5");

  private static final int WINDOW_DAYS = 3;

  private final TransactionRepository transactions;

  public DuplicateDetectionService(TransactionRepository transactions) {
    this.transactions = transactions;
  }

  public Optional<DuplicateMatch> detect(
      UUID userId, BigDecimal amount, String merchant, LocalDate date, UUID accountHint) {
    List<Transaction> window =
        transactions.findByUserIdAndOccurredOnBetween(
            userId, date.minusDays(WINDOW_DAYS), date.plusDays(WINDOW_DAYS));

    return window.stream()
        .filter(t -> t.getAmount().compareTo(amount) == 0)
        .map(t -> new DuplicateMatch(t.getId(), score(t, merchant, date, accountHint)))
        .filter(match -> match.confidence().compareTo(FLAG_THRESHOLD) >= 0)
        .max(Comparator.comparing(DuplicateMatch::confidence));
  }

  /** Pure scoring — package-visible so it can be unit-tested without a database. */
  static BigDecimal score(Transaction existing, String merchant, LocalDate date, UUID accountHint) {
    BigDecimal total = BigDecimal.ZERO;

    if (merchant != null && existing.getMerchant() != null) {
      String a = merchant.trim().toLowerCase();
      String b = existing.getMerchant().trim().toLowerCase();
      if (a.equals(b)) {
        total = total.add(new BigDecimal("0.5"));
      } else if (a.contains(b) || b.contains(a)) {
        total = total.add(new BigDecimal("0.3"));
      }
    }

    long daysApart =
        Math.abs(java.time.temporal.ChronoUnit.DAYS.between(date, existing.getOccurredOn()));
    if (daysApart == 0) {
      total = total.add(new BigDecimal("0.3"));
    } else if (daysApart == 1) {
      total = total.add(new BigDecimal("0.2"));
    } else {
      total = total.add(new BigDecimal("0.1"));
    }

    if (accountHint != null && accountHint.equals(existing.getAccountId())) {
      total = total.add(new BigDecimal("0.2"));
    }

    return total.min(BigDecimal.ONE);
  }
}
