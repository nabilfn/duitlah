package com.duitlah.api.liabilities;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record LiabilityResponse(
    UUID id,
    LiabilityType type,
    String name,
    String lender,
    BigDecimal originalAmount,
    BigDecimal outstandingPrincipal,
    BigDecimal interestRatePercent,
    BigDecimal instalmentAmount,
    LocalDate nextDueDate,
    LocalDate maturityDate,
    LiabilityStatus status) {

  public static LiabilityResponse of(Liability liability, BigDecimal outstandingPrincipal) {
    return new LiabilityResponse(
        liability.getId(),
        liability.getType(),
        liability.getName(),
        liability.getLender(),
        liability.getOriginalAmount(),
        outstandingPrincipal,
        liability.getInterestRatePercent(),
        liability.getInstalmentAmount(),
        liability.getNextDueDate(),
        liability.getMaturityDate(),
        liability.getStatus());
  }
}
