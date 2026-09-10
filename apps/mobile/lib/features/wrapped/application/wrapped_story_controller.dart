import 'package:flutter/foundation.dart';

import '../domain/wrapped.dart';

enum WrappedChapter {
  intro,
  overview,
  comparison,
  categories,
  buildUp,
  persona,
  records,
  nextMonth,
}

/// Navigation and reveal state are independent of rendering and never mark a story viewed.
class WrappedStoryController extends ChangeNotifier {
  WrappedStoryController(WrappedResult result)
    : chapters = [
        WrappedChapter.intro,
        WrappedChapter.overview,
        if (result.story?.previousMonthExpenses != null &&
            result.overview.spendingChangePercentage != null)
          WrappedChapter.comparison,
        if (result.story?.categories.isNotEmpty ?? false)
          WrappedChapter.categories,
        if (result.persona != null) ...[
          WrappedChapter.buildUp,
          WrappedChapter.persona,
        ],
        if ((result.story?.records.isNotEmpty ?? false) ||
            result.insights.isNotEmpty)
          WrappedChapter.records,
        WrappedChapter.nextMonth,
      ];
  final List<WrappedChapter> chapters;
  int index = 0;
  int stage = 0;
  String? expanded;
  int selectedCategory = 0;
  bool personaRevealed = false;
  WrappedChapter get chapter => chapters[index];
  int get maxStage => switch (chapter) {
    WrappedChapter.intro => 4,
    WrappedChapter.overview => 6,
    WrappedChapter.buildUp => 5,
    WrappedChapter.persona => 5,
    _ => 1,
  };
  bool get fullyRevealed => stage >= maxStage;
  double get progress => (stage / maxStage).clamp(.08, 1);
  void reveal() {
    if (!fullyRevealed) {
      stage++;
      notifyListeners();
    }
  }

  void completeReveal() {
    stage = maxStage;
    notifyListeners();
  }

  void next({bool explicit = false}) {
    if (chapter == WrappedChapter.intro && !explicit) {
      completeReveal();
      return;
    }
    if (!fullyRevealed && !explicit) {
      reveal();
      return;
    }
    if (chapter == WrappedChapter.buildUp && !explicit) return;
    if (index == chapters.length - 1) return;
    index++;
    stage = 0;
    expanded = null;
    if (chapter == WrappedChapter.persona) personaRevealed = true;
    notifyListeners();
  }

  void previous() {
    if (index > 0) {
      index--;
      stage = maxStage;
      expanded = null;
      notifyListeners();
    }
  }

  void toggle(String value) {
    expanded = expanded == value ? null : value;
    notifyListeners();
  }

  void selectCategory(int value) {
    selectedCategory = value;
    notifyListeners();
  }
}
