package com.duitlah.api.sales;

/** Never stored — always derived. See {@code InvoiceService} and package-info. */
public enum InvoiceEffectiveStatus {
  DRAFT,
  SENT,
  PARTIALLY_PAID,
  PAID,
  OVERDUE,
  VOID
}
