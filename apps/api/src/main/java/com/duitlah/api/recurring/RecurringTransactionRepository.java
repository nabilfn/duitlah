package com.duitlah.api.recurring;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RecurringTransactionRepository extends JpaRepository<RecurringTransaction, UUID> {

  Optional<RecurringTransaction> findByIdAndUserId(UUID id, UUID userId);

  List<RecurringTransaction> findByUserIdOrderByNextOccurrenceDateAsc(UUID userId);

  List<RecurringTransaction>
      findByUserIdAndSubscriptionTrueAndActiveTrueOrderByNextOccurrenceDateAsc(UUID userId);

  List<RecurringTransaction> findByUserIdAndActiveTrueOrderByNextOccurrenceDateAsc(UUID userId);

  /** Every user's due rules — scanned once a day by the materialization job, not user-scoped. */
  List<RecurringTransaction> findByActiveTrueAndNextOccurrenceDateLessThanEqual(LocalDate asOf);
}
