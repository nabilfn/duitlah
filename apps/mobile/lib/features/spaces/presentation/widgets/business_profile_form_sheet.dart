import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../application/spaces_providers.dart';
import '../../domain/financial_space.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Phase 10 — the first-ever edit form for a business's profile (previously
/// read-only through Phase 9). One sheet always in "edit" mode since a
/// `BusinessProfile` always exists once the space itself does (created
/// alongside it) — there's no create path here, unlike
/// `asset_form_sheet.dart`'s create-or-edit shape.
class BusinessProfileFormSheet extends ConsumerStatefulWidget {
  const BusinessProfileFormSheet({
    super.key,
    required this.spaceId,
    required this.existing,
  });

  final String spaceId;
  final BusinessProfile existing;

  @override
  ConsumerState<BusinessProfileFormSheet> createState() =>
      _BusinessProfileFormSheetState();
}

class _BusinessProfileFormSheetState
    extends ConsumerState<BusinessProfileFormSheet> {
  late final _legalNameController = TextEditingController(
    text: widget.existing.legalName,
  );
  late final _tradeNameController = TextEditingController(
    text: widget.existing.tradeName,
  );
  late final _registrationNumberController = TextEditingController(
    text: widget.existing.registrationNumber,
  );
  late final _tinController = TextEditingController(text: widget.existing.tin);
  late final _businessTypeController = TextEditingController(
    text: widget.existing.businessType,
  );
  late final _industryController = TextEditingController(
    text: widget.existing.industry,
  );
  late final _sstNumberController = TextEditingController(
    text: widget.existing.sstNumber,
  );
  late final _addressController = TextEditingController(
    text: widget.existing.address,
  );
  late final _phoneController = TextEditingController(
    text: widget.existing.phone,
  );
  late final _emailController = TextEditingController(
    text: widget.existing.email,
  );
  late final _currencyController = TextEditingController(
    text: widget.existing.currency,
  );
  late final _annualRevenueController = TextEditingController(
    text: widget.existing.annualRevenue,
  );

  late DateTime? _financialYearStart = DateTime.tryParse(
    widget.existing.financialYearStart ?? '',
  );
  late DateTime? _financialYearEnd = DateTime.tryParse(
    widget.existing.financialYearEnd ?? '',
  );

  bool _submitting = false;

  @override
  void dispose() {
    _legalNameController.dispose();
    _tradeNameController.dispose();
    _registrationNumberController.dispose();
    _tinController.dispose();
    _businessTypeController.dispose();
    _industryController.dispose();
    _sstNumberController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _currencyController.dispose();
    _annualRevenueController.dispose();
    super.dispose();
  }

  String? _textOrNull(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickDate(bool isStart) async {
    final initial =
        (isStart ? _financialYearStart : _financialYearEnd) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year - 20),
      lastDate: DateTime(initial.year + 20),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _financialYearStart = picked;
      } else {
        _financialYearEnd = picked;
      }
    });
  }

  Future<void> _submit() async {
    final legalName = _legalNameController.text.trim();
    if (legalName.isEmpty) {
      showErrorSnackBar(context, 'Legal name is required.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(spacesRepositoryProvider)
          .updateBusinessProfile(
            widget.spaceId,
            legalName: legalName,
            tradeName: _textOrNull(_tradeNameController),
            registrationNumber: _textOrNull(_registrationNumberController),
            tin: _textOrNull(_tinController),
            businessType: _textOrNull(_businessTypeController),
            industry: _textOrNull(_industryController),
            sstNumber: _textOrNull(_sstNumberController),
            financialYearStart: _financialYearStart != null
                ? _fmtDate(_financialYearStart!)
                : null,
            financialYearEnd: _financialYearEnd != null
                ? _fmtDate(_financialYearEnd!)
                : null,
            address: _textOrNull(_addressController),
            phone: _textOrNull(_phoneController),
            email: _textOrNull(_emailController),
            currency: _textOrNull(_currencyController),
            annualRevenue: _textOrNull(_annualRevenueController),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        final message = e is AppException && e.code == 'INSUFFICIENT_PERMISSION'
            ? 'You don\'t have permission to edit the business profile.'
            : (e is AppException ? e.message : 'Something went wrong.');
        showErrorSnackBar(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pageMargin,
        right: AppSpacing.pageMargin,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit business profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Legal name', controller: _legalNameController),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Trade name (optional)',
              controller: _tradeNameController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Registration number (optional)',
              controller: _registrationNumberController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'TIN (optional)', controller: _tinController),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Business type (optional)',
              controller: _businessTypeController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Industry (optional)',
              controller: _industryController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'SST number (optional)',
              controller: _sstNumberController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Annual revenue (RM, optional)',
              controller: _annualRevenueController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Financial year start'),
              subtitle: Text(
                _financialYearStart != null
                    ? _fmtDate(_financialYearStart!)
                    : 'Not set',
              ),
              trailing: const DuitlahIcon(Icons.calendar_month_outlined),
              onTap: () => _pickDate(true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Financial year end'),
              subtitle: Text(
                _financialYearEnd != null
                    ? _fmtDate(_financialYearEnd!)
                    : 'Not set',
              ),
              trailing: const DuitlahIcon(Icons.calendar_month_outlined),
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Address (optional)',
              controller: _addressController,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Phone (optional)',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Email (optional)',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Currency', controller: _currencyController),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Save',
              loading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
