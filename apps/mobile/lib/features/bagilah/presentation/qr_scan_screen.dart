import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/utils/haptics.dart';

/// Scans a Bagilah invite QR code — the same universal-link URL format
/// (`{origin}/bagilah/join?token=...`) the "Invite" screen renders. This is
/// the in-app fallback for phones where tapping a shared QR image (rather
/// than a live camera link) is more natural than opening the system camera
/// app and hoping it recognizes an app link.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    Uri? uri;
    try {
      uri = Uri.parse(raw);
    } catch (_) {
      return;
    }
    final token = uri.queryParameters['token'];
    if (token == null || uri.path != '/bagilah/join') return;

    _handled = true;
    AppHaptics.qrScanSuccess();
    context.pushReplacement('${AppRoutes.bagilahJoin}?token=$token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Bagilah QR code')),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}

extension on List<Barcode> {
  Barcode? get firstOrNull => isEmpty ? null : first;
}
