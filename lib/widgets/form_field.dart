import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final Icon icon;
  final bool obscureText;
  final bool? enabled;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomFormField({
    super.key,
    required this.label,
    required this.icon,
    this.enabled,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      keyboardType: keyboardType,
    );
  }
}
