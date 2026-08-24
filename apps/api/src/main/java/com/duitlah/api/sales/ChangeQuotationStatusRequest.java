package com.duitlah.api.sales;

import jakarta.validation.constraints.NotNull;

public record ChangeQuotationStatusRequest(@NotNull QuotationStatus status) {}
