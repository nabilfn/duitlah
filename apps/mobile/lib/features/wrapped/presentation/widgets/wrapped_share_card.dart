import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/money.dart';
import '../../domain/wrapped.dart';
import 'wrapped_editorial.dart';

enum WrappedShareKind { persona, summary, category, insight }

extension WrappedShareKindLabel on WrappedShareKind {
  String get label => switch (this) {
    WrappedShareKind.persona => 'Money Persona',
    WrappedShareKind.summary => 'Monthly Summary',
    WrappedShareKind.category => 'Top Category',
    WrappedShareKind.insight => 'Biggest Insight',
  };
}

/// A dedicated fixed 360 × 640 canvas, never a capture of navigation or account details.
class WrappedShareCard extends StatelessWidget {
  const WrappedShareCard({
    super.key,
    required this.result,
    required this.kind,
    this.includeAmounts = false,
  });
  final WrappedResult result;
  final WrappedShareKind kind;
  final bool includeAmounts;
  @override
  Widget build(BuildContext context) {
    final persona = result.persona;
    final category = result.story?.categories.firstOrNull;
    final title = switch (kind) {
      WrappedShareKind.persona =>
        persona?.name.replaceAll('Cafe', 'Café') ?? 'My money story',
      WrappedShareKind.summary => 'A month.\nA little wiser.',
      WrappedShareKind.category => category?.name ?? 'My money story',
      WrappedShareKind.insight =>
        result.overview.spendingChangePercentage == null
            ? 'Every entry\ntells a story.'
            : 'A different\nmonthly rhythm.',
    };
    final metric = switch (kind) {
      WrappedShareKind.persona => '${persona?.percentage.round() ?? 0}%',
      WrappedShareKind.summary => '${result.overview.transactionCount}',
      WrappedShareKind.category => '${category?.percentage.round() ?? 0}%',
      WrappedShareKind.insight =>
        result.overview.spendingChangePercentage == null
            ? '${result.overview.transactionCount}'
            : '${result.overview.spendingChangePercentage!.abs().toStringAsFixed(1)}%',
    };
    final caption = switch (kind) {
      WrappedShareKind.persona =>
        persona?.denominatorLabel ?? 'my month, reflected',
      WrappedShareKind.summary => 'entries in my money story',
      WrappedShareKind.category => 'of my monthly spending',
      WrappedShareKind.insight =>
        result.overview.spendingChangePercentage == null
            ? 'moments recorded this month'
            : '${result.overview.spendingChangePercentage! > 0
                  ? 'more'
                  : result.overview.spendingChangePercentage! < 0
                  ? 'less'
                  : 'change in'} spending than last month',
    };
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        color: WrappedPalette.white,
        decoration: TextDecoration.none,
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Container(
          width: 360,
          height: 640,
          color: WrappedPalette.plum,
          child: CustomPaint(
            painter: WrappedBackdrop(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duitlah',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: WrappedPalette.white,
                    ),
                  ),
                  const SizedBox(height: 7),
                  WrappedEyebrow(
                    'Wrapped · ${DateFormat('MMMM yyyy').format(DateTime(result.year, result.month))}',
                    color: WrappedPalette.white.withValues(alpha: .65),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: WrappedPalette.display(
                      47,
                      color: WrappedPalette.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    metric,
                    style: WrappedPalette.display(
                      78,
                      color: WrappedPalette.white,
                    ),
                  ),
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: WrappedPalette.white.withValues(alpha: .8),
                    ),
                  ),
                  if (includeAmounts) ...[
                    const SizedBox(height: 20),
                    Text(
                      switch (kind) {
                        WrappedShareKind.persona => Money.format(
                          persona?.amount ?? '0',
                        ),
                        WrappedShareKind.category => Money.format(
                          category?.amount ?? '0',
                        ),
                        _ =>
                          'Income ${Money.format(result.overview.totalIncome)}\nExpenses ${Money.format(result.overview.totalExpense)}',
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: WrappedPalette.white,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    'Same money. A brighter you.',
                    style: TextStyle(
                      fontSize: 12,
                      color: WrappedPalette.white.withValues(alpha: .65),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
