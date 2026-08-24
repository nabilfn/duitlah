package com.duitlah.api.sales;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RecurringInvoiceLineItemRepository
    extends JpaRepository<RecurringInvoiceLineItem, UUID> {

  List<RecurringInvoiceLineItem> findByRecurringInvoiceIdOrderBySortOrderAsc(
      UUID recurringInvoiceId);

  void deleteByRecurringInvoiceId(UUID recurringInvoiceId);
}
