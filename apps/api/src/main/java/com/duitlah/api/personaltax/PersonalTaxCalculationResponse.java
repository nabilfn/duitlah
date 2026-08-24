package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;

/**
 * Every intermediate figure in the spec's own pipeline (section 29) is shown, not just the final
 * number — an estimate a user can't trace back to its inputs isn't trustworthy. {@code disclaimer}
 * is never omitted (spec: "always provide a disclaimer that the result is an estimate").
 */
public record PersonalTaxCalculationResponse(
    int yearOfAssessment,
    BigDecimal totalIncome,
    BigDecimal residentIndividualRelief,
    List<TaxReliefLine> reliefs,
    BigDecimal totalReliefs,
    BigDecimal chargeableIncome,
    BigDecimal grossTaxPayable,
    BigDecimal rebate,
    BigDecimal zakatPaid,
    BigDecimal zakatRebate,
    BigDecimal taxAfterRebatesAndZakat,
    BigDecimal pcbPaid,
    BigDecimal estimatedPayableOrRefund,
    String disclaimer) {}
