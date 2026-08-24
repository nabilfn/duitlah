import 'package:flutter/services.dart';

/// Selective haptic feedback at the specific interaction points called out
/// by the Phase 9.5 migration doc — never blanket "haptic on every tap,"
/// which both desensitizes users and can trip up accessibility tooling.
class AppHaptics {
  AppHaptics._();

  /// Claiming an item successfully.
  static void claimSuccess() => HapticFeedback.lightImpact();

  /// Finalizing a bill.
  static void billFinalized() => HapticFeedback.mediumImpact();

  /// Confirming a settlement payment.
  static void paymentConfirmed() => HapticFeedback.mediumImpact();

  /// A successful QR scan.
  static void qrScanSuccess() => HapticFeedback.selectionClick();

  /// Confirming a captured receipt photo.
  static void receiptCaptured() => HapticFeedback.lightImpact();
}
