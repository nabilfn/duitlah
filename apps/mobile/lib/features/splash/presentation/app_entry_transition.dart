import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/entry_palette.dart';
import '../widgets/entry_visuals.dart';

/// Which part of the branded navy environment is currently on screen.
enum EntryMode {
  /// First launch or a signed-out session: wordmark → `d.` → welcome → login.
  intro,

  /// An already-authenticated session: a brief `d.` signal, then Home.
  returningUser,

  /// The hand-off played around a login attempt, from tap to Home.
  signIn,

  /// The environment is gone and the app below owns the screen.
  complete,
}

/// Every animated value the entry environment needs for one frame, derived
/// from a single millisecond cursor so the stages read as one continuous
/// system rather than a sequence of independent screens.
class EntryFrame {
  const EntryFrame._({
    required this.wordmark,
    required this.wordmarkRise,
    required this.wordmarkTracking,
    required this.signal,
    required this.signalScale,
    required this.signalRise,
    required this.ring,
    required this.travel,
    required this.pulse,
    required this.glyph,
    required this.welcome,
    required this.welcomeRise,
    required this.status,
    required this.depth,
    required this.sweep,
    required this.curtain,
    required this.rise,
    required this.childOpacity,
    required this.childScale,
    required this.reveal,
  });

  final double wordmark, wordmarkRise, wordmarkTracking;
  final double signal, signalScale, signalRise;
  final double ring, travel, pulse, glyph;
  final double welcome, welcomeRise;
  final double status, depth, sweep;

  /// Opacity of the whole navy layer, and how far it has lifted away.
  final double curtain, rise;

  /// Opacity and scale of the real app sitting underneath the environment.
  final double childOpacity, childScale;

  /// How far the login form has unfolded (1) or retracted into the navy (0).
  final double reveal;

  static const complete = EntryFrame._(
    wordmark: 0,
    wordmarkRise: 0,
    wordmarkTracking: 0,
    signal: 0,
    signalScale: 1,
    signalRise: 0,
    ring: 0,
    travel: 0,
    pulse: 0,
    glyph: 0,
    welcome: 0,
    welcomeRise: 0,
    status: 0,
    depth: 0,
    sweep: 0,
    curtain: 0,
    rise: 0,
    childOpacity: 1,
    childScale: 1,
    reveal: 1,
  );

