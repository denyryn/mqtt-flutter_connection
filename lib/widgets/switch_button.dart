import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButton extends StatelessWidget {
  final RxBool isSwitched;
  final ValueChanged<bool> onChanged;

  const SwitchButton({
    super.key,
    required this.isSwitched,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: isSwitched.value, // Use the reactive value
        activeColor: Colors.green,
        activeTrackColor: Colors.green[200],
        inactiveThumbColor: Colors.red,
        inactiveTrackColor: Colors.red[200],
        onChanged: (value) {
          isSwitched.value = value; // Update the reactive value
          onChanged(value);
        },
      ),
    );
  }
}
