package com.duitlah.api.businesstax;

import java.math.BigDecimal;
import java.time.LocalDate;

public record SstRateResponse(
    SstTaxType taxType,
    BigDecimal ratePercent,
    LocalDate effectiveFrom,
    LocalDate effectiveTo,
    String description) {

  public static SstRateResponse of(SstRate rate) {
    return new SstRateResponse(
        rate.getTaxType(),
        rate.getRatePercent(),
        rate.getEffectiveFrom(),
        rate.getEffectiveTo(),
        rate.getDescription());
  }
}
