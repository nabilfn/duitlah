package com.duitlah.api.sales;

import jakarta.validation.constraints.NotNull;

public record ChangeInvoiceStatusRequest(@NotNull InvoiceStatus status) {}
