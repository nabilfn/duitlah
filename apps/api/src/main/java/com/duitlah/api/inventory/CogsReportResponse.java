package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.time.LocalDate;

public record CogsReportResponse(LocalDate from, LocalDate to, BigDecimal totalCogs) {}
