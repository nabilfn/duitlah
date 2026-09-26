import 'package:flutter/material.dart';

/// Scaffold.extendBody supplies the measured dock height through MediaQuery.
/// Scroll content uses it as trailing space; floating actions use viewPadding.
class DuitlahDockBody extends StatelessWidget {
  const DuitlahDockBody({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return DuitlahDockInsets(
      bottom: media.padding.bottom,
      child: MediaQuery(
        data: media.copyWith(
          viewPadding: media.viewPadding.copyWith(bottom: media.padding.bottom),
        ),
        child: child,
      ),
    );
  }
}

class DuitlahDockInsets extends InheritedWidget {
  const DuitlahDockInsets({
    super.key,
    required this.bottom,
    required super.child,
  });
  final double bottom;
  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DuitlahDockInsets>()?.bottom ??
      0;
  @override
  bool updateShouldNotify(DuitlahDockInsets oldWidget) =>
      bottom != oldWidget.bottom;
}
