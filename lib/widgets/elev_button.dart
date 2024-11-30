import 'package:flutter/material.dart';

class CustomElevButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  const CustomElevButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 32),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Center(child: Text(label)));
  }
}
