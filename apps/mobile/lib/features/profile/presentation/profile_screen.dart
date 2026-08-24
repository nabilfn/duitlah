import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dialogs.dart';
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
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
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
                        if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
                      } catch (e) {
                        setDialogState(() {
                          submitting = false;
                          errorText = e is AppException ? e.message : 'Something went wrong.';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: authState.when(
        loading: () => const SizedBox.shrink(),
        unauthenticated: () => const SizedBox.shrink(),
        authenticated: (user) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              children: [
                ParticipantAvatar(name: user.displayName, size: 56),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.displayName, style: Theme.of(context).textTheme.titleLarge),
                      Text(user.email, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_biometricSupported)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Unlock with biometrics'),
                subtitle: const Text("Adds a device-level lock on top of your account sign-in."),
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.devices_outlined),
              title: const Text('Active sessions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.notifications),
            ),
            const Divider(height: AppSpacing.xxl),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Sign out', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: _logout,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
              title: Text(
                'Delete account',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }
}
