package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;

public record FilingReadinessResponse(
    int yearOfAssessment, BigDecimal readyPercent, List<FilingReadinessItem> items) {}