  factory EntryFrame.at(double ms, EntryMode mode, {required bool reduced}) {
    double at(double from, double to) => EntryPalette.curve.transform(
      ((ms - from) / (to - from)).clamp(0.0, 1.0),
    );
    // Reduced motion keeps every fade but drops the travel of the layout.
    final move = reduced ? 0.0 : 1.0;
    double lerp(double a, double b, double t) => ui.lerpDouble(a, b, t)!;

    switch (mode) {
      case EntryMode.complete:
        return complete;

      // 0–350 wordmark · 350–800 `d.` signal · 800–1200 welcome ·
      // 1200–1600 login. Interactive by ~1600ms.
      case EntryMode.intro:
        final reveal = at(1220, 1600);
        return EntryFrame._(
          wordmark: at(0, 350) * (1 - at(430, 690)),
          wordmarkRise: (16 * (1 - at(0, 350)) - 22 * at(430, 690)) * move,
          wordmarkTracking: 3 * (1 - at(0, 430)) * move,
          signal: at(370, 690) * (1 - at(1180, 1400)),
          signalScale: lerp(.86, 1, at(370, 780)) * lerp(1, .76, at(840, 1180)),
          signalRise: 70 * at(840, 1180) * move,
          ring: at(410, 860),
          travel: at(490, 990),
          pulse: at(850, 1170),
          glyph: at(400, 650),
          welcome: at(860, 1140) * (1 - at(1180, 1380)),
          welcomeRise: 18 * (1 - at(860, 1140)) * move,
          status: at(560, 780) * (1 - at(830, 970)),
          depth: at(0, 700),
          sweep: at(220, 1400),
          curtain: 1 - at(1240, 1560),
          rise: 0,
          childOpacity: at(1180, 1380),
          childScale: 1,
          reveal: reveal,
        );

      // A returning session never replays the marketing sequence: the signal
      // confirms the system is up and Home arrives by ~900ms.
      case EntryMode.returningUser:
        return EntryFrame._(
          wordmark: at(0, 350) * (1 - at(350, 500)),
          wordmarkRise: (16 * (1 - at(0, 350)) - 18 * at(350, 500)) * move,
          wordmarkTracking: 3 * (1 - at(0, 350)) * move,
          signal: at(350, 510) * (1 - at(560, 660)),
          signalScale: lerp(.9, 1, at(350, 520)) * lerp(1, .92, at(560, 680)),
          signalRise: 0,
          ring: at(360, 580),
          travel: at(380, 700),
          pulse: at(560, 760),
          glyph: at(355, 500),
          welcome: 0,
          welcomeRise: 0,
          // No status line on the short path: it would flash and be gone.
          status: 0,
          depth: at(0, 500),
          sweep: at(150, 760),
          // The navy is empty before it lifts, so Home dissolves in clean.
          curtain: 1 - at(660, 880),
          rise: 40 * at(660, 880) * move,
          childOpacity: at(650, 880),
          childScale: lerp(.99, 1, at(650, 900)),
          reveal: 1,
        );

      // Tap → cover (0–400, held for the network) → welcome back → Home.
      // The greeting gets a beat to be read before the lift starts at 820.
      case EntryMode.signIn:
        final cover = at(0, 220);
        return EntryFrame._(
          wordmark: 0,
          wordmarkRise: 0,
          wordmarkTracking: 0,
          signal: at(140, 380) * (1 - at(800, 930)),
          signalScale: lerp(.88, 1, at(140, 400)) * lerp(1, .9, at(800, 930)),
          signalRise: 0,
          ring: at(170, 450),
          travel: at(190, 700),
          pulse: at(430, 720),
          glyph: at(160, 360),
          welcome: at(430, 660) * (1 - at(820, 930)),
          welcomeRise: 16 * (1 - at(430, 660)) * move,
          // Visible through the held network wait, not only after it.
          status: at(250, 420) * (1 - at(800, 930)),
          depth: at(0, 300),
          sweep: at(60, 900),
          // Emptied first, then lifted: Home never dissolves through copy.
          curtain: cover * (1 - at(930, 1150)),
          rise: 40 * at(930, 1150) * move,
          childOpacity: 1,
          childScale: lerp(.99, 1, at(920, 1150)),
          reveal: 1 - at(0, 200),
        );
    }
  }
}

/// A launch-only layer around the real router. Auth and deep-link routing run
/// below it, so there is no duplicate Login route or second session resolver —
/// this owns presentation and motion only.
class AppEntryTransition extends StatefulWidget {
  const AppEntryTransition({
    super.key,
    required this.ready,
    required this.child,
    this.authenticated = false,
  });

  /// True once `bootstrap()` has resolved the persisted session either way.
  final bool ready;

  /// Whether that resolved session is signed in, which picks the short entry.
  final bool authenticated;
  final Widget child;

  @override
  State<AppEntryTransition> createState() => AppEntryTransitionState();
}

