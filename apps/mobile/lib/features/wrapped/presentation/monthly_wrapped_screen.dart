import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../application/wrapped_providers.dart';
import '../application/wrapped_story_controller.dart';
import '../domain/wrapped.dart';
import 'stories/wrapped_chapters.dart';
import 'widgets/story_progress_bar.dart';
import 'widgets/wrapped_editorial.dart';
import 'widgets/wrapped_share_sheet.dart';

class MonthlyWrappedScreen extends ConsumerWidget {
  const MonthlyWrappedScreen({
    super.key,
    required this.year,
    required this.month,
  });
  final int year, month;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = WrappedMonthKey(year, month);
    final data = ref.watch(wrappedResultProvider(key));
    return Theme(
      data: WrappedPalette.theme,
      child: data.when(
        data: (result) => WrappedStoryView(
          result: result,
          onClose: () => context.pop(),
          onDone: () async {
            await ref
                .read(wrappedRepositoryProvider)
                .markViewed(year: year, month: month);
            ref.invalidate(wrappedHistoryProvider);
            ref.invalidate(wrappedPromoProvider);
            if (context.mounted) context.pop();
          },
          onSave: () => context.push(
            Uri(
              path: AppRoutes.goals,
              queryParameters: {
                'wrappedAmount': result.story!.suggestedSavingsAmount!,
                'wrappedMonth': '$year-${month.toString().padLeft(2, '0')}',
              },
            ).toString(),
          ),
        ),
        loading: () => _OpeningState(
          month: DateFormat.MMMM().format(DateTime(year, month)),
          onClose: () => context.pop(),
        ),
        error: (e, _) => _OpeningState(
          month: DateFormat.MMMM().format(DateTime(year, month)),
          onClose: () => context.pop(),
          onRetry: () => ref.invalidate(wrappedResultProvider(key)),
        ),
      ),
    );
  }
}

class _OpeningState extends StatelessWidget {
  const _OpeningState({
    required this.month,
    required this.onClose,
    this.onRetry,
  });
  final String month;
  final VoidCallback onClose;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: WrappedPalette.plum,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WrappedEyebrow(
                      'Duitlah Wrapped',
                      color: WrappedPalette.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      onRetry == null
                          ? 'Putting your\n$month together…'
                          : 'Your story needs\na little moment.',
                      style: WrappedPalette.display(
                        43,
                        color: WrappedPalette.white,
                      ),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 24),
                      WrappedPill('Try again', dark: true, onPressed: onRetry),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                tooltip: 'Close Wrapped',
                onPressed: onClose,
                icon: DuitlahIcon(Icons.close, color: WrappedPalette.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Injectable actions let navigation, completion and financial handoff be tested separately.
class WrappedStoryView extends StatefulWidget {
  const WrappedStoryView({
    super.key,
    required this.result,
    required this.onClose,
    required this.onDone,
    required this.onSave,
  });
  final WrappedResult result;
  final VoidCallback onClose, onSave;
  final Future<void> Function() onDone;
  @override
  State<WrappedStoryView> createState() => _WrappedStoryViewState();
}

class _WrappedStoryViewState extends State<WrappedStoryView> {
  late final WrappedStoryController _story;
  Timer? _timer;
  bool _finishing = false;
  int _lastIndex = 0;
  final _scroll = ScrollController();
  bool get _reduced => MediaQuery.disableAnimationsOf(context);
  @override
  void initState() {
    super.initState();
    _story = WrappedStoryController(widget.result)..addListener(_changed);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _schedule();
  }

  void _changed() {
    if (_lastIndex != _story.index) {
      _lastIndex = _story.index;
      if (_scroll.hasClients) _scroll.jumpTo(0);
      if (_story.chapter == WrappedChapter.nextMonth && !_reduced) {
        HapticFeedback.selectionClick();
      }
    }
    setState(() {});
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    if (_story.fullyRevealed) return;
    if (_reduced) {
      // Build-up stays interactive even when animation is disabled.
      if (_story.chapter != WrappedChapter.buildUp) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_story.fullyRevealed) _story.completeReveal();
        });
      }
      return;
    }
    if (_story.chapter == WrappedChapter.buildUp &&
        _story.stage >= 1 &&
        _story.stage != 4) {
      return;
    }
    _timer = Timer(
      Duration(
        milliseconds: _story.stage == 0
            ? 180
            : (_story.chapter == WrappedChapter.overview ? 480 : 320),
      ),
      _story.reveal,
    );
  }

  void _start() {
    if (!_reduced) HapticFeedback.lightImpact();
    _story.next(explicit: true);
  }

  void _revealPersona() {
    if (!_reduced) HapticFeedback.lightImpact();
    _story.next(explicit: true);
  }

  Future<void> _done() async {
    setState(() => _finishing = true);
    try {
      await widget.onDone();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save completion. Tap Done to try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _story.removeListener(_changed);
    _story.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark =
        _story.chapter == WrappedChapter.intro ||
        _story.chapter == WrappedChapter.nextMonth;
    final foreground = dark ? WrappedPalette.white : WrappedPalette.ink;
    final background = dark
        ? WrappedPalette.plum
        : switch (_story.chapter) {
            WrappedChapter.buildUp ||
            WrappedChapter.persona => WrappedPalette.goldPaper,
            WrappedChapter.categories => WrappedPalette.sagePaper,
            _ => WrappedPalette.cream,
          };
    return Theme(
      data: WrappedPalette.theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: background,
          body: Stack(
            children: [
              if (dark)
                Positioned.fill(child: CustomPaint(painter: WrappedBackdrop())),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: StoryProgressBar(
                              pageCount: _story.chapters.length,
                              currentIndex: _story.index,
                              color: foreground,
                              progress: _story.progress,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            tooltip: 'Close Wrapped',
                            onPressed: widget.onClose,
                            icon: DuitlahIcon(Icons.close, color: foreground),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Semantics(
                        label:
                            'Chapter ${_story.index + 1} of ${_story.chapters.length}',
                        onIncrease: () => _story.next(),
                        onDecrease: _story.previous,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) {
                            final width = MediaQuery.sizeOf(context).width;
                            if (details.localPosition.dx < width / 3) {
                              _story.previous();
                            } else if (details.localPosition.dx >
                                width * 2 / 3) {
                              _story.next();
                            }
                          },
                          onHorizontalDragEnd: (details) {
                            if ((details.primaryVelocity ?? 0) < -150) {
                              _story.next();
                            } else if ((details.primaryVelocity ?? 0) > 150) {
                              _story.previous();
                            }
                          },
                          child: SingleChildScrollView(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                            child: AnimatedSwitcher(
                              duration: Duration(
                                milliseconds: _reduced ? 0 : 320,
                              ),
                              switchInCurve: Curves.easeOutCubic,
                              layoutBuilder: (current, previous) => Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  ...previous.map(
                                    (w) => ExcludeSemantics(
                                      child: IgnorePointer(child: w),
                                    ),
                                  ),
                                  ?current,
                                ],
                              ),
                              child: WrappedChapterContent(
                                key: ValueKey(_story.chapter),
                                result: widget.result,
                                controller: _story,
                                onStart: _start,
                                onPersona: _revealPersona,
                                onSave: () {
                                  if (!_reduced) HapticFeedback.lightImpact();
                                  widget.onSave();
                                },
                                onShare: () => showWrappedShareSheet(
                                  context,
                                  widget.result,
                                ),
                                onDone: _done,
                                saving: _finishing,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
