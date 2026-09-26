import 'package:flutter/material.dart';

import '../../../../core/widgets/dialogs.dart';

import 'package:flutter/rendering.dart';

import '../../services/wrapped_share_service.dart';

import '../../domain/wrapped.dart';
import 'wrapped_editorial.dart';
import 'wrapped_share_card.dart';

Future<void> showWrappedShareSheet(
  BuildContext context,
  WrappedResult result,
) => showDuitlahGlassSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => WrappedShareSheet(result: result),
);

class WrappedShareSheet extends StatefulWidget {
  const WrappedShareSheet({super.key, required this.result});
  final WrappedResult result;
  @override
  State<WrappedShareSheet> createState() => _WrappedShareSheetState();
}

class _WrappedShareSheetState extends State<WrappedShareSheet> {
  final _boundary = GlobalKey();
  late WrappedShareKind _kind = widget.result.persona == null
      ? WrappedShareKind.summary
      : WrappedShareKind.persona;
  bool _amounts = false, _busy = false;
  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final boundary =
          _boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final box = context.findRenderObject() as RenderBox;
      await WrappedShareService().share(
        boundary,
        box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not share your card. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: WrappedPalette.theme,
    child: SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Share your story',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close preview',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  for (final kind in WrappedShareKind.values)
                    if ((kind != WrappedShareKind.persona ||
                            widget.result.persona != null) &&
                        (kind != WrappedShareKind.category ||
                            (widget.result.story?.categories.isNotEmpty ??
                                false)))
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(kind.label),
                          selected: _kind == kind,
                          onSelected: _busy
                              ? null
                              : (_) => setState(() => _kind = kind),
                        ),
                      ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: RepaintBoundary(
                      key: _boundary,
                      child: WrappedShareCard(
                        result: widget.result,
                        kind: _kind,
                        includeAmounts: _amounts,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Include RM amounts'),
              subtitle: const Text('Amounts are hidden by default.'),
              value: _amounts,
              onChanged: _busy ? null : (v) => setState(() => _amounts = v),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: WrappedPill(
                  _busy ? 'Preparing…' : 'Share card',
                  onPressed: _busy ? null : _share,
                  icon: Icons.ios_share,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
