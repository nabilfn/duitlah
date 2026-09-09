import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/feedback_providers.dart';
import '../domain/user_feedback.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _messageController = TextEditingController();
  FeedbackCategory _category = FeedbackCategory.GENERAL;
  bool _submitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      showErrorSnackBar(context, 'Please write a message first.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(feedbackRepositoryProvider).submit(
            category: _category,
            message: message,
            idempotencyKey: const Uuid().v4(),
          );
      if (mounted) {
        showSuccessSnackBar(context, 'Thanks — your feedback has been sent.');
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send feedback')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Found a bug, or have an idea for Duitlah? Let us know.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<FeedbackCategory>(
              icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: FeedbackCategory.BUG, child: Text('Bug report')),
                DropdownMenuItem(
                  value: FeedbackCategory.FEATURE_REQUEST,
                  child: Text('Feature request'),
                ),
                DropdownMenuItem(value: FeedbackCategory.GENERAL, child: Text('General feedback')),
                DropdownMenuItem(value: FeedbackCategory.COMPLAINT, child: Text('Complaint')),
              ],
              onChanged: (v) => setState(() => _category = v ?? FeedbackCategory.GENERAL),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _messageController,
              minLines: 5,
              maxLines: 10,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Your message',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(label: 'Send feedback', onPressed: _submit, loading: _submitting),
          ],
        ),
      ),
    );
  }
}
