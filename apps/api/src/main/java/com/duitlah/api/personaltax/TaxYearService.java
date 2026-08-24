package com.duitlah.api.personaltax;

import com.duitlah.api.common.error.ApiException;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

/** The one place a Year of Assessment's full rule set (brackets/reliefs/rebates) is resolved. */
@Service
public class TaxYearService {

  private final TaxYearRepository taxYears;
  private final TaxBracketRepository brackets;
  private final TaxReliefRuleRepository reliefRules;
  private final TaxRebateRuleRepository rebateRules;

  public TaxYearService(
      TaxYearRepository taxYears,
      TaxBracketRepository brackets,
      TaxReliefRuleRepository reliefRules,
      TaxRebateRuleRepository rebateRules) {
    this.taxYears = taxYears;
    this.brackets = brackets;
    this.reliefRules = reliefRules;
    this.rebateRules = rebateRules;
  }

  public TaxYear requireYear(int yearOfAssessment) {
    return taxYears
        .findByYearOfAssessment(yearOfAssessment)
        .orElseThrow(
            () ->
                new ApiException(
                    HttpStatus.NOT_FOUND,
                    "TAX_YEAR_NOT_CONFIGURED",
                    "No tax rules are configured yet for YA " + yearOfAssessment + "."));
  }

  public List<TaxBracket> bracketsFor(TaxYear taxYear) {
    return brackets.findByTaxYearIdOrderByLowerBoundAsc(taxYear.getId());
  }

  public List<TaxReliefRule> reliefRulesFor(TaxYear taxYear) {
    return reliefRules.findByTaxYearId(taxYear.getId());
  }

  public List<TaxRebateRule> rebateRulesFor(TaxYear taxYear) {
    return rebateRules.findByTaxYearId(taxYear.getId());
  }
}
