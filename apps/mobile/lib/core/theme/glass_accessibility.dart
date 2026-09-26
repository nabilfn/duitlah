import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Flutter currently exposes contrast/motion but not iOS Reduce Transparency.
/// One app-level bridge reads it on entry/resume and listens for live changes.
class GlassAccessibility extends StatefulWidget {
  const GlassAccessibility({super.key, required this.child});
  final Widget child;
  @override
  State<GlassAccessibility> createState() => _GlassAccessibilityState();
}

class _GlassAccessibilityState extends State<GlassAccessibility>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel('duitlah/accessibility');
  bool _reduce = false;
  bool get _usesChannel =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_usesChannel) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'reduceTransparencyChanged' &&
            call.arguments is bool) {
          _update(call.arguments as bool);
        }
      });
      _read();
    }
  }

  void _update(bool value) {
    if (mounted && _reduce != value) setState(() => _reduce = value);
  }

  Future<void> _read() async {
    try {
      _update(await _channel.invokeMethod<bool>('reduceTransparency') ?? false);
    } on MissingPluginException {
      /* Tests and platforms without this system setting. */
    } on PlatformException {
      /* Contrast fallback remains available through MediaQuery. */
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_usesChannel && state == AppLifecycleState.resumed) _read();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_usesChannel) _channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      GlassTransparencyScope(reduceTransparency: _reduce, child: widget.child);
}

class GlassTransparencyScope extends InheritedWidget {
  const GlassTransparencyScope({
    super.key,
    required this.reduceTransparency,
    required super.child,
  });
  final bool reduceTransparency;
  static bool reducedOf(BuildContext context) =>
      (context
              .dependOnInheritedWidgetOfExactType<GlassTransparencyScope>()
              ?.reduceTransparency ??
          false) ||
      MediaQuery.highContrastOf(context);
  @override
  bool updateShouldNotify(GlassTransparencyScope oldWidget) =>
      reduceTransparency != oldWidget.reduceTransparency;
}
