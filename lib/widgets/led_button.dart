import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LedButton extends StatelessWidget {
  final String pin;
  final RxBool status; // Use RxBool for reactive state
  final Function() onPressed;

  const LedButton({
    super.key,
    required this.pin,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              side: BorderSide(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(16), // Add padding
            backgroundColor: Colors.transparent, // Transparent background
            shadowColor: Colors.transparent, // Transparent shadow
            elevation: 0, // No elevation
          ).copyWith(
            overlayColor: WidgetStateProperty.all(
                Colors.transparent), // No color on hover or press
          ),
          onPressed: () => onPressed(), // Toggle actual value
          child: Column(
            children: [
              Text("$pin LED"),
              const SizedBox(height: 8),
              Icon(
                status.value ? Icons.lightbulb : Icons.lightbulb_outline,
                color: status.value ? Colors.yellow : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                status.value ? "TURNED ON" : "TURNED OFF",
                style:
                    TextStyle(fontSize: context.textTheme.bodySmall!.fontSize),
              ),
            ],
          ),
        ));
  }
}
