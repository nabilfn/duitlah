package com.duitlah.api.wrapped;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

/** Structured, immutable detail for the editorial story. Never parses insight copy or reloads live totals. */
public record WrappedStoryData(
    BigDecimal previousMonthExpenses,
    BigDecimal spendingDifference,
    BigDecimal suggestedSavingsAmount,
    List<Category> categories,
    List<Metric> personaMetrics,
    String personaMerchantInsight,
    List<Record> records) {
  public record Category(String name, BigDecimal amount, BigDecimal percentage, Long transactionCount) {}
  public record Metric(String value, String label) {}
  public record Record(String type, String title, String value, String detail, String context,
                       List<Metric> expanded) {}

  public static WrappedStoryData from(MonthlyFinancialSummary s, MoneyPersonaDefinition persona) {
    return from(s, persona, Map.of());
  }

  public static WrappedStoryData from(MonthlyFinancialSummary s, MoneyPersonaDefinition persona, Map<java.util.UUID, Long> counts) {
    var categories = s.topLevelCategoryBreakdown().stream()
        .map(c -> new Category(c.categoryName(), c.amount(), percent(c.amount(), s.totalExpense()), c.categoryId() == null ? null : counts.get(c.categoryId())))
        .toList();
    BigDecimal assigned = categories.stream().map(Category::amount).reduce(BigDecimal.ZERO, BigDecimal::add);
    if (s.totalExpense().compareTo(assigned) > 0) {
      var all = new java.util.ArrayList<>(categories);
      BigDecimal uncategorized = s.totalExpense().subtract(assigned);
      all.add(new Category("Uncategorized", uncategorized, percent(uncategorized, s.totalExpense()), s.expenseTransactions().stream().filter(t -> t.getCategoryId() == null).count()));
      all.sort(Comparator.comparing(Category::amount).reversed().thenComparing(Category::name));
      categories = List.copyOf(all);
    }
    var records = new java.util.ArrayList<Record>();
    var merchants = s.merchantBreakdown().stream().filter(m -> m.merchant() != null && !m.merchant().isBlank()).toList();
    var favourite = merchants.stream().sorted(Comparator
        .comparingLong(com.duitlah.api.analytics.MerchantSpendingResponse::transactionCount).reversed()
        .thenComparing(com.duitlah.api.analytics.MerchantSpendingResponse::merchant)).findFirst();
    favourite.ifPresent(m -> {
      var extras = new java.util.ArrayList<Metric>();
      if (m.transactionCount() > 0) extras.add(new Metric(money(m.amount().divide(BigDecimal.valueOf(m.transactionCount()), 2, RoundingMode.HALF_UP)), "Average visit"));
      s.expenseTransactions().stream().filter(t -> m.merchant().equals(t.getMerchant()))
          .collect(Collectors.groupingBy(t -> t.getOccurredOn().getDayOfWeek(), Collectors.counting()))
          .entrySet().stream().sorted(Map.Entry.<java.time.DayOfWeek, Long>comparingByValue().reversed().thenComparing(Map.Entry.comparingByKey()))
          .findFirst().ifPresent(day -> extras.add(new Metric(day.getKey().getDisplayName(TextStyle.FULL, Locale.ENGLISH), "Most common day")));
      records.add(new Record("FAVOURITE_MERCHANT", "Favourite merchant", m.merchant(), m.transactionCount() + " visits", money(m.amount()) + " total", extras));
    });
    categories.stream().findFirst().ifPresent(c -> records.add(new Record("TOP_CATEGORY", "Top category", c.name(), money(c.amount()), c.percentage().setScale(0, RoundingMode.HALF_UP) + "% of spending", List.of(new Metric(money(s.totalExpense()), "Total monthly spending")))));
    merchants.stream().sorted(Comparator.comparing(com.duitlah.api.analytics.MerchantSpendingResponse::amount).reversed().thenComparing(com.duitlah.api.analytics.MerchantSpendingResponse::merchant)).findFirst()
        .ifPresent(m -> records.add(new Record("HIGHEST_SPEND_MERCHANT", "Biggest merchant spend", m.merchant(), money(m.amount()), m.transactionCount() + " transactions", m.transactionCount() > 0 ? List.of(new Metric(money(m.amount().divide(BigDecimal.valueOf(m.transactionCount()), 2, RoundingMode.HALF_UP)), "Average transaction")) : List.of())));
    var largest = s.largestExpenseTransaction();
    if (largest != null) records.add(new Record("LARGEST_TRANSACTION", "Biggest single expense", money(largest.getAmount()), largest.getMerchant() == null || largest.getMerchant().isBlank() ? "Recorded expense" : largest.getMerchant(), largest.getOccurredOn().format(DateTimeFormatter.ofPattern("d MMM", Locale.ENGLISH)), List.of(new Metric(percent(largest.getAmount(), s.totalExpense()).setScale(1, RoundingMode.HALF_UP) + "%", "Of monthly spending"))));
    var metrics = new java.util.ArrayList<Metric>();
    String merchantInsight = null;
    if (persona != null && !persona.matchLeafCategoryNames().isEmpty()) {
      var matched = s.leafCategoryBreakdown().stream().filter(c -> persona.matchLeafCategoryNames().contains(c.categoryName().toLowerCase(Locale.ROOT))).toList();
      int count = matched.stream().mapToInt(LeafCategoryStats::transactionCount).sum();
      var names = matched.stream().flatMap(c -> c.merchants().stream()).filter(n -> !n.isBlank()).collect(Collectors.toSet());
      metrics.add(new Metric(Integer.toString(count), persona.id() == MoneyPersonaId.CAFE_HUNTER ? "café runs" : "transactions"));
      metrics.add(new Metric(Integer.toString(names.size()), "different spots"));
      var pick = merchants.stream().filter(m -> names.contains(m.merchant().toLowerCase(Locale.ROOT)))
          .sorted(Comparator.comparingLong(com.duitlah.api.analytics.MerchantSpendingResponse::transactionCount).reversed().thenComparing(com.duitlah.api.analytics.MerchantSpendingResponse::merchant)).findFirst();
      if (pick.isPresent()) merchantInsight = pick.get().merchant() + " was a favourite, with " + pick.get().transactionCount() + " visits across your month.";
    }
    BigDecimal previous = s.previousMonthExpense() != null && s.previousMonthExpense().signum() > 0 ? s.previousMonthExpense() : null;
    BigDecimal suggestion = s.totalIncome().signum() > 0 ? s.totalIncome().multiply(new BigDecimal("0.10")).setScale(2, RoundingMode.HALF_UP) : null;
    return new WrappedStoryData(previous, previous == null ? null : s.totalExpense().subtract(previous), suggestion, categories, metrics, merchantInsight, records);
  }

  private static BigDecimal percent(BigDecimal part, BigDecimal whole) {
    return whole.signum() <= 0 ? BigDecimal.ZERO : part.multiply(BigDecimal.valueOf(100)).divide(whole, 2, RoundingMode.HALF_UP);
  }
  private static String money(BigDecimal amount) {
    return "RM " + String.format(Locale.ENGLISH, "%,.2f", amount);
  }
}
