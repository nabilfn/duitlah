import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/features/wrapped/application/wrapped_story_controller.dart';
import 'package:duitlah_mobile/features/wrapped/presentation/monthly_wrapped_screen.dart';
import 'package:duitlah_mobile/features/wrapped/presentation/stories/wrapped_chapters.dart';
import 'package:duitlah_mobile/features/wrapped/presentation/widgets/wrapped_share_card.dart';

import 'wrapped_fixture.dart';

import 'package:duitlah_mobile/features/wrapped/domain/wrapped_story_data.dart';

void main() {
  test('eight chapters, guarded reveals, previous and final never loops', () {
    final c = WrappedStoryController(wrappedFixture);
    expect(c.chapters.length, 8);
    c.next();
    expect(c.chapter, WrappedChapter.intro);
    c.next(explicit: true);
    expect(c.chapter, WrappedChapter.overview);
    c.next();
    expect(c.stage, 1);
    expect(c.chapter, WrappedChapter.overview);
    c.completeReveal();
    c.next();
    expect(c.chapter, WrappedChapter.comparison);
    c.previous();
    expect(c.chapter, WrappedChapter.overview);
    expect(c.fullyRevealed, true);
    while (c.chapter != WrappedChapter.buildUp) {
      c.next(explicit: true);
    }
    for (var i = 0; i < 10; i++) {
      c.next();
    }
    expect(c.chapter, WrappedChapter.buildUp);
    expect(c.fullyRevealed, true);
    c.next(explicit: true);
    expect(c.personaRevealed, true);
    while (c.chapter != WrappedChapter.nextMonth) {
      c.next(explicit: true);
    }
    c.next(explicit: true);
    expect(c.chapter, WrappedChapter.nextMonth);
    c.dispose();
  });
  test(
    'old or sparse data simplifies without guessing prior totals or persona',
    () {
      final r = wrappedFixture.copyWith(
        story: null,
        persona: null,
        insights: [],
        sufficientData: false,
      );
      final c = WrappedStoryController(r);
      expect(c.chapters, [
        WrappedChapter.intro,
        WrappedChapter.overview,
        WrappedChapter.nextMonth,
      ]);
      c.dispose();
      expect(r.story, isNull);
    },
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final font in [
      ('Plus Jakarta Sans', 'PlusJakartaSans-Variable.ttf'),
      ('Bodoni Moda', 'BodoniModa-Variable.ttf'),
    ]) {
      await (FontLoader(
        font.$1,
      )..addFont(rootBundle.load('assets/fonts/${font.$2}'))).load();
    }
  });
  Future<void> mount(
    WidgetTester tester, {
    double width = 390,
    bool reduced = true,
    VoidCallback? close,
    Future<void> Function()? done,
    VoidCallback? save,
  }) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduced,
            padding: const EdgeInsets.only(top: 44, bottom: 24),
          ),
          child: child!,
        ),
        home: WrappedStoryView(
          result: wrappedFixture,
          onClose: close ?? () {},
          onDone: done ?? () async {},
          onSave: save ?? () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> next(WidgetTester t) async {
    await t.tapAt(
      Offset(t.view.physicalSize.width / t.view.devicePixelRatio - 3, 400),
    );
    await t.pumpAndSettle();
  }

  Future<void> start(WidgetTester t) async {
    await t.tap(find.text("Let's go  →"));
    await t.pumpAndSettle();
  }

  for (final width in [375.0, 390.0, 393.0, 430.0]) {
    testWidgets('all chapters fit ${width.toInt()} with live navigation', (
      t,
    ) async {
      addTearDown(() {
        t.view.resetPhysicalSize();
        t.view.resetDevicePixelRatio();
      });
      await mount(t, width: width);
      if (const bool.fromEnvironment('RENDER_WRAPPED') && width == 390) {
        await expectLater(
          find.byType(WrappedStoryView),
          matchesGoldenFile('../../../../../docs/wrapped/intro.png'),
        );
      }
      await start(t);
      for (final chapter in [
        'overview',
        'comparison',
        'categories',
        'buildUp',
        'persona',
        'records',
        'nextMonth',
      ]) {
        if (chapter == 'buildUp') {
          for (var i = 0; i < 5; i++) {
            await next(t);
          }
        }
        expect(t.takeException(), isNull, reason: chapter);
        if (const bool.fromEnvironment('RENDER_WRAPPED') && width == 390) {
          await expectLater(
            find.byType(WrappedStoryView),
            matchesGoldenFile('../../../../../docs/wrapped/$chapter.png'),
          );
        }
        if (chapter == 'buildUp') {
          await t.ensureVisible(find.text('Reveal my August type'));
          await t.tap(find.text('Reveal my August type'));
          await t.pumpAndSettle();
        } else if (chapter != 'nextMonth') {
          await next(t);
        }
      }
      expect(find.text('Done'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('intro never auto advances and close does not complete', (
    t,
  ) async {
    int closed = 0, completed = 0;
    await mount(
      t,
      reduced: false,
      close: () => closed++,
      done: () async => completed++,
    );
    for (var i = 0; i < 10; i++) {
      await t.pump(const Duration(seconds: 1));
    }
    expect(find.text('Your\nAugust\nmoney story\nis ready.'), findsOneWidget);
    await next(t);
    expect(find.text('Your\nAugust\nmoney story\nis ready.'), findsOneWidget);
    await t.tap(find.byTooltip('Close Wrapped'));
    expect(closed, 1);
    expect(completed, 0);
    await t.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'metrics, category selection and record expansion are interactive',
    (t) async {
      await mount(t);
      await start(t);
      await t.tap(find.text('Expenses'));
      await t.pumpAndSettle();
      expect(
        find.text('Spending was 121.3% higher than last month.'),
        findsNWidgets(2),
      );
      await next(t);
      await next(t);
      await t.tap(find.text('SHOPPING'));
      await t.pumpAndSettle();
      expect(find.text('23% of spending'), findsOneWidget);
      await next(t);
      for (var i = 0; i < 5; i++) {
        await next(t);
      }
      await t.ensureVisible(find.text('Reveal my August type'));
      await t.tap(find.text('Reveal my August type'));
      await t.pumpAndSettle();
      await t.tap(find.text('Café'));
      await t.pumpAndSettle();
      expect(find.textContaining('Why Cafe Hunter?'), findsOneWidget);
      await next(t);
      await t.tap(find.text('ZUS Coffee'));
      await t.pumpAndSettle();
      expect(find.text('Average visit · RM 18.00'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'final page opens share preview, saves only on CTA, Done completes',
    (t) async {
      int saved = 0, completed = 0;
      await mount(t, save: () => saved++, done: () async => completed++);
      await start(t);
      for (var i = 0; i < 3; i++) {
        await next(t);
      }
      for (var i = 0; i < 5; i++) {
        await next(t);
      }
      await t.ensureVisible(find.text('Reveal my August type'));
      await t.tap(find.text('Reveal my August type'));
      await t.pumpAndSettle();
      await next(t);
      await next(t);
      expect(completed, 0);
      await t.ensureVisible(find.text('Save RM 420.00 next month'));
      await t.tap(find.text('Save RM 420.00 next month'));
      expect(saved, 1);
      await t.ensureVisible(find.text('Share your story'));
      await t.tap(find.text('Share your story'));
      await t.pumpAndSettle();
      expect(find.byType(WrappedShareCard), findsOneWidget);
      expect(find.text('Money Persona'), findsOneWidget);
      expect(find.text('Top Category'), findsOneWidget);
      await t.tap(find.text('Monthly Summary'));
      await t.pumpAndSettle();
      expect(find.text('A month.\nA little wiser.'), findsOneWidget);
      await t.tap(find.byTooltip('Close preview'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Done'));
      await t.tap(find.text('Done'));
      await t.pumpAndSettle();
      expect(completed, 1);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('share card is 9:16 and private amounts are opt-in', (t) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(() {
      t.view.resetPhysicalSize();
      t.view.resetDevicePixelRatio();
    });
    await t.pumpWidget(
      MaterialApp(
        home: Center(
          child: WrappedShareCard(
            result: wrappedFixture,
            kind: WrappedShareKind.summary,
          ),
        ),
      ),
    );
    expect(t.getSize(find.byType(WrappedShareCard)), const Size(360, 640));
    expect(find.textContaining('4,200'), findsNothing);
    expect(find.textContaining('ZUS'), findsNothing);
  });
  testWidgets('large values and enlarged text can scroll', (t) async {
    t.view.physicalSize = const Size(375, 812);
    t.view.devicePixelRatio = 1;
    addTearDown(() {
      t.view.resetPhysicalSize();
      t.view.resetDevicePixelRatio();
    });
    final r = wrappedFixture.copyWith(
      overview: wrappedFixture.overview.copyWith(
        totalIncome: '999999999999.99',
        totalExpense: '888888888888.88',
      ),
    );
    final c = WrappedStoryController(r);
    c.next(explicit: true);
    c.completeReveal();
    await t.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(1.8),
            disableAnimations: true,
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: WrappedChapterContent(
                  result: r,
                  controller: c,
                  onStart: () {},
                  onPersona: () {},
                  onSave: () {},
                  onShare: () {},
                  onDone: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    c.dispose();
  });
  testWidgets('empty month has no guessed persona, comparison or savings CTA', (
    t,
  ) async {
    final r = wrappedFixture.copyWith(
      persona: null,
      story: null,
      insights: [],
      sufficientData: false,
      overview: wrappedFixture.overview.copyWith(
        totalIncome: '0',
        totalExpense: '0',
        netAmount: '0',
        transactionCount: 0,
        spendingChangePercentage: null,
      ),
    );
    await t.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: WrappedStoryView(
            result: r,
            onClose: () {},
            onDone: () async {},
            onSave: () {},
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.ensureVisible(find.text("Let's go  →"));
    await t.tap(find.text("Let's go  →"));
    await t.pumpAndSettle();
    expect(find.textContaining('A fresh page'), findsOneWidget);
    expect(find.textContaining('higher'), findsNothing);
    await next(t);
    expect(find.textContaining('A little more'), findsOneWidget);
    expect(find.textContaining('Save RM'), findsNothing);
    await t.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'Done failure remains retryable and back swipe revisits chapter',
    (t) async {
      int tries = 0;
      await mount(
        t,
        done: () async {
          tries++;
          if (tries == 1) throw StateError('offline');
        },
      );
      await start(t);
      await t.fling(
        find.byType(WrappedChapterContent),
        const Offset(300, 0),
        900,
      );
      await t.pumpAndSettle();
      expect(find.text("Let's go  →"), findsOneWidget);
      await start(t);
      for (var i = 0; i < 3; i++) {
        await next(t);
      }
      for (var i = 0; i < 5; i++) {
        await next(t);
      }
      await t.ensureVisible(find.text('Reveal my August type'));
      await t.tap(find.text('Reveal my August type'));
      await t.pumpAndSettle();
      await next(t);
      await next(t);
      await t.ensureVisible(find.text('Done'));
      await t.tap(find.text('Done'));
      await t.pumpAndSettle();
      expect(find.textContaining('Could not save completion'), findsOneWidget);
      await t.tap(find.text('Done'));
      await t.pumpAndSettle();
      expect(tries, 2);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'long persona and records remain legible with surrounding dark=$dark',
      (t) async {
        t.view.physicalSize = const Size(375, 812);
        t.view.devicePixelRatio = 1;
        addTearDown(() {
          t.view.resetPhysicalSize();
          t.view.resetDevicePixelRatio();
        });
        final r = wrappedFixture.copyWith(
          persona: wrappedFixture.persona!.copyWith(
            name: 'Makan Mission Specialist',
          ),
          story: const WrappedStoryData(
            records: [
              WrappedRecordData(
                type: 'FAVOURITE_MERCHANT',
                title: 'Favourite merchant',
                value: 'An exceptionally long neighbourhood merchant name with many words',
                detail: '99999 visits',
                context: 'RM 999,999,999.99 total',
              ),
            ],
          ),
        );
        final c = WrappedStoryController(r);
        for (final chapter in [
          WrappedChapter.persona,
          WrappedChapter.records,
        ]) {
          while (c.chapter != chapter) {
            c.next(explicit: true);
          }
          c.completeReveal();
          await t.pumpWidget(
            MaterialApp(
              theme: dark ? AppTheme.dark() : AppTheme.light(),
              home: MediaQuery(
                data: const MediaQueryData(
                  disableAnimations: true,
                  textScaler: TextScaler.linear(1.8),
                ),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: WrappedChapterContent(
                        result: r,
                        controller: c,
                        onStart: () {},
                        onPersona: () {},
                        onSave: () {},
                        onShare: () {},
                        onDone: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await t.pumpAndSettle();
          expect(t.takeException(), isNull);
        }
        c.dispose();
      },
    );
  }
  for (final kind in WrappedShareKind.values) {
    testWidgets('share ${kind.name} exports dedicated private canvas', (
      t,
    ) async {
      t.view.physicalSize = const Size(390, 844);
      t.view.devicePixelRatio = 1;
      addTearDown(() {
        t.view.resetPhysicalSize();
        t.view.resetDevicePixelRatio();
      });
      await t.pumpWidget(
        MaterialApp(
          home: Center(
            child: RepaintBoundary(
              key: const ValueKey('share-golden'),
              child: WrappedShareCard(result: wrappedFixture, kind: kind),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.textContaining('ZUS Coffee'), findsNothing);
      expect(find.textContaining('4,200'), findsNothing);
      expect(t.takeException(), isNull);
      if (const bool.fromEnvironment('RENDER_WRAPPED')) {
        await expectLater(
          find.byKey(const ValueKey('share-golden')),
          matchesGoldenFile(
            '../../../../../docs/wrapped/share-${kind.name}.png',
          ),
        );
      }
    });
  }
}
