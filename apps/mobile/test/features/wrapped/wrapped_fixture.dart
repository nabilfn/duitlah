import 'package:duitlah_mobile/features/wrapped/domain/wrapped.dart';
import 'package:duitlah_mobile/features/wrapped/domain/wrapped_story_data.dart';

const wrappedFixture = WrappedResult(
  year: 2026,
  month: 8,
  version: 2,
  generatedAt: '2026-09-01T00:00:00Z',
  sufficientData: true,
  overview: WrappedOverview(
    year: 2026,
    month: 8,
    totalIncome: '4200.00',
    totalExpense: '851.80',
    netAmount: '3348.20',
    totalSavingsContribution: '0.00',
    transactionCount: 26,
    spendingChangePercentage: 121.3,
  ),
  persona: WrappedPersona(
    id: 'CAFE_HUNTER',
    name: 'Cafe Hunter',
    tagline: 'You know every cafe before Google Maps does.',
    visualTheme: 'cafe_hunter',
    amount: '282.00',
    percentage: 46,
    denominatorLabel: 'of discretionary spending',
    score: 80,
    evidence: [
      'RM282.00 across 15 transactions',
      '46% of discretionary spending',
      '2 different merchants',
    ],
  ),
  insights: [],
  recommendedGoal: WrappedGoal(message: 'Small, steady contributions add up.'),
  story: WrappedStoryData(
    previousMonthExpenses: '384.90',
    spendingDifference: '466.90',
    suggestedSavingsAmount: '420.00',
    categories: [
      WrappedCategory('Food', '522.00', 61.3),
      WrappedCategory('Shopping', '199.00', 23.4),
      WrappedCategory('Transport', '80.80', 9.5),
      WrappedCategory('Bills', '50.00', 5.8),
    ],
    personaMetrics: [
      WrappedMetricData('15', 'café runs'),
      WrappedMetricData('2', 'different spots'),
    ],
    personaMerchantInsight:
        'ZUS Coffee was a favourite, with 12 visits across your month.',
    records: [
      WrappedRecordData(
        type: 'FAVOURITE_MERCHANT',
        title: 'Favourite merchant',
        value: 'ZUS Coffee',
        detail: '12 visits',
        context: 'RM 216.00 total',
        expanded: [
          WrappedMetricData('RM 18.00', 'Average visit'),
          WrappedMetricData('Friday', 'Most common day'),
        ],
      ),
      WrappedRecordData(
        type: 'TOP_CATEGORY',
        title: 'Top category',
        value: 'Food',
        detail: 'RM 522.00',
        context: '61% of spending',
        expanded: [WrappedMetricData('RM 851.80', 'Total monthly spending')],
      ),
      WrappedRecordData(
        type: 'HIGHEST_SPEND_MERCHANT',
        title: 'Biggest merchant spend',
        value: 'Tesco',
        detail: 'RM 240.00',
        context: '2 transactions',
        expanded: [WrappedMetricData('RM 120.00', 'Average transaction')],
      ),
      WrappedRecordData(
        type: 'LARGEST_TRANSACTION',
        title: 'Biggest single expense',
        value: 'RM 199.00',
        detail: 'Shopee',
        context: '16 Aug',
        expanded: [WrappedMetricData('23.4%', 'Of monthly spending')],
      ),
    ],
  ),
);
