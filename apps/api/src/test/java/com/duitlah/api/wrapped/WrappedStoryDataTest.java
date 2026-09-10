package com.duitlah.api.wrapped;

import static org.assertj.core.api.Assertions.assertThat;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.Test;

class WrappedStoryDataTest {
  @Test void absentIncomeAndPriorMonthNeverInventSuggestionsOrComparisons() {
    var data = WrappedStoryData.from(WrappedTestFixtures.summary().build(), null);
    assertThat(data.suggestedSavingsAmount()).isNull();
    assertThat(data.previousMonthExpenses()).isNull();
    assertThat(data.spendingDifference()).isNull();
    assertThat(data.records()).isEmpty();
    assertThat(data.personaMetrics()).isEmpty();
  }
  @Test void moneyIsCalculatedWithDecimalPrecisionAndDirection() {
    var data = WrappedStoryData.from(WrappedTestFixtures.summary().totalIncome("4200.05").totalExpense("300.00").previousMonthExpense("384.90").build(), null);
    assertThat(data.suggestedSavingsAmount()).isEqualByComparingTo("420.01");
    assertThat(data.spendingDifference()).isEqualByComparingTo("-84.90");
  }
  @Test void merchantRecordsUseRealVisitsAndDatesWithDeterministicTies() {
    var friday = WrappedTestFixtures.expense("Cafe", null, "18", "ZUS Coffee", LocalDate.of(2026,8,7));
    var data = WrappedStoryData.from(WrappedTestFixtures.summary().totalExpense("36")
      .merchantBreakdown(List.of(new MerchantSpendingResponse("ZUS Coffee", new BigDecimal("36"), 2)))
      .expenseTransactions(List.of(friday, friday)).largestExpenseTransaction(friday).build(), null);
    assertThat(data.records().get(0).expanded()).contains(new WrappedStoryData.Metric("RM 18.00", "Average visit"), new WrappedStoryData.Metric("Friday", "Most common day"));
    assertThat(data.records()).anySatisfy(r -> {assertThat(r.type()).isEqualTo("LARGEST_TRANSACTION"); assertThat(r.context()).isEqualTo("7 Aug");});
  }
  @Test void personaDetailUsesMatchedCategoriesNotMerchantNameGuessing() {
    var definition = new MoneyPersonaEngine().definitions().get(0);
    var summary = WrappedTestFixtures.summary().leafCategoryBreakdown(List.of(WrappedTestFixtures.leaf("Cafe", "282", 15, "zus coffee", "local cafe"), WrappedTestFixtures.leaf("Clothing", "199", 1, "mall"))).build();
    var data = WrappedStoryData.from(summary, definition);
    assertThat(data.personaMetrics()).containsExactly(new WrappedStoryData.Metric("15", "café runs"), new WrappedStoryData.Metric("2", "different spots"));
    assertThat(data.personaMerchantInsight()).isNull();
  }
  @Test void v1KeepsakesRemainReadableAndV2DetailsRoundTrip() {
    var summary = WrappedTestFixtures.summary().build();
    var r = new WrappedResult(2026,8,2,Instant.EPOCH,false,WrappedOverview.from(summary),null,List.of(),new WrappedGoal("Keep going."),WrappedStoryData.from(summary,null));
    assertThat(WrappedResultCodec.fromJson(WrappedResultCodec.toJson(r))).isEqualTo(r);
    String old = WrappedResultCodec.toJson(r);
    old = old.substring(0, old.indexOf(",\"story\":")) + "}";
    assertThat(WrappedResultCodec.fromJson(old).story()).isNull();
  }
}
