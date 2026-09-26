import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/entry_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../splash/presentation/app_entry_transition.dart';
import '../../splash/widgets/entry_visuals.dart';
import '../application/auth_state.dart';

/// Sign-in lives inside the same deep-navy environment as app entry: the form
/// grows out of the welcome state rather than cutting to a new page. The rest
/// of the product is light, which is exactly what makes this a branded door.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    // Captured up front: a successful login flips the router to Home, so this
    // screen may already be gone by the time the request resolves.
    final entry = EntryFlow.maybeOf(context)?.controller;
    final container = ProviderScope.containerOf(context, listen: false);
    setState(() {
      _loading = true;
      _error = null;
    });
    // The navy layer has to lead the request, otherwise the redirect to Home
    // would hard-cut the login screen away mid-transition.
    entry?.beginSignIn();
    try {
      await container
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
      final session = container.read(authProvider);
      final greeting = session is AuthAuthenticated
          ? session.user.displayName.trim().split(' ').first
          : null;
      if (mounted) context.go(AppRoutes.home);
      await entry?.completeSignIn(greeting?.isEmpty ?? true ? null : greeting);
    } catch (e) {
      final message = e is AppException ? e.message : 'Something went wrong.';
      if (mounted) setState(() => _error = message);
      await entry?.cancelSignIn();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: EntryPalette.theme(),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: EntryPalette.background,
            // The settled entry environment carries on behind the form, so the
            // login screen reads as the same system rather than a new page.
            body: CustomPaint(
              painter: const EntryEnvironmentPainter(
                depth: 1,
                sweep: 1,
                reducedMotion: true,
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(28, 56, 28, 32),
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            EntryLoginSection(
                              order: 0,
                              child: Text(
                                'Hi again.',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: EntryPalette.text,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            EntryLoginSection(
                              order: 0,
                              child: Text(
                                'Sign in to continue.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: EntryPalette.textMuted,
                                ),
                              ),
                            ),
                            const SizedBox(height: 44),
                            EntryLoginSection(
                              order: 1,
                              child: EntryField(
                                label: 'Email or phone',
                                controller: _emailController,
                                enabled: !_loading,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [
                                  AutofillHints.email,
                                  AutofillHints.telephoneNumber,
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            EntryLoginSection(
                              order: 2,
                              child: EntryField(
                                label: 'Password',
                                controller: _passwordController,
                                enabled: !_loading,
                                obscureText: _hidePassword,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => _submit(),
                                suffix: IconButton(
                                  tooltip: _hidePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                                  icon: DuitlahIcon(
                                    _hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: EntryPalette.textMuted,
                                  ),
                                ),
                              ),
                            ),
                            _ErrorLine(message: _error),
                            const SizedBox(height: 24),
                            EntryLoginSection(
                              order: 3,
                              child: EntrySignInButton(
                                label: 'Sign in',
                                loading: _loading,
                                onPressed: _submit,
                              ),
                            ),
                            const SizedBox(height: 8),
                            EntryLoginSection(
                              order: 4,
                              child: Align(
                                child: TextButton(
                                  onPressed: _loading
                                      ? null
                                      : () => _showResetSheet(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: EntryPalette.textMuted,
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            EntryLoginSection(
                              order: 5,
                              child: Align(
                                child: TextButton(
                                  onPressed: _loading
                                      ? null
                                      : () => context.push(AppRoutes.register),
                                  style: TextButton.styleFrom(
                                    foregroundColor: EntryPalette.blueSoft,
                                  ),
                                  child: const Text(
                                    "Don't have an account? Sign up",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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

/// A calm error: a short fade and slide with a restrained red accent. The form
/// never shakes — the system stays composed even when the attempt failed.
class _ErrorLine extends StatelessWidget {
  const _ErrorLine({required this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260),
    curve: EntryPalette.curve,
    alignment: Alignment.topCenter,
    child: message == null
        ? const SizedBox(width: double.infinity)
        : Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 2,
                    height: 18,
                    margin: const EdgeInsets.only(top: 2, right: 10),
                    color: const Color(0xFFE08E80),
                  ),
                  Expanded(
                    child: Text(
                      message!,
                      style: const TextStyle(
                        color: Color(0xFFE08E80),
                        height: 1.45,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}

/// A dark translucent input. Selective material: the screen stays open and
/// only the controls carry glass, never one giant floating card.
class EntryField extends StatefulWidget {
  const EntryField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.onSubmitted,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled, obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  State<EntryField> createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_changed);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final motion = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: EntryPalette.fieldBlur,
          sigmaY: EntryPalette.fieldBlur,
        ),
        child: AnimatedContainer(
          duration: motion,
          curve: EntryPalette.curve,
          decoration: BoxDecoration(
            color: focused
                ? EntryPalette.fieldFillFocused
                : EntryPalette.fieldFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused
                  ? EntryPalette.fieldBorderFocused
                  : EntryPalette.fieldBorder,
            ),
          ),
          child: TextField(
            focusNode: _focus,
            controller: widget.controller,
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            autofillHints: widget.autofillHints,
            onSubmitted: widget.onSubmitted,
            scrollPadding: const EdgeInsets.all(32),
            textInputAction: widget.onSubmitted != null
                ? TextInputAction.done
                : TextInputAction.next,
            cursorColor: EntryPalette.blue,
            style: const TextStyle(
              color: EntryPalette.text,
              fontSize: 16,
              height: 1.3,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              suffixIcon: widget.suffix,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 18, 12, 16),
              labelStyle: const TextStyle(color: EntryPalette.textMuted),
              floatingLabelStyle: TextStyle(
                color: focused ? EntryPalette.blue : EntryPalette.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Elevated navy with a single icy edge light — strong, tactile, no glow.
class EntrySignInButton extends StatefulWidget {
  const EntrySignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  State<EntrySignInButton> createState() => _EntrySignInButtonState();
}

class _EntrySignInButtonState extends State<EntrySignInButton> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value && mounted) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !widget.loading && widget.onPressed != null;
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: AnimatedScale(
        scale: _pressed && enabled && !reduced ? .98 : 1,
        duration: reduced ? Duration.zero : const Duration(milliseconds: 180),
        curve: EntryPalette.curve,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? widget.onPressed : null,
            onHighlightChanged: _set,
            borderRadius: BorderRadius.circular(16),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            child: Ink(
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B2F4A), Color(0xFF122338)],
                ),
                border: Border.all(color: const Color(0x4778B5FF)),
              ),
              child: Center(
                child: widget.loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: EntryPalette.blueSoft,
                        ),
                      )
                    : Text(
                        widget.label,
                        style: const TextStyle(
                          color: EntryPalette.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
