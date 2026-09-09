import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../subscriptions/presentation/upgrade_dialog.dart';
import '../application/groups_providers.dart';
import '../domain/group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameController = TextEditingController();
  GroupType _type = GroupType.GENERAL;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final group = await ref.read(groupsRepositoryProvider).createGroup(
            name: _nameController.text.trim(),
            type: _type,
          );
      ref.invalidate(groupListProvider);
      if (mounted) context.pushReplacement(AppRoutes.groupDetail(group.id));
    } catch (e) {
      if (mounted) {
        if (e is AppException && e.code == 'GROUP_LIMIT_REACHED') {
          showUpgradeDialog(context, message: e.message);
        } else {
          showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New group')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(label: 'Group name', controller: _nameController),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<GroupType>(
              icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: GroupType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? GroupType.GENERAL),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Create group', onPressed: _submit, loading: _loading),
          ],
        ),
      ),
    );
  }
}
