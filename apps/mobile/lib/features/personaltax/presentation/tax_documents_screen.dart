import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/personal_tax_providers.dart';
import '../domain/personal_tax.dart';

/// Spec section 28 — direct upload only here (an EA form, an EPF statement); a document that's
/// really a photographed receipt belongs in the Receipt Vault (tagged TAX_EVIDENCE), which feeds
/// this Tax Centre's relief-candidate pipeline automatically instead of being uploaded twice.
class TaxDocumentsScreen extends ConsumerStatefulWidget {
  const TaxDocumentsScreen({super.key});

  @override
  ConsumerState<TaxDocumentsScreen> createState() => _TaxDocumentsScreenState();
}

class _TaxDocumentsScreenState extends ConsumerState<TaxDocumentsScreen> {
  bool _uploading = false;

  Future<void> _upload() async {
    final type = await showAppBottomSheet<TaxDocumentType>(
      context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: TaxDocumentType.values
            .map((t) => ListTile(title: Text(t.name), onTap: () => Navigator.of(context).pop(t)))
            .toList(),
      ),
    );
    if (type == null) return;

    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    if (path == null) return;

    setState(() => _uploading = true);
    try {
      final ya = ref.read(selectedYearOfAssessmentProvider);
      await ref.read(personalTaxRepositoryProvider).uploadDocument(filePath: path, yearOfAssessment: ya, type: type);
      ref.invalidate(taxDocumentListProvider);
      ref.invalidate(filingReadinessProvider);
      if (mounted) showSuccessSnackBar(context, 'Document uploaded.');
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Upload failed.');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(taxDocumentListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tax Documents')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(taxDocumentListProvider),
        child: documents.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.description_outlined, title: 'No documents yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final doc = items[index];
                    return Card(
                      child: ListTile(
                        leading: DuitlahIcon(doc.receiptId != null ? Icons.receipt_outlined : Icons.insert_drive_file_outlined),
                        title: Text(doc.type.name),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(taxDocumentListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploading ? null : _upload,
        child: _uploading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.4))
            : const DuitlahIcon(Icons.upload_file_outlined),
      ),
    );
  }
}
