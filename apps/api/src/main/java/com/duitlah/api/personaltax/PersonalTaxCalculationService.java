package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Deterministic, no model call anywhere (spec section 29) — the literal pipeline the spec
 * describes: Income -&gt; Taxable income - Eligible reliefs = Chargeable income -&gt; Tax brackets
 * -&gt; Tax payable -&gt; Applicable rebates -&gt; Zakat -&gt; PCB already paid -&gt; Estimated
 * payable/refund.
 */
@Service
public class PersonalTaxCalculationService {

  private static final String DISCLAIMER =
      "This is an estimate for planning purposes only, based on the tax rules configured for this "
          + "Year of Assessment. It is not an official tax computation. Filing with LHDN remains "
          + "your own responsibility -- verify every figure against the official LHDN forms and "
          + "circulars before relying on it.";

  private final TaxYearService taxYearService;
  private final PersonalIncomeRecordRepository incomeRecords;
  private final ConfirmedTaxReliefRepository confirmedReliefs;
  private final PcbService pcbService;
  private final ZakatService zakatService;

  public PersonalTaxCalculationService(
      TaxYearService taxYearService,
      PersonalIncomeRecordRepository incomeRecords,
      ConfirmedTaxReliefRepository confirmedReliefs,
      PcbService pcbService,
      ZakatService zakatService) {
    this.taxYearService = taxYearService;
    this.incomeRecords = incomeRecords;
    this.confirmedReliefs = confirmedReliefs;
    this.pcbService = pcbService;
    this.zakatService = zakatService;
  }

  public PersonalTaxCalculationResponse calculate(UUID userId, int yearOfAssessment) {
    TaxYear taxYear = taxYearService.requireYear(yearOfAssessment);
    List<TaxReliefRule> reliefRules = taxYearService.reliefRulesFor(taxYear);

    BigDecimal totalIncome =
        incomeRecords.findByUserIdAndYearOfAssessment(userId, yearOfAssessment).stream()
            .map(PersonalIncomeRecord::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    List<TaxReliefLine> reliefLines = new ArrayList<>();
    BigDecimal totalReliefs = BigDecimal.ZERO;
    for (ConfirmedTaxRelief relief :
        confirmedReliefs.findByUserIdAndYearOfAssessment(userId, yearOfAssessment)) {
      BigDecimal maxAmount =
          reliefRules.stream()
              .filter(rule -> rule.getCategory() == relief.getCategory())
              .map(TaxReliefRule::getMaxAmount)
              .findFirst()
              .orElse(relief.getConfirmedAmount());
      BigDecimal claimed = relief.getConfirmedAmount().min(maxAmount);
      reliefLines.add(new TaxReliefLine(relief.getCategory().name(), claimed, maxAmount));
      totalReliefs = totalReliefs.add(claimed);
    }

    BigDecimal selfRelief = taxYear.getResidentIndividualRelief();
    BigDecimal chargeableIncome =
        totalIncome.subtract(selfRelief).subtract(totalReliefs).max(BigDecimal.ZERO);

    BigDecimal grossTaxPayable =
        applyBrackets(taxYearService.bracketsFor(taxYear), chargeableIncome);

    BigDecimal rebate =
        taxYearService.rebateRulesFor(taxYear).stream()
            .filter(rule -> chargeableIncome.compareTo(rule.getChargeableIncomeThreshold()) <= 0)
            .map(TaxRebateRule::getRebateAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .min(grossTaxPayable);
    BigDecimal taxAfterRebate = grossTaxPayable.subtract(rebate);

    BigDecimal zakatPaid = zakatService.totalFor(userId, yearOfAssessment);
    BigDecimal zakatRebate = zakatPaid.min(taxAfterRebate);
    BigDecimal taxAfterZakat = taxAfterRebate.subtract(zakatRebate);

    BigDecimal pcbPaid = pcbService.totalFor(userId, yearOfAssessment);
    BigDecimal estimatedPayableOrRefund = taxAfterZakat.subtract(pcbPaid);

    return new PersonalTaxCalculationResponse(
        yearOfAssessment,
        totalIncome,
        selfRelief,
        reliefLines,
        totalReliefs,
        chargeableIncome,
        grossTaxPayable,
        rebate,
        zakatPaid,
        zakatRebate,
        taxAfterZakat,
        pcbPaid,
        estimatedPayableOrRefund,
        DISCLAIMER);
  }

  /** Progressive: each bracket's rate applies only to the slice of income within its own band. */
  private static BigDecimal applyBrackets(List<TaxBracket> brackets, BigDecimal chargeableIncome) {
    BigDecimal tax = BigDecimal.ZERO;
    for (TaxBracket bracket : brackets) {
      if (chargeableIncome.compareTo(bracket.getLowerBound()) <= 0) {
        continue;
      }
      BigDecimal bandTop =
          bracket.getUpperBound() == null
              ? chargeableIncome
              : chargeableIncome.min(bracket.getUpperBound());
      BigDecimal slice = bandTop.subtract(bracket.getLowerBound());
      if (slice.signum() <= 0) {
        continue;
      }
      tax =
          tax.add(
              slice
                  .multiply(bracket.getRatePercent())
                  .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP));
    }
    return tax;
  }
}
