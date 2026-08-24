package com.duitlah.api.bizdashboard;

import java.math.BigDecimal;

public record BusinessDashboardResponse(
    BigDecimal cashPosition,
    BigDecimal totalReceivables,
    BigDecimal totalPayables,
    long customerCount,
    long supplierCount,
    long productCount,
    long openInvoiceCount,
    long unpaidExpenseCount) {}
