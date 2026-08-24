package com.duitlah.api.sales;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record ConvertQuotationRequest(@NotNull LocalDate dueDate) {}
