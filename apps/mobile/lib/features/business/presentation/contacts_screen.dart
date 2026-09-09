import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/business_providers.dart';
import '../domain/contacts.dart';

/// Shared list+form UI for `/customers` and `/suppliers` — the two
/// endpoints are wire-identical, so [CustomersScreen] and [SuppliersScreen]
/// are thin wrappers over this with [isSupplier] flipped, rather than two
/// near-duplicate screens.
class _ContactsBody extends ConsumerWidget {
  const _ContactsBody({required this.spaceId, required this.isSupplier});

  final String spaceId;
  final bool isSupplier;

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    String? existingId,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) async {
    final nameController = TextEditingController(text: name);
    final contactPersonController = TextEditingController(text: contactPerson);
    final phoneController = TextEditingController(text: phone);
    final emailController = TextEditingController(text: email);
    final billingAddressController = TextEditingController(text: billingAddress);
    final registrationNumberController = TextEditingController(text: registrationNumber);
    final tinController = TextEditingController(text: tin);
    final sstNumberController = TextEditingController(text: sstNumber);
    final paymentTermsController = TextEditingController(text: paymentTermsDays?.toString());
    final notesController = TextEditingController(text: notes);

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existingId == null ? (isSupplier ? 'Add supplier' : 'Add customer') : 'Edit ${isSupplier ? 'supplier' : 'customer'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Contact person', controller: contactPersonController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Phone', controller: phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Email', controller: emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Billing address', controller: billingAddressController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Registration number', controller: registrationNumberController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'TIN', controller: tinController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'SST number', controller: sstNumberController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Payment terms (days)', controller: paymentTermsController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Notes', controller: notesController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: existingId == null ? 'Add' : 'Save',
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  String? orNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
                  final paymentTerms = int.tryParse(paymentTermsController.text.trim());
                  try {
                    final repo = ref.read(contactsRepositoryProvider);
                    if (isSupplier) {
                      if (existingId == null) {
                        await repo.createSupplier(
                          spaceId,
                          name: name,
                          contactPerson: orNull(contactPersonController),
                          phone: orNull(phoneController),
                          email: orNull(emailController),
                          billingAddress: orNull(billingAddressController),
                          registrationNumber: orNull(registrationNumberController),
                          tin: orNull(tinController),
                          sstNumber: orNull(sstNumberController),
                          paymentTermsDays: paymentTerms,
                          notes: orNull(notesController),
                        );
                      } else {
                        await repo.updateSupplier(
                          spaceId,
                          existingId,
                          name: name,
                          contactPerson: orNull(contactPersonController),
                          phone: orNull(phoneController),
                          email: orNull(emailController),
                          billingAddress: orNull(billingAddressController),
                          registrationNumber: orNull(registrationNumberController),
                          tin: orNull(tinController),
                          sstNumber: orNull(sstNumberController),
                          paymentTermsDays: paymentTerms,
                          notes: orNull(notesController),
                        );
                      }
                    } else {
                      if (existingId == null) {
                        await repo.createCustomer(
                          spaceId,
                          name: name,
                          contactPerson: orNull(contactPersonController),
                          phone: orNull(phoneController),
                          email: orNull(emailController),
                          billingAddress: orNull(billingAddressController),
                          registrationNumber: orNull(registrationNumberController),
                          tin: orNull(tinController),
                          sstNumber: orNull(sstNumberController),
                          paymentTermsDays: paymentTerms,
                          notes: orNull(notesController),
                        );
                      } else {
                        await repo.updateCustomer(
                          spaceId,
                          existingId,
                          name: name,
                          contactPerson: orNull(contactPersonController),
                          phone: orNull(phoneController),
                          email: orNull(emailController),
                          billingAddress: orNull(billingAddressController),
                          registrationNumber: orNull(registrationNumberController),
                          tin: orNull(tinController),
                          sstNumber: orNull(sstNumberController),
                          paymentTermsDays: paymentTerms,
                          notes: orNull(notesController),
                        );
                      }
                    }
                    if (context.mounted) Navigator.of(context).pop(true);
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (saved == true) {
      if (isSupplier) {
        ref.invalidate(supplierListProvider(spaceId));
      } else {
        ref.invalidate(customerListProvider(spaceId));
      }
    }
  }

  Future<void> _archive(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Archive ${isSupplier ? 'supplier' : 'customer'}?',
      message: 'This hides it from active lists — it is not permanently deleted.',
      confirmLabel: 'Archive',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      if (isSupplier) {
        await ref.read(contactsRepositoryProvider).archiveSupplier(spaceId, id);
        ref.invalidate(supplierListProvider(spaceId));
      } else {
        await ref.read(contactsRepositoryProvider).archiveCustomer(spaceId, id);
        ref.invalidate(customerListProvider(spaceId));
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Widget _emptyView() => ListView(
        children: [
          const SizedBox(height: 80),
          EmptyView(
            icon: isSupplier ? Icons.local_shipping_outlined : Icons.people_alt_outlined,
            title: isSupplier ? 'No suppliers yet' : 'No customers yet',
          ),
        ],
      );

  Widget _row(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String name,
    String? email,
    String? phone,
    required ContactStatus status,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text(name),
        subtitle: Text([if (email != null) email, if (phone != null) phone].join(' · ')),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == ContactStatus.ARCHIVED) const Chip(label: Text('Archived')),
            IconButton(
              icon: const DuitlahIcon(Icons.archive_outlined),
              onPressed: () => _archive(context, ref, id),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(isSupplier ? 'Suppliers' : 'Customers')),
      body: RefreshIndicator(
        onRefresh: () async {
          if (isSupplier) {
            ref.invalidate(supplierListProvider(spaceId));
          } else {
            ref.invalidate(customerListProvider(spaceId));
          }
        },
        child: isSupplier
            ? ref.watch(supplierListProvider(spaceId)).when(
                  data: (items) => items.isEmpty
                      ? _emptyView()
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final s = items[index];
                            return _row(
                              context,
                              ref,
                              id: s.id,
                              name: s.name,
                              email: s.email,
                              phone: s.phone,
                              status: s.status,
                              onTap: () => _openForm(
                                context,
                                ref,
                                existingId: s.id,
                                name: s.name,
                                contactPerson: s.contactPerson,
                                phone: s.phone,
                                email: s.email,
                                billingAddress: s.billingAddress,
                                registrationNumber: s.registrationNumber,
                                tin: s.tin,
                                sstNumber: s.sstNumber,
                                paymentTermsDays: s.paymentTermsDays,
                                notes: s.notes,
                              ),
                            );
                          },
                        ),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(supplierListProvider(spaceId))),
                )
            : ref.watch(customerListProvider(spaceId)).when(
                  data: (items) => items.isEmpty
                      ? _emptyView()
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final c = items[index];
                            return _row(
                              context,
                              ref,
                              id: c.id,
                              name: c.name,
                              email: c.email,
                              phone: c.phone,
                              status: c.status,
                              onTap: () => _openForm(
                                context,
                                ref,
                                existingId: c.id,
                                name: c.name,
                                contactPerson: c.contactPerson,
                                phone: c.phone,
                                email: c.email,
                                billingAddress: c.billingAddress,
                                registrationNumber: c.registrationNumber,
                                tin: c.tin,
                                sstNumber: c.sstNumber,
                                paymentTermsDays: c.paymentTermsDays,
                                notes: c.notes,
                              ),
                            );
                          },
                        ),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(customerListProvider(spaceId))),
                ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _openForm(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) => _ContactsBody(spaceId: spaceId, isSupplier: false);
}

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) => _ContactsBody(spaceId: spaceId, isSupplier: true);
}
