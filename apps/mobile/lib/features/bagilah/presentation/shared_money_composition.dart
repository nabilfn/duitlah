import 'package:flutter/material.dart';

import '../../../core/widgets/duitlah_icon.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/duitlah_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/digital_canvas.dart';
import '../../../core/widgets/editorial_surfaces.dart';
import '../../../core/theme/glass_tokens.dart';
import '../../settlements/application/settlements_providers.dart';
import '../../settlements/domain/settlement.dart';

/// Spatial selection is a view onto the backend's counterparties and balances.
class SharedMoneyComposition extends ConsumerStatefulWidget {
  const SharedMoneyComposition({super.key});
  @override
  ConsumerState<SharedMoneyComposition> createState() => _SharedMoneyState();
}

class _SharedMoneyState extends ConsumerState<SharedMoneyComposition> {
  String? selected;
  @override
  Widget build(BuildContext context) => ref
      .watch(settlementSummaryProvider)
      .when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(settlementSummaryProvider),
        ),
        data: (summary) {
          final people = {
            for (final p in [...summary.owedToMe, ...summary.iOwe]) p.userId: p,
          }.values.toList();
          final person = people.where((p) => p.userId == selected).firstOrNull;
          final amount = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Money.format(summary.totalIOwe),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'for you to settle',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${Money.format(summary.totalOwedToMe)} owed to you',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
          Widget node(CounterpartySummary p) => _ParticipantNode(
            person: p,
            selected: selected == p.userId,
            muted: person != null && selected != p.userId,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => selected = selected == p.userId ? null : p.userId);
            },
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxWidth < 320 ||
                      MediaQuery.textScalerOf(context).scale(16) > 19 ||
                      summary.totalIOwe.length > 10;
                  if (compact || people.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          amount,
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: people.map(node).toList(),
                          ),
                        ],
                      ),
                    );
                  }
                  final positions = [
                    const Offset(.05, 0),
                    const Offset(.90, .05),
                    const Offset(.02, .90),
                    const Offset(.82, 1),
                  ];
                  return Column(
                    children: [
                      SizedBox(
                        height: 372,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 125,
                              child: amount,
                            ),
                            for (var i = 0; i < people.length && i < 4; i++)
                              AnimatedPositioned(
                                duration: EditorialMotion.of(context),
                                curve: Curves.easeOutCubic,
                                left:
                                    (constraints.maxWidth - 96) *
                                    positions[i].dx,
                                top:
                                    258 * positions[i].dy +
                                    (person != null &&
                                            selected != people[i].userId
                                        ? (i < 2 ? -4 : 4)
                                        : 0),
                                width: 96,
                                child: node(people[i]),
                              ),
                          ],
                        ),
                      ),
                      if (people.length > 4)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: people.skip(4).map(node).toList(),
                        ),
                    ],
                  );
                },
              ),
              if (people.isNotEmpty)
                Text(
                  'Choose a person to see your shared balance.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 20),
              DuitlahExpand(
                duration: EditorialMotion.of(context),
                curve: EditorialMotion.curve,
                alignment: Alignment.topCenter,
                child: person == null
                    ? const SizedBox(width: double.infinity)
                    : _RelationshipDetails(
                        key: ValueKey(person.userId),
                        person: person,
                      ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      );
}

class _ParticipantNode extends StatelessWidget {
  const _ParticipantNode({
    required this.person,
    required this.selected,
    required this.muted,
    required this.onTap,
  });
  final CounterpartySummary person;
  final bool selected, muted;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.duitlahColors;
    final name = person.displayName.trim();
    return Semantics(
      selected: selected,
      button: true,
      label: person.displayName,
      child: ExcludeSemantics(
        child: DuitlahPress(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 96,
              child: Column(
                children: [
                  DuitlahGlassSurface(
                    radius: 48,
                    blur: false,
                    elevated: true,
                    material: GlassMaterial.soft,
                    child: AnimatedContainer(
                      duration: EditorialMotion.of(context),
                      curve: EditorialMotion.curve,
                      width: selected ? 72 : 60,
                      height: selected ? 72 : 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? colors.balanceBackground
                            : muted
                            ? colors.surfaceSecondary.withValues(alpha: .45)
                            : Colors.transparent,
                        border: Border.all(
                          color: selected
                              ? colors.balanceHighlight
                              : colors.border,
                        ),
                      ),
                      child: Text(
                        name.isEmpty
                            ? '?'
                            : name.characters.first.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? colors.balanceText
                              : colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    person.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
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

class _RelationshipDetails extends ConsumerWidget {
  const _RelationshipDetails({super.key, required this.person});
  final CounterpartySummary person;
  @override
  Widget build(BuildContext context, WidgetRef ref) => DuitlahReveal(
    child: DuitlahGlassSurface(
      material: GlassMaterial.strong,
      blur: false,
      elevated: true,
      radius: 24,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                person.displayName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                Money.format(person.netAmount),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Net shared balance',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ref
                  .watch(settlementListProvider)
                  .when(
                    data: (list) {
                      final related = list
                          .where(
                            (s) =>
                                s.fromUserId == person.userId ||
                                s.toUserId == person.userId,
                          )
                          .toList();
                      return Column(
                        children: [
                          for (final s in related)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${s.fromDisplayName} → ${s.toDisplayName}',
                              ),
                              subtitle: Text(
                                '${Money.format(s.amountRemaining)} remaining · ${s.status.name.toLowerCase().replaceAll('_', ' ')}',
                              ),
                              trailing: const DuitlahIcon(
                                Icons.arrow_outward,
                                size: 18,
                              ),
                              onTap: () => context.push(
                                s.sourceType == SourceType.BILL
                                    ? AppRoutes.bagilahDetail(s.sourceId)
                                    : AppRoutes.groupDetail(s.sourceId),
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => const LoadingView(),
                    error: (_, _) => TextButton(
                      onPressed: () => ref.invalidate(settlementListProvider),
                      child: const Text('Retry shared expenses'),
                    ),
                  ),
              TextButton(
                onPressed: () => context.push(
                  '${AppRoutes.settlements}?person=${Uri.encodeComponent(person.userId)}',
                ),
                child: const Text('Review & settle ↗'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
