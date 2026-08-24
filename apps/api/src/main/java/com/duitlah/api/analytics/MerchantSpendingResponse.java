package com.duitlah.api.analytics;

import java.math.BigDecimal;

public record MerchantSpendingResponse(String merchant, BigDecimal amount, long transactionCount) {}
