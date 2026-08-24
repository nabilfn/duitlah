import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/spaces_providers.dart';

class CreateBusinessSpaceScreen extends ConsumerStatefulWidget {
  const CreateBusinessSpaceScreen({super.key});

  @override
  ConsumerState<CreateBusinessSpaceScreen> createState() => _CreateBusinessSpaceScreenState();
}

class _CreateBusinessSpaceScreenState extends ConsumerState<CreateBusinessSpaceScreen> {
  final _nameController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _registrationController = TextEditingController();
  final _tinController = TextEditingController();
  final _industryController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _legalNameController.dispose();
    _registrationController.dispose();
    _tinController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final legalName = _legalNameController.text.trim();
    if (name.isEmpty || legalName.isEmpty) {
      showErrorSnackBar(context, 'Business name and legal name are required.');
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(spacesRepositoryProvider).createBusinessSpace(
            name: name,
            legalName: legalName,
            registrationNumber:
                _registrationController.text.trim().isEmpty ? null : _registrationController.text.trim(),
            tin: _tinController.text.trim().isEmpty ? null : _tinController.text.trim(),
            industry: _industryController.text.trim().isEmpty ? null : _industryController.text.trim(),
          );
      ref.invalidate(spaceListProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a business')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'The essentials now — everything else can be filled in later from Business Settings.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Business name', controller: _nameController),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Legal name (SSM)', controller: _legalNameController),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Registration number (optional)', controller: _registrationController),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'TIN (optional)', controller: _tinController),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Industry (optional)', controller: _industryController),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Create business workspace', onPressed: _submit, loading: _loading),
          ],
        ),
      ),
    );
  }
}
