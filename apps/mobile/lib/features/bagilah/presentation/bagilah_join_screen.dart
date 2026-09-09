import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/application/auth_state.dart';
import '../application/bagilah_providers.dart';
import '../data/guest_bagilah_repository.dart';
import '../data/guest_session_store.dart';

/// The single entry point for the invite link
/// (`{origin}/bagilah/join?token=...`), reached either via a real universal
/// link, a scanned QR code, or manually pasting a link/token. An
/// authenticated user joins immediately by identity (mirrors
/// `joinViaInvite` resolving a Bearer token first); everyone else gets the
/// exact guest flow already built in Phase 7 — enter a name, join, claim —
/// with account creation only ever offered afterward, never required.
class BagilahJoinScreen extends ConsumerStatefulWidget {
  const BagilahJoinScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<BagilahJoinScreen> createState() => _BagilahJoinScreenState();
}

class _BagilahJoinScreenState extends ConsumerState<BagilahJoinScreen> {
  final _nameController = TextEditingController();
  bool _joining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoJoin());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _maybeAutoJoin() async {
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;
    await _joinAuthenticated();
  }

  Future<void> _joinAuthenticated() async {
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      final result = await ref.read(bagilahRepositoryProvider).joinViaInvite(token: widget.token);
      ref.invalidate(billListProvider);
      if (mounted) context.pushReplacement(AppRoutes.bagilahDetail(result.billId));
    } catch (e) {
      setState(() => _error = e is AppException ? e.message : 'Could not join this bill.');
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  Future<void> _joinAsGuest() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      final result = await GuestBagilahRepository.join(widget.token, displayName: name);
      if (result.guestToken != null) {
        await ref.read(guestSessionStoreProvider).save(GuestSession(
              billId: result.billId,
              participantId: result.participantId,
              guestToken: result.guestToken!,
              displayName: result.displayName,
            ));
      }
      if (mounted) context.pushReplacement(AppRoutes.bagilahGuest(result.billId));
    } catch (e) {
      setState(() => _error = e is AppException ? e.message : 'Could not join this bill.');
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    if (authState is AuthAuthenticated && _joining) {
      return const Scaffold(body: LoadingView());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Join Bagilah')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DuitlahIcon(Icons.receipt_long_rounded, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "You've been invited to split a bill",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (authState is AuthAuthenticated)
              PrimaryButton(label: 'Join as ${authState.user.displayName}', onPressed: _joinAuthenticated, loading: _joining)
            else ...[
              AppTextField(label: 'Your name', controller: _nameController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Join', onPressed: _joinAsGuest, loading: _joining),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No account needed — you can create one afterward to keep track of everything.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
