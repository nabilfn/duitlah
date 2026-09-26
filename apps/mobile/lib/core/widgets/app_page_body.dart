import 'package:flutter/material.dart';

/// Secondary destinations share safe edges and a readable tablet width.
/// The five primary tabs retain their measured scroll-under dock layout.
class AppPageBody extends StatelessWidget {
  const AppPageBody({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      ),
    ),
  );
}
