import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      setState(
        () => _error = e is AppException ? e.message : 'Something went wrong.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DuitlahIcon(
                      Icons.account_balance_wallet_outlined,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Duitlah',
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 6),
                Text(
                  'Your money. Clearer, together.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Sign in',
                  onPressed: _submit,
                  loading: _loading,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text("Don't have an account? Sign up"),
                ),
                TextButton(
                  onPressed: () => _showResetSheet(context),
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResetSheet(BuildContext context) {
    final controller = TextEditingController();
    showAppBottomSheet(
      context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset your password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Email',
                controller: controller,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Send reset link',
                onPressed: () async {
                  try {
                    await ref
                        .read(authRepositoryProvider)
                        .requestPasswordReset(controller.text.trim());
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showSuccessSnackBar(
                        context,
                        'If that email exists, a reset link is on its way.',
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(
                        context,
                        e is AppException ? e.message : 'Something went wrong.',
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
