package com.duitlah.api.sales;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RecurringInvoiceRepository extends JpaRepository<RecurringInvoice, UUID> {

  List<RecurringInvoice> findBySpaceIdOrderByNextOccurrenceDateAsc(UUID spaceId);

  Optional<RecurringInvoice> findByIdAndSpaceId(UUID id, UUID spaceId);

  /**
   * Not space-scoped — scanned globally once a day, same shape as {@code
   * recurring.RecurringTransactionRepository}'s own due-schedule finder.
   */
  List<RecurringInvoice> findByActiveTrueAndNextOccurrenceDateLessThanEqual(LocalDate asOf);
}
