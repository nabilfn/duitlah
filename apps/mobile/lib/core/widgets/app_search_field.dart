import 'package:flutter/material.dart';

import 'duitlah_icon.dart';

/// Supports local filtering and submitted server searches without changing
/// either feature's query semantics. Clear always restores the full result set.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged, onSubmitted;
  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_changed);
  }

  void _changed() => setState(() {});
  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_changed);
      if (oldWidget.controller == null) _controller.dispose();
      _attach();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    focusNode: _focus,
    textInputAction: TextInputAction.search,
    onChanged: widget.onChanged,
    onSubmitted: widget.onSubmitted,
    scrollPadding: const EdgeInsets.all(32),
    decoration: InputDecoration(
      hintText: widget.hint,
      prefixIcon: const Padding(
        padding: EdgeInsets.all(14),
        child: DuitlahIcon(Icons.search, size: 20),
      ),
      suffixIcon: _controller.text.isEmpty
          ? null
          : IconButton(
              tooltip: 'Clear search',
              icon: const DuitlahIcon(Icons.close, size: 18),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                widget.onSubmitted?.call('');
                _focus.requestFocus();
              },
            ),
    ),
  );
}
