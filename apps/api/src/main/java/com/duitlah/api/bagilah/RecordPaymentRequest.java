package com.duitlah.api.bagilah;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record RecordPaymentRequest(@NotNull @DecimalMin(value = "0.01") BigDecimal amountPaid) {}
