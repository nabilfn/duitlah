import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/spaces_providers.dart';
import '../domain/financial_space.dart';
import '../domain/space_member.dart';

/// Team management for a business space (Phase 5). Role/permission
/// enforcement lives entirely server-side — this screen only ever surfaces
/// whatever `AppException` the server sends back (e.g. 403
/// `INSUFFICIENT_PERMISSION`, 409 `LAST_OWNER`) as a snackbar, it never
/// hides actions client-side based on the caller's own role.
class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _addMember(BuildContext context, WidgetRef ref) async {
    final emailController = TextEditingController();
    var role = SpaceRole.STAFF;

    final added = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.pageMargin,
              right: AppSpacing.pageMargin,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add member',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppFieldGroup(
                  label: 'Role',
                  child: DropdownButtonFormField<SpaceRole>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: role,
                    decoration: const InputDecoration(),
                    items: SpaceRole.values
                        .map(
                          (r) =>
                              DropdownMenuItem(value: r, child: Text(r.name)),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => role = v ?? role),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Add',
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (email.isEmpty) return;
                    try {
                      await ref
                          .read(spacesRepositoryProvider)
                          .addMember(spaceId, email: email, role: role);
                      if (context.mounted) Navigator.of(context).pop(true);
                    } catch (e) {
                      if (context.mounted) {
                        showErrorSnackBar(
                          context,
                          e is AppException
                              ? e.message
                              : 'Something went wrong.',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (added == true) ref.invalidate(spaceMembersProvider(spaceId));
  }

  Future<void> _manageMember(
    BuildContext context,
    WidgetRef ref,
    SpaceMember member,
  ) async {
    var role = member.role;
    final action = await showAppBottomSheet<String>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.pageMargin,
              right: AppSpacing.pageMargin,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  member.displayName ?? member.email ?? 'Member',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFieldGroup(
                  label: 'Role',
                  child: DropdownButtonFormField<SpaceRole>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: role,
                    decoration: const InputDecoration(),
                    items: SpaceRole.values
                        .map(
                          (r) =>
                              DropdownMenuItem(value: r, child: Text(r.name)),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => role = v ?? role),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Save role',
                  onPressed: () => Navigator.of(context).pop('save'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'Remove from space',
                  onPressed: () => Navigator.of(context).pop('remove'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (action == 'save') {
      try {
        await ref
            .read(spacesRepositoryProvider)
            .changeMemberRole(spaceId, member.id, role: role);
        ref.invalidate(spaceMembersProvider(spaceId));
      } catch (e) {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            e is AppException ? e.message : 'Something went wrong.',
          );
        }
      }
    } else if (action == 'remove') {
      if (!context.mounted) return;
      final confirmed = await showConfirmDialog(
        context,
        title: 'Remove member?',
        message: 'They will lose access to this business space.',
        confirmLabel: 'Remove',
        destructive: true,
      );
      if (!confirmed) return;
      try {
        await ref
            .read(spacesRepositoryProvider)
            .removeMember(spaceId, member.id);
        ref.invalidate(spaceMembersProvider(spaceId));
      } catch (e) {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            e is AppException ? e.message : 'Something went wrong.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(spaceMembersProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Team')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(spaceMembersProvider(spaceId)),
          child: members.when(
            data: (items) => items.isEmpty
                ? ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: const [
                      SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.groups_outlined,
                        title: 'No team members yet',
                      ),
                    ],
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: AppSpacing.scrollInsets(
                      context,
                      floatingAction: true,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final member = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(
                            member.displayName ?? member.email ?? 'Member',
                          ),
                          subtitle: Text(member.email ?? member.role.name),
                          trailing: Chip(
                            label: Text(
                              member.status == MemberStatus.ACTIVE
                                  ? member.role.name
                                  : member.status.name,
                            ),
                            backgroundColor:
                                member.status == MemberStatus.ACTIVE
                                ? null
                                : Theme.of(context).colorScheme.error
                                      .withValues(alpha: 0.15),
                          ),
                          onTap: () => _manageMember(context, ref, member),
                        ),
                      );
                    },
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(spaceMembersProvider(spaceId)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMember(context, ref),
        child: const DuitlahIcon(Icons.add),
      ),
    );
  }
}
