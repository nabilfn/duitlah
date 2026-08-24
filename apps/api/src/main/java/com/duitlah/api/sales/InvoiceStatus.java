package com.duitlah.api.sales;

/** The three explicit actions a user takes. See package-info for why PAID/OVERDUE aren't here. */
public enum InvoiceStatus {
  DRAFT,
  SENT,
  VOID
}
