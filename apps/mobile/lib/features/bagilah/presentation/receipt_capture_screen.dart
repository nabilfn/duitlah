import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/dialogs.dart';
import '../../receipts/application/receipts_providers.dart';
import '../../subscriptions/presentation/upgrade_dialog.dart';

/// Camera capture / gallery pick -> upload -> OCR (Spring Boot,
/// `ReceiptOcrService`) -> review. Never parses the receipt itself; this
/// screen's only job is getting a photo to the backend.
class ReceiptCaptureScreen extends ConsumerStatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  ConsumerState<ReceiptCaptureScreen> createState() =>
      _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends ConsumerState<ReceiptCaptureScreen> {
  bool _uploading = false;
  double _progress = 0;

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    AppHaptics.receiptCaptured();
    setState(() {
      _uploading = true;
      _progress = 0;
    });
    try {
      final scan = await ref
          .read(receiptScanRepositoryProvider)
          .upload(
            file.path,
            onProgress: (sent, total) {
              if (total > 0) setState(() => _progress = sent / total);
            },
          );
      if (mounted) context.pushReplacement(AppRoutes.bagilahReview(scan.id));
    } catch (e) {
      if (mounted) {
        if (e is AppException && e.code == 'RECEIPT_SCAN_LIMIT_REACHED') {
          showUpgradeDialog(context, message: e.message);
        } else {
          showErrorSnackBar(
            context,
            e is AppException ? e.message : 'Could not upload the receipt.',
          );
        }
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan a receipt')),
      body: AppPageBody(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: _uploading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: _progress > 0 ? _progress : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text('Uploading receipt…'),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DuitlahIcon(
                        Icons.receipt_long_rounded,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        "Take a photo of the receipt and we'll pull out the items automatically. "
                        "You can always fix anything it gets wrong before creating the bill.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        label: 'Take photo',
                        icon: Icons.camera_alt_outlined,
                        onPressed: () => _pick(ImageSource.camera),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        label: 'Choose from gallery',
                        icon: Icons.photo_library_outlined,
                        onPressed: () => _pick(ImageSource.gallery),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextButton(
                        onPressed: () =>
                            context.pushReplacement(AppRoutes.bagilahCreate),
                        child: const Text("I'll enter it manually"),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
