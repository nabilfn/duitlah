import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/appearance_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/participant_avatar.dart';
import '../../auth/application/auth_state.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricSupported = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final service = ref.read(biometricLockServiceProvider);
    final supported = await service.isDeviceSupported();
    final enabled = await service.isEnabled();
    if (mounted) {
      setState(() {
        _biometricSupported = supported;
        _biometricEnabled = enabled;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final service = ref.read(biometricLockServiceProvider);
    if (value) {
      final ok = await service.authenticate();
      if (!ok) return;
    }
    await service.setEnabled(value);
    if (mounted) setState(() => _biometricEnabled = value);
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign out?',
      message: "You'll need to sign in again to access your account.",
      confirmLabel: 'Sign out',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go(AppRoutes.login);
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    // Hoisted to this method's scope, not inside the StatefulBuilder's
    // builder callback -- a callback-local variable resets on every
    // setSheetState rebuild instead of persisting (see the assistant
    // screen's affordability-check bug from Phase 12).
    final passwordController = TextEditingController();
    bool submitting = false;
    String? errorText;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          scrollable: true,
          title: const Text('Delete account?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This permanently deletes your account and everything in it. This cannot be undone.',
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: passwordController,
                obscureText: true,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Confirm your password',
                  errorText: errorText,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: submitting
                  ? null
                  : () async {
                      setDialogState(() {
                        submitting = true;
                        errorText = null;
                      });
                      try {
                        await ref
                            .read(authProvider.notifier)
                            .deleteAccount(passwordController.text);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop(true);
                        }
                      } catch (e) {
                        setDialogState(() {
                          submitting = false;
                          errorText = e is AppException
                              ? e.message
                              : 'Something went wrong.';
                        });
                      }
                    },
              child: const Text('Delete account'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    Widget section(List<(IconData, String, String)> rows) => Card(
      child: Column(
        children: [
          for (final (icon, label, route) in rows)
            ListTile(
              leading: DuitlahIcon(icon, size: 22),
              title: Text(label, style: theme.textTheme.bodyMedium),
              trailing: const DuitlahIcon(Icons.chevron_right, size: 17),
              onTap: () => context.push(route),
            ),
        ],
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          unauthenticated: () => const SizedBox.shrink(),
          authenticated: (user) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
            children: [
              Row(
                children: [
                  ParticipantAvatar(name: user.displayName, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(user.email, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Financial view', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      DuitlahSegmentedControl<int>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 0, label: Text('Personal')),
                          ButtonSegment(value: 1, label: Text('Business')),
                          ButtonSegment(value: 2, label: Text('Both')),
                        ],
                        selected: const {0},
                        onSelectionChanged: (s) {
                          if (s.first == 1) context.push(AppRoutes.spaces);
                          if (s.first == 2) {
                            context.push(AppRoutes.combinedNetWorth);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              section([
                (
                  Icons.account_balance_wallet_outlined,
                  'My Accounts',
                  AppRoutes.accounts,
                ),
                (Icons.pie_chart_outline, 'Categories', AppRoutes.categories),
                (
                  Icons.repeat_rounded,
                  'Recurring Transactions',
                  AppRoutes.recurring,
                ),
                (
                  Icons.account_balance_outlined,
                  'Tax / LHDN',
                  AppRoutes.personalTax,
                ),
                (Icons.download_outlined, 'Export Data', AppRoutes.exports),
              ]),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    const AppearancePreference(),
                    if (_biometricSupported)
                      SwitchListTile(
                        title: Text(
                          'Unlock with biometrics',
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: const Text('Protect access on this device.'),
                        value: _biometricEnabled,
                        onChanged: _toggleBiometric,
                      ),
                    ListTile(
                      leading: const DuitlahIcon(Icons.devices_outlined),
                      title: Text(
                        'Active sessions',
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: const Text(
                        'Session management is not available yet',
                      ),
                      enabled: false,
                    ),
                    ListTile(
                      leading: const DuitlahIcon(Icons.notifications_outlined),
                      title: Text(
                        'Notifications',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: const DuitlahIcon(
                        Icons.chevron_right,
                        size: 17,
                      ),
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              section([
                (
                  Icons.tune_outlined,
                  'Notification Settings',
                  AppRoutes.notificationRules,
                ),
                (Icons.more_horiz, 'All tools & workspaces', AppRoutes.more),
                (Icons.help_outline, 'Help & Support', AppRoutes.helpSupport),
              ]),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const DuitlahIcon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: _logout,
                    ),
                    ListTile(
                      leading: DuitlahIcon(
                        Icons.delete_forever_outlined,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Delete account',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      onTap: _deleteAccount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
