import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType == TextInputType.number
          ? const TextInputType.numberWithOptions(decimal: true)
          : keyboardType,
      textInputAction: onSubmitted != null
          ? TextInputAction.done
          : TextInputAction.next,
      scrollPadding: const EdgeInsets.all(32),
      enabled: enabled,
      autofillHints: autofillHints,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
