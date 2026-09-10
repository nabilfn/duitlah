import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/duitlah_colors.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/duitlah_icon.dart';
import '../../application/wrapped_story_controller.dart';
import '../../domain/wrapped.dart';
import '../../domain/wrapped_story_data.dart';
import '../widgets/wrapped_editorial.dart';

class WrappedChapterContent extends StatelessWidget {
  const WrappedChapterContent({
    super.key,
    required this.result,
    required this.controller,
    required this.onStart,
    required this.onPersona,
    required this.onSave,
    required this.onShare,
    required this.onDone,
    this.saving = false,
  });
  final WrappedResult result;
  final WrappedStoryController controller;
  final VoidCallback onStart, onPersona, onSave, onShare, onDone;
  final bool saving;
  String get month =>
      DateFormat.MMMM().format(DateTime(result.year, result.month));
  String get monthYear => '$month ${result.year}';
  String get priorMonth =>
      DateFormat.MMMM().format(DateTime(result.year, result.month - 1));
  TextStyle get body =>
      TextStyle(fontSize: 15, height: 1.45, color: WrappedPalette.muted);
  Widget gap([double height = 16]) => SizedBox(height: height);
  Widget hero(String text, [double size = 42]) =>
      Text(text, style: WrappedPalette.display(size));
  Widget reveal(int stage, Widget child) =>
      WrappedEntrance(visible: controller.stage >= stage, child: child);
  Widget heading(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 28,
      height: 1.16,
      letterSpacing: -.9,
      fontWeight: FontWeight.w600,
      color: WrappedPalette.ink,
    ),
  );

  @override
  Widget build(BuildContext context) => switch (controller.chapter) {
    WrappedChapter.intro => _intro(context),
    WrappedChapter.overview => _overview(context),
    WrappedChapter.comparison => _comparison(context),
    WrappedChapter.categories => _categories(context),
    WrappedChapter.buildUp => _buildUp(context),
    WrappedChapter.persona => _persona(context),
    WrappedChapter.records => _records(context),
    WrappedChapter.nextMonth => _nextMonth(context),
  };

  Widget _intro(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: MediaQuery.sizeOf(context).height * .14),
      reveal(
        1,
        WrappedEyebrow(
          'Duitlah Wrapped',
          color: WrappedPalette.white.withValues(alpha: .75),
        ),
      ),
      gap(18),
      reveal(
        2,
        Text(
          'Your\n$month\nmoney story\nis ready.',
          style: WrappedPalette.display(52, color: WrappedPalette.white),
        ),
      ),
      gap(22),
      reveal(
        3,
        Text(
          'Same money. A brighter you.',
          style: body.copyWith(
            color: WrappedPalette.white.withValues(alpha: .75),
          ),
        ),
      ),
      gap(42),
      reveal(
        4,
        Align(
          alignment: Alignment.centerLeft,
          child: WrappedPill("Let's go  →", dark: true, onPressed: onStart),
        ),
      ),
      gap(76),
      WrappedEyebrow(
        'A more mindful\ntomorrow starts today.',
        color: WrappedPalette.white.withValues(alpha: .55),
      ),
    ],
  );

  String? get comparison {
    final p = result.overview.spendingChangePercentage;
    if (p == null) return null;
    if (p == 0) return 'Spending matched last month.';
    return 'Spending was ${p.abs().toStringAsFixed(1)}% ${p > 0 ? 'higher' : 'lower'} than last month.';
  }

  Widget _overview(BuildContext context) {
    final o = result.overview;
    final rows = [
      (
        'Income',
        o.totalIncome,
        Icons.account_balance_wallet_outlined,
        DuitlahColors.light.positive,
        'Income recorded in $month.',
      ),
      (
        'Expenses',
        o.totalExpense,
        Icons.north,
        DuitlahColors.light.negative,
        comparison ?? 'Your recorded expenses for $month.',
      ),
      (
        'Net',
        o.netAmount,
        Icons.drag_handle,
        DuitlahColors.light.primary,
        'Income minus expenses for $month.',
      ),
      (
        'Saved toward goals',
        o.totalSavingsContribution,
        Icons.eco_outlined,
        DuitlahColors.light.information,
        'Contributions recorded toward your savings goals.',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WrappedEyebrow(monthYear),
        gap(6),
        hero('Here’s how your\nmonth went.', 39),
        gap(22),
        for (var i = 0; i < rows.length; i++) ...[
          reveal(
            i + 1,
            WrappedTile(
              onTap: () => controller.toggle(rows[i].$1),
              expanded: controller.expanded == rows[i].$1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(rows[i].$5, style: body),
                    )
                  : null,
              child: Row(
                children: [
                  _badge(rows[i].$3, rows[i].$4),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rows[i].$1, style: body.copyWith(fontSize: 13)),
                        const SizedBox(height: 2),
                        if (controller.stage >= i + 1)
                          AnimatedMoney(
                            rows[i].$2,
                            key: ValueKey('amount-$i'),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -.8,
                              color: rows[i].$4,
                            ),
                          )
                        else
                          const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  DuitlahIcon(
                    Icons.chevron_right,
                    size: 16,
                    color: WrappedPalette.ink,
                  ),
                ],
              ),
            ),
          ),
          gap(7),
        ],
        gap(10),
        if (comparison != null)
          reveal(
            5,
            WrappedTile(
              onTap: () => controller.toggle('comparison'),
              expanded:
                  controller.expanded == 'comparison' &&
                      result.story?.spendingDifference != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${Money.format(result.story!.spendingDifference!)} change from $priorMonth.',
                        style: body,
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  DuitlahIcon(
                    Icons.bar_chart,
                    color: DuitlahColors.light.information,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      comparison!,
                      style: body.copyWith(
                        color: WrappedPalette.ink,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const DuitlahIcon(Icons.chevron_right, size: 16),
                ],
              ),
            ),
          ),
        gap(12),
        reveal(
          6,
          WrappedTile(
            onTap: () => controller.toggle('count'),
            expanded: controller.expanded == 'count'
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Includes the income, expense and transfer entries recorded this month.',
                      style: body,
                    ),
                  )
                : null,
            child: Row(
              children: [
                const DuitlahIcon(Icons.receipt_long_outlined, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '${o.transactionCount} transactions this month',
                    style: body.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!result.sufficientData) ...[
          gap(),
          Text(
            o.transactionCount == 0
                ? 'A fresh page. Your story will grow as you add transactions.'
                : 'A little snapshot of your month. More entries will help reveal your patterns.',
            style: body,
          ),
        ],
      ],
    );
  }

  Widget _comparison(BuildContext context) {
    final percent = result.overview.spendingChangePercentage!;
    final difference = result.story!.spendingDifference!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WrappedEyebrow(monthYear),
        gap(24),
        hero(
          percent == 0
              ? 'A familiar\nkind of month.'
              : 'You spent ${percent > 0 ? 'more' : 'less'}\nthan last month.',
          44,
        ),
        gap(42),
        Semantics(
          label:
              '${percent > 0
                  ? 'Increase'
                  : percent < 0
                  ? 'Decrease'
                  : 'Unchanged'} ${percent.abs().toStringAsFixed(1)} percent',
          excludeSemantics: true,
          child: Row(
            children: [
              DuitlahIcon(
                percent > 0
                    ? Icons.arrow_upward
                    : percent < 0
                    ? Icons.arrow_downward
                    : Icons.drag_handle,
                size: 35,
                color: percent > 0
                    ? DuitlahColors.light.negative
                    : DuitlahColors.light.positive,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${percent.abs().toStringAsFixed(1)}%',
                  style: WrappedPalette.display(
                    70,
                    color: percent > 0
                        ? DuitlahColors.light.negative
                        : DuitlahColors.light.positive,
                  ),
                ),
              ),
            ],
          ),
        ),
        gap(32),
        Text(priorMonth, style: body),
        AnimatedMoney(
          result.story!.previousMonthExpenses!,
          style: WrappedPalette.display(35),
        ),
        gap(20),
        Divider(color: DuitlahColors.light.border),
        gap(20),
        WrappedTile(
          onTap: () => controller.toggle('month'),
          expanded: controller.expanded == 'month'
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '${Money.format(difference)} compared with $priorMonth',
                    style: body.copyWith(color: WrappedPalette.ink),
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: body),
              AnimatedMoney(
                result.overview.totalExpense,
                style: WrappedPalette.display(38),
              ),
              gap(8),
              Text(
                'Tap to explore the change',
                style: body.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        gap(32),
        Text('Every month has its own rhythm.', style: body),
      ],
    );
  }

  Widget _categories(BuildContext context) {
    final categories = result.story!.categories;
    final selected =
        categories[controller.selectedCategory.clamp(0, categories.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WrappedEyebrow('Your spending, in perspective'),
        gap(16),
        hero(
          'Where did\n${Money.format(result.overview.totalExpense)} go?',
          42,
        ),
        gap(30),
        for (var i = 0; i < categories.length; i++)
          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              selected: i == controller.selectedCategory,
              button: true,
              child: InkWell(
                onTap: () => controller.selectCategory(i),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 3,
                  ),
                  child: Text(
                    categories[i].name.toUpperCase(),
                    style: TextStyle(
                      fontSize:
                          (22 + categories[i].percentage.clamp(0, 70) * .30),
                      height: 1.15,
                      fontWeight: i == controller.selectedCategory
                          ? FontWeight.w800
                          : FontWeight.w500,
                      letterSpacing: -1,
                      color: i == controller.selectedCategory
                          ? WrappedPalette.ink
                          : DuitlahColors.light.positive,
                    ),
                  ),
                ),
              ),
            ),
          ),
        gap(26),
        WrappedResize(
          duration: Duration(
            milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 220,
          ),
          child: WrappedTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                gap(8),
                Text(
                  Money.format(selected.amount),
                  style: WrappedPalette.display(37),
                ),
                Text(
                  '${selected.percentage.round()}% of spending${selected.transactionCount == null ? '' : '\n${selected.transactionCount} transactions'}',
                  style: body,
                ),
                if (controller.selectedCategory == 0) ...[
                  gap(12),
                  Text(
                    'Your biggest spending category this month.',
                    style: body.copyWith(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<WrappedMetricData> get personaMetrics =>
      result.story?.personaMetrics ?? const [];
  List<String> get clues => personaMetrics.isNotEmpty
      ? [
          ...personaMetrics.map((e) => '${e.value} ${e.label}'),
          '${result.persona!.percentage.round()}% ${result.persona!.denominatorLabel}',
        ]
      : result.persona!.evidence.take(3).toList();
  Widget _buildUp(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      WrappedEyebrow('Your $month type', color: WrappedPalette.gold),
      gap(46),
      reveal(1, hero('We noticed\na pattern.', 49)),
      gap(48),
      for (var i = 0; i < clues.length; i++) ...[
        reveal(
          (i + 2).clamp(2, 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clues[i],
                style: WrappedPalette.display(
                  i == 2 ? 35 : 40,
                  color: WrappedPalette.gold,
                ),
              ),
              gap(16),
              Divider(color: DuitlahColors.light.border),
            ],
          ),
        ),
        gap(18),
      ],
      gap(20),
      reveal(5, WrappedPill('Reveal my $month type', onPressed: onPersona)),
      gap(18),
      if (!controller.fullyRevealed)
        Text(
          'Tap right to uncover the next clue',
          textAlign: TextAlign.center,
          style: body.copyWith(fontSize: 12),
        ),
    ],
  );

  Widget _persona(BuildContext context) {
    final p = result.persona!;
    final words = p.name.replaceAll('Cafe', 'Café').split(' ');
    final first = words.first;
    final rest = words.skip(1).join(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WrappedEyebrow('Your $month type', color: WrappedPalette.gold),
        gap(20),
        Semantics(
          button: true,
          label: 'Why am I ${p.name}?',
          child: InkWell(
            onTap: () => controller.toggle('persona'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reveal(1, hero(first, 72)),
                reveal(
                  2,
                  hero(
                    '${rest.isEmpty ? '' : rest}.',
                    words.length > 2 ? 57 : 72,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (controller.expanded == 'persona')
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Why ${p.name}?\n${p.evidence.join('\n')}',
              style: body,
            ),
          ),
        gap(10),
        reveal(
          2,
          Text(
            p.tagline,
            style: body.copyWith(fontSize: 16, color: WrappedPalette.ink),
          ),
        ),
        gap(24),
        reveal(
          3,
          Column(
            children: [
              if (controller.stage >= 3)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: p.percentage),
                  duration: Duration(
                    milliseconds: MediaQuery.disableAnimationsOf(context)
                        ? 0
                        : 750,
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, _) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${value.round()}%',
                      style: WrappedPalette.display(
                        116,
                        color: WrappedPalette.gold,
                      ),
                    ),
                  ),
                ),
              Text(
                p.denominatorLabel,
                textAlign: TextAlign.center,
                style: body,
              ),
              gap(8),
              Text(
                Money.format(p.amount),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 21),
              ),
            ],
          ),
        ),
        gap(22),
        reveal(
          4,
          Column(
            children: [
              Divider(color: DuitlahColors.light.border),
              gap(12),
              if (personaMetrics.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final metric in personaMetrics.take(2))
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              metric.value,
                              style: WrappedPalette.display(34),
                            ),
                            gap(4),
                            Text(
                              metric.label,
                              textAlign: TextAlign.center,
                              style: body.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              else
                Text(p.evidence.take(2).join('\n'), style: body),
            ],
          ),
        ),
        gap(26),
        if (result.story?.personaMerchantInsight != null)
          reveal(
            5,
            WrappedTile(
              onTap: () => controller.toggle('merchant'),
              expanded: controller.expanded == 'merchant'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Based on recorded merchant visits across $month.',
                        style: body.copyWith(fontSize: 12),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  _badge(Icons.local_cafe_outlined, WrappedPalette.gold),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.story!.personaMerchantInsight!,
                      style: body.copyWith(
                        color: WrappedPalette.ink,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _records(BuildContext context) {
    final records = result.story?.records.isNotEmpty == true
        ? result.story!.records
        : result.insights
              .map(
                (i) => WrappedRecordData(
                  type: i.type,
                  title: i.title,
                  value: i.primaryValue,
                  detail: i.secondaryValue,
                  context: i.comparison,
                ),
              )
              .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading('A few more things\nworth knowing.'),
        gap(24),
        for (final record in records) ...[
          WrappedTile(
            onTap: record.expanded.isEmpty
                ? null
                : () => controller.toggle(record.type),
            expanded: controller.expanded == record.type
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final metric in record.expanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${metric.label} · ${metric.value}',
                              style: body.copyWith(fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WrappedEyebrow(record.title),
                gap(12),
                Row(
                  children: [
                    _badge(
                      switch (record.type) {
                        'FAVOURITE_MERCHANT' => Icons.local_cafe_outlined,
                        'TOP_CATEGORY' => Icons.restaurant,
                        'HIGHEST_SPEND_MERCHANT' =>
                          Icons.shopping_cart_outlined,
                        _ => Icons.shopping_bag_outlined,
                      },
                      switch (record.type) {
                        'FAVOURITE_MERCHANT' => DuitlahColors.light.primary,
                        'TOP_CATEGORY' => WrappedPalette.gold,
                        'HIGHEST_SPEND_MERCHANT' =>
                          DuitlahColors.light.positive,
                        _ => DuitlahColors.light.negative,
                      },
                      size: 54,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              letterSpacing: -.6,
                              color: WrappedPalette.ink,
                            ),
                          ),
                          if (record.detail != null) ...[
                            gap(5),
                            Text(
                              record.detail!,
                              style: body.copyWith(fontSize: 14),
                            ),
                          ],
                          if (record.context != null)
                            Text(
                              record.context!,
                              style: body.copyWith(fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                    if (record.expanded.isNotEmpty)
                      const DuitlahIcon(Icons.chevron_right, size: 16),
                  ],
                ),
              ],
            ),
          ),
          gap(14),
        ],
      ],
    );
  }

  Widget _nextMonth(BuildContext context) {
    final amount = result.story?.suggestedSavingsAmount;
    final hasSuggestion = amount != null && Money.isPositive(amount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        gap(44),
        WrappedEyebrow(
          'Next month',
          color: WrappedPalette.white.withValues(alpha: .7),
        ),
        gap(20),
        Text(
          hasSuggestion
              ? 'What if ${Money.format(amount)}\nnever reached\nyour spending\nbalance?'
              : 'A little more\nspace for\nFuture You.',
          style: WrappedPalette.display(43, color: WrappedPalette.white),
        ),
        gap(18),
        Text(
          hasSuggestion
              ? '10% of ${Money.format(result.overview.totalIncome)}\ntoward Future You.'
              : result.recommendedGoal.message,
          style: body.copyWith(
            color: WrappedPalette.white.withValues(alpha: .8),
          ),
        ),
        gap(24),
        WrappedTile(
          dark: true,
          child: Row(
            children: [
              DuitlahIcon(Icons.bar_chart, color: WrappedPalette.white),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Small, steady contributions add up.',
                  style: body.copyWith(
                    color: WrappedPalette.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        gap(28),
        if (hasSuggestion) ...[
          WrappedPill(
            'Save ${Money.format(amount)} next month',
            dark: true,
            onPressed: onSave,
          ),
          gap(10),
        ],
        WrappedPill(
          'Share your story',
          dark: true,
          outlined: hasSuggestion,
          icon: Icons.ios_share,
          onPressed: onShare,
        ),
        gap(10),
        WrappedPill(
          saving ? 'Finishing…' : 'Done',
          dark: true,
          outlined: true,
          onPressed: saving ? null : onDone,
        ),
        gap(36),
        WrappedEyebrow(
          'Same steps.\nA brighter tomorrow.',
          color: WrappedPalette.white.withValues(alpha: .55),
        ),
      ],
    );
  }

  Widget _badge(IconData icon, Color color, {double size = 44}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: .1),
    ),
    child: Center(child: DuitlahIcon(icon, size: 25, color: color)),
  );
}
