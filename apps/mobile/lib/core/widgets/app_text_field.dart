import 'package:flutter/material.dart';

import '../theme/duitlah_colors.dart';
import 'app_field_group.dart';
import 'editorial_surfaces.dart';
import '../theme/glass_tokens.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.enabled = true,
    this.suffixIcon,
    this.autofillHints,
    this.onSubmitted,
  });
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool enabled;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
    final colors = context.duitlahColors;
    return AppFieldGroup(
      label: widget.label,
      child: DuitlahGlassSurface(
        radius: 16,
        blur: false,
        material: GlassMaterial.strong,
        child: AnimatedContainer(
          duration: EditorialMotion.of(context),
          curve: EditorialMotion.curve,
          decoration: BoxDecoration(
            color: (_focus.hasFocus ? colors.surfaceElevated : colors.surface)
                .withValues(alpha: _focus.hasFocus ? .86 : .66),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.errorText != null
                  ? colors.negative
                  : _focus.hasFocus
                  ? colors.primary
                  : colors.borderSubtle,
            ),
          ),
          child: TextField(
            focusNode: _focus,
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType == TextInputType.number
                ? const TextInputType.numberWithOptions(decimal: true)
                : widget.keyboardType,
            textInputAction: widget.onSubmitted != null
                ? TextInputAction.done
                : TextInputAction.next,
            scrollPadding: const EdgeInsets.all(32),
            enabled: widget.enabled,
            autofillHints: widget.autofillHints,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              errorText: widget.errorText,
              suffixIcon: widget.suffixIcon,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
