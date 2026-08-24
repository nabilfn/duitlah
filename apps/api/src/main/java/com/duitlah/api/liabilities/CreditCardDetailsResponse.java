package com.duitlah.api.liabilities;

import java.math.BigDecimal;
import java.util.UUID;

public record CreditCardDetailsResponse(
    UUID accountId,
    BigDecimal creditLimit,
    int statementDay,
    int paymentDueDay,
    BigDecimal minimumPaymentPercent,
    BigDecimal currentOutstanding,
    BigDecimal availableCredit,
    BigDecimal utilization,
    BigDecimal statementBalance,
    BigDecimal minimumPaymentDue) {}