class AppEntryTransitionState extends State<AppEntryTransition>
    with SingleTickerProviderStateMixin {
  /// A millisecond cursor, not a 0–1 progress: stages are authored in the same
  /// units as the spec's timings and can be re-based when a branch is taken.
  late final _cursor = AnimationController.unbounded(vsync: this);
  final _bootstrapped = Completer<void>();
  Future<void>? _cover;
  EntryMode _mode = EntryMode.intro;
  bool _reduced = false;
  bool _started = false;
  String? _greeting;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.disableAnimationsOf(context);
    if (_started) return;
    _started = true;
    if (widget.ready && !_bootstrapped.isCompleted) _bootstrapped.complete();
    _play();
  }

  @override
  void didUpdateWidget(covariant AppEntryTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ready && !_bootstrapped.isCompleted) _bootstrapped.complete();
  }

  Duration _span(int milliseconds) => Duration(
    milliseconds: _reduced
        ? math.max(1, (milliseconds * .22).round())
        : milliseconds,
  );

  Future<void> _to(double milliseconds, int over) => _cursor
      .animateTo(milliseconds, duration: _span(over), curve: Curves.linear)
      .orCancel;

  void _rebase(EntryMode mode, double milliseconds) {
    if (!mounted) return;
    setState(() => _mode = mode);
    _cursor.value = milliseconds;
  }

  Future<void> _play() async {
    try {
      await _to(350, 350);
      if (widget.ready && widget.authenticated) {
        // Session already resolved: skip the introduction entirely.
        _rebase(EntryMode.returningUser, 350);
        await _to(520, 170);
        await _to(880, 360);
      } else {
        await _to(800, 450);
        // Hold on the `d.` signal for as long as the session takes to resolve.
        await _bootstrapped.future;
        if (!mounted) return;
        if (widget.authenticated) {
          _rebase(EntryMode.returningUser, 520);
          await _to(880, 360);
        } else {
          await _to(1200, 400);
          await _to(1600, 400);
        }
      }
      _finish();
    } on TickerCanceled {
      /* Disposed mid-launch. */
    }
  }

  void _finish() {
    if (mounted) setState(() => _mode = EntryMode.complete);
  }

  /// Raises the navy environment back over the app the moment a sign-in is
  /// attempted. It has to lead the request: authentication flipping the router
  /// straight to Home would otherwise hard-cut out of the login screen.
  void beginSignIn() {
    if (!mounted) return;
    _greeting = null;
    setState(() => _mode = EntryMode.signIn);
    _cursor.value = 0;
    _cover = _to(400, 400).catchError((Object _) {});
  }

  /// Plays `d.` signal → "Welcome back" → Home. Completes once Home is bare.
  Future<void> completeSignIn(String? name) async {
    if (!mounted || _mode != EntryMode.signIn) return;
    setState(() => _greeting = name);
    try {
      await _cover;
      await _to(1150, 750);
    } on TickerCanceled {
      return;
    }
    _finish();
  }

  /// Lowers the environment again so the error can be read in place.
  Future<void> cancelSignIn() async {
    if (!mounted || _mode != EntryMode.signIn) return;
    try {
      await _cursor
          .animateBack(0, duration: _span(280), curve: Curves.linear)
          .orCancel;
    } on TickerCanceled {
      return;
    }
    _finish();
  }

  @override
  void dispose() {
    _cursor.dispose();
    super.dispose();
  }

  String get _status => switch (_mode) {
    EntryMode.signIn =>
      _greeting == null ? 'Signing you in…' : 'Getting things ready…',
    _ => 'Getting things ready…',
  };

  @override
  Widget build(BuildContext context) {
    final live = _mode != EntryMode.complete;
    return EntryFlow(
      mode: _mode,
      cursor: _cursor,
      reducedMotion: _reduced,
      controller: this,
      child: ColoredBox(
        color: EntryPalette.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The navigator keeps the same element slot throughout, preserving
            // focus, route state and any in-flight authenticated destination.
            AnimatedBuilder(
              animation: _cursor,
              child: widget.child,
              builder: (context, child) {
                final frame = EntryFrame.at(
                  _cursor.value,
                  _mode,
                  reduced: _reduced,
                );
                return IgnorePointer(
                  ignoring: live,
                  child: ExcludeFocus(
                    excluding: _mode == EntryMode.intro,
                    child: ExcludeSemantics(
                      excluding: frame.childOpacity < .5,
                      child: Opacity(
                        opacity: frame.childOpacity.clamp(0, 1),
                        child: frame.childScale == 1
                            ? child
                            : Transform.scale(
                                scale: frame.childScale,
                                child: child,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (live)
              Positioned.fill(
                child: _EntryStage(key: entryStageKey, state: this),
              ),
          ],
        ),
      ),
    );
  }
}

/// Identifies the live entry overlay. Login paints the same settled backdrop,
/// so the overlay needs its own handle for tests and instrumentation.
const entryStageKey = ValueKey<String>('duitlah-entry-stage');

class _EntryStage extends StatelessWidget {
  const _EntryStage({super.key, required this.state});
  final AppEntryTransitionState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: state._cursor,
          builder: (context, _) {
            final frame = EntryFrame.at(
              state._cursor.value,
              state._mode,
              reduced: state._reduced,
            );
            if (frame.curtain <= 0) return const SizedBox.shrink();
            return Opacity(
              opacity: frame.curtain.clamp(0, 1),
              child: Transform.translate(
                offset: Offset(0, -frame.rise),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: EntryEnvironmentPainter(
                        depth: frame.depth,
                        sweep: frame.sweep,
                        reducedMotion: state._reduced,
                      ),
                    ),
                    if (frame.signal > 0)
                      _Layer(
                        y: -.16,
                        opacity: frame.signal,
                        offset: Offset(0, -frame.signalRise),
                        child: Transform.scale(
                          scale: frame.signalScale,
                          child: DuitlahSignal(
                            ring: frame.ring,
                            travel: frame.travel,
                            pulse: frame.pulse,
                            glyph: frame.glyph,
                            reducedMotion: state._reduced,
                          ),
                        ),
                      ),
                    if (frame.wordmark > 0)
                      _Layer(
                        y: -.16,
                        opacity: frame.wordmark,
                        offset: Offset(0, frame.wordmarkRise),
                        child: Text(
                          'duitlah.',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: EntryPalette.text,
                            fontWeight: FontWeight.w600,
                            letterSpacing: frame.wordmarkTracking,
                            height: 1,
                          ),
                        ),
                      ),
                    if (frame.welcome > 0)
                      _Layer(
                        y: .1,
                        opacity: frame.welcome,
                        offset: Offset(0, frame.welcomeRise),
                        child: _Welcome(greeting: state._greeting),
                      ),
                    if (frame.status > 0)
                      _Layer(
                        y: .36,
                        opacity: frame.status,
                        child: Text(
                          state._status,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: EntryPalette.textMuted,
                            letterSpacing: .3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Stage elements are stacked, never laid out in a column, so a stage change
/// fades and glides rather than reflowing the ones still on screen.
class _Layer extends StatelessWidget {
  const _Layer({
    required this.y,
    required this.opacity,
    required this.child,
    this.offset = Offset.zero,
  });
  final double y, opacity;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment(0, y),
    child: Opacity(
      opacity: opacity.clamp(0, 1),
      child: Transform.translate(
        offset: offset,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: child,
        ),
      ),
    ),
  );
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.greeting});

  /// A display name after a successful sign-in; null during first launch.
  final String? greeting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = theme.textTheme.headlineSmall?.copyWith(
      color: EntryPalette.text,
      height: 1.25,
    );
    return Semantics(
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (greeting != null)
            Text(
              'Welcome back, $greeting.',
              style: title,
              textAlign: TextAlign.center,
            )
          else ...[
            Text(
              'Welcome to',
              style: theme.textTheme.titleMedium?.copyWith(
                color: EntryPalette.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'duitlah.',
              style: theme.textTheme.displaySmall?.copyWith(
                color: EntryPalette.text,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your money,\nat ease.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: EntryPalette.blueSoft,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Lets the login screen fold into the entry timeline and drive the post-login
/// hand-off, without the environment knowing anything about authentication.
class EntryFlow extends InheritedWidget {
  const EntryFlow({
    super.key,
    required this.mode,
    required this.cursor,
    required this.reducedMotion,
    required this.controller,
    required super.child,
  });

  final EntryMode mode;
  final Animation<double> cursor;
  final bool reducedMotion;
  final AppEntryTransitionState controller;

  static EntryFlow? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EntryFlow>();

  EntryFrame frame() =>
      EntryFrame.at(cursor.value, mode, reduced: reducedMotion);

  @override
  bool updateShouldNotify(EntryFlow oldWidget) =>
      mode != oldWidget.mode || reducedMotion != oldWidget.reducedMotion;
}

/// Paint-only choreography around the real login controls: layout, focus and
/// state stay put, so the form is the same widget before and after the reveal.
class EntryLoginSection extends StatelessWidget {
  const EntryLoginSection({
    super.key,
    required this.order,
    required this.child,
  });

  /// Stagger position. Each step lands 36ms after the one above it, and the
  /// last one settles just inside the 1600ms interactive target.
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final entry = EntryFlow.maybeOf(context);
    if (entry == null || entry.mode == EntryMode.complete) return child;
    return AnimatedBuilder(
      animation: entry.cursor,
      child: child,
      builder: (context, child) {
        final frame = entry.frame();
        // Retracting (sign-in) moves as one; unfolding (reveal) is staggered.
        final progress = entry.mode == EntryMode.signIn
            ? frame.reveal
            : EntryPalette.curve.transform(
                ((entry.cursor.value - (1230 + order * 36)) / 180).clamp(
                  0.0,
                  1.0,
                ),
              );
        final shift = entry.reducedMotion ? 0.0 : 12 * (1 - progress);
        return Opacity(
          opacity: progress.clamp(0, 1),
          child: Transform.translate(offset: Offset(0, shift), child: child),
        );
      },
    );
  }
}
