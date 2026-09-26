import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_search_field.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/receipt_vault_providers.dart';
import '../domain/vault_receipt.dart';

/// The Receipt Vault (spec section 15): private receipt storage independent
/// of any one Bagilah bill — searchable by folder/merchant, uploaded in
/// batches, and attached to a personal/business transaction afterward.
class ReceiptVaultScreen extends ConsumerStatefulWidget {
  const ReceiptVaultScreen({super.key});

  @override
  ConsumerState<ReceiptVaultScreen> createState() => _ReceiptVaultScreenState();
}

class _ReceiptVaultScreenState extends ConsumerState<ReceiptVaultScreen> {
  final _searchController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _uploadBatch() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 90);
    if (files.isEmpty) return;

    final purpose = await _choosePurpose();
    if (purpose == null || !mounted) return;

    setState(() => _uploading = true);
    try {
      await ref
          .read(receiptVaultRepositoryProvider)
          .upload(
            filePaths: files.map((f) => f.path).toList(),
            purpose: purpose,
          );
      ref.invalidate(receiptVaultListProvider);
      if (mounted) {
        showSuccessSnackBar(
          context,
          'Receipt${files.length > 1 ? 's' : ''} saved to vault.',
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Upload failed.',
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<ReceiptPurpose?> _choosePurpose() {
    return showAppBottomSheet<ReceiptPurpose>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Personal expense'),
            onTap: () =>
                Navigator.of(context).pop(ReceiptPurpose.PERSONAL_EXPENSE),
          ),
          ListTile(
            title: const Text('Business expense'),
            onTap: () =>
                Navigator.of(context).pop(ReceiptPurpose.BUSINESS_EXPENSE),
          ),
          ListTile(
            title: const Text('Tax evidence'),
            onTap: () => Navigator.of(context).pop(ReceiptPurpose.TAX_EVIDENCE),
          ),
          ListTile(
            title: const Text('Just keep it'),
            onTap: () => Navigator.of(context).pop(ReceiptPurpose.UNSPECIFIED),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receipts = ref.watch(receiptVaultListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Vault')),
      body: AppPageBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppSearchField(
                hint: 'Search by merchant',
                controller: _searchController,
                onSubmitted: (value) =>
                    ref.read(receiptSearchQueryProvider.notifier).state =
                        value.trim().isEmpty ? null : value.trim(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(receiptVaultListProvider),
                child: receipts.when(
                  data: (items) => items.isEmpty
                      ? ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          children: const [
                            SizedBox(height: 80),
                            EmptyView(
                              icon: Icons.folder_outlined,
                              title: 'No receipts yet',
                            ),
                          ],
                        )
                      : GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: AppSpacing.scrollInsets(
                            context,
                            floatingAction: true,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSpacing.sm,
                                crossAxisSpacing: AppSpacing.sm,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final receipt = items[index];
                            return _ReceiptCard(receipt: receipt);
                          },
                        ),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(receiptVaultListProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploading ? null : _uploadBatch,
        child: _uploading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            : const DuitlahIcon(Icons.add_a_photo_outlined),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final VaultReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.receiptVaultDetail(receipt.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    receipt.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      child: Center(
                        child: Semantics(
                          label: 'Receipt preview unavailable',
                          child: DuitlahIcon(
                            Icons.receipt_long_outlined,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: SkeletonBlock(height: 80, width: 80),
                          ),
                  ),
                  if (receipt.needsReview)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: DuitlahIcon(
                        Icons.warning_amber_rounded,
                        color: context.duitlahColors.warning,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receipt.merchant ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (receipt.folder != null)
                    Text(
                      receipt.folder!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
