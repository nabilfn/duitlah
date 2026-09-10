/// Optional v2 snapshot detail. Older keepsakes remain readable without inventing missing data.
class WrappedStoryData {
  const WrappedStoryData({
    this.previousMonthExpenses,
    this.spendingDifference,
    this.suggestedSavingsAmount,
    this.categories = const [],
    this.personaMetrics = const [],
    this.personaMerchantInsight,
    this.records = const [],
  });
  final String? previousMonthExpenses,
      spendingDifference,
      suggestedSavingsAmount,
      personaMerchantInsight;
  final List<WrappedCategory> categories;
  final List<WrappedMetricData> personaMetrics;
  final List<WrappedRecordData> records;
  factory WrappedStoryData.fromJson(Map<String, dynamic> j) => WrappedStoryData(
    previousMonthExpenses: j['previousMonthExpenses']?.toString(),
    spendingDifference: j['spendingDifference']?.toString(),
    suggestedSavingsAmount: j['suggestedSavingsAmount']?.toString(),
    personaMerchantInsight: j['personaMerchantInsight'] as String?,
    categories: (j['categories'] as List? ?? [])
        .map((e) => WrappedCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
    personaMetrics: (j['personaMetrics'] as List? ?? [])
        .map((e) => WrappedMetricData.fromJson(e as Map<String, dynamic>))
        .toList(),
    records: (j['records'] as List? ?? [])
        .map((e) => WrappedRecordData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
  Map<String, dynamic> toJson() => {
    'previousMonthExpenses': previousMonthExpenses,
    'spendingDifference': spendingDifference,
    'suggestedSavingsAmount': suggestedSavingsAmount,
    'personaMerchantInsight': personaMerchantInsight,
    'categories': categories.map((e) => e.toJson()).toList(),
    'personaMetrics': personaMetrics.map((e) => e.toJson()).toList(),
    'records': records.map((e) => e.toJson()).toList(),
  };
}

class WrappedCategory {
  const WrappedCategory(
    this.name,
    this.amount,
    this.percentage, [
    this.transactionCount,
  ]);
  final String name, amount;
  final double percentage;
  final int? transactionCount;
  factory WrappedCategory.fromJson(Map<String, dynamic> j) => WrappedCategory(
    j['name'] as String,
    j['amount'].toString(),
    (j['percentage'] as num).toDouble(),
    j['transactionCount'] as int?,
  );
  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'percentage': percentage,
    'transactionCount': transactionCount,
  };
}

class WrappedMetricData {
  const WrappedMetricData(this.value, this.label);
  final String value, label;
  factory WrappedMetricData.fromJson(Map<String, dynamic> j) =>
      WrappedMetricData(j['value'] as String, j['label'] as String);
  Map<String, dynamic> toJson() => {'value': value, 'label': label};
}

class WrappedRecordData {
  const WrappedRecordData({
    required this.type,
    required this.title,
    required this.value,
    this.detail,
    this.context,
    this.expanded = const [],
  });
  final String type, title, value;
  final String? detail, context;
  final List<WrappedMetricData> expanded;
  factory WrappedRecordData.fromJson(Map<String, dynamic> j) =>
      WrappedRecordData(
        type: j['type'] as String,
        title: j['title'] as String,
        value: j['value'] as String,
        detail: j['detail'] as String?,
        context: j['context'] as String?,
        expanded: (j['expanded'] as List? ?? [])
            .map((e) => WrappedMetricData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'value': value,
    'detail': detail,
    'context': context,
    'expanded': expanded.map((e) => e.toJson()).toList(),
  };
}
