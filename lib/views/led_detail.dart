import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:async'; // Add this import for Timer
import '../view_models/led_detail_viewmodel.dart';

class LedDetailPage extends StatelessWidget {
  // Declare the timer variable for debounce
  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(LedDetailViewModel());
    const double progressBarWidth = 30;

    return Scaffold(
      appBar: AppBar(
        title: Text('${viewModel.pin.value} LED'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => viewModel.status.value
                // LED is ON
                ? SizedBox(
                    width: 200,
                    height: 200,
                    child: SleekCircularSlider(
                      min: 10,
                      max: 255,
                      initialValue: viewModel.brightness.value.toDouble(),
                      innerWidget: (value) {
                        // Show the power button only when LED is ON
                        return Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Colors.red[200],
                              size: 40, // Adjust the icon size as needed
                            ),
                            onPressed: () {
                              // Toggle LED state and brightness
                              viewModel.sendLedState(
                                viewModel.pin.value,
                                !viewModel.status.value,
                                !viewModel.status.value ? 100 : null,
                              );

                              viewModel.refreshPinAndStatus(
                                viewModel.pin.value,
                                !viewModel.status.value,
                                !viewModel.status.value ? 100 : null,
                              );
                            },
                          ),
                        );
                      },
                      appearance: CircularSliderAppearance(
                        animationEnabled: false,
                        customColors: CustomSliderColors(
                          trackColor: Colors.grey[800],
                          progressBarColor: Colors.yellow[800],
                        ),
                        customWidths: CustomSliderWidths(
                            progressBarWidth: progressBarWidth,
                            trackWidth: progressBarWidth / 4,
                            shadowWidth: 0,
                            handlerSize: progressBarWidth / 5),
                      ),
                      onChange: (value) {
                        // Cancel any existing debounce timer
                        if (_debounceTimer?.isActive ?? false) {
                          _debounceTimer?.cancel();
                        }

                        // Set a new debounce timer (1 second delay)
                        _debounceTimer = Timer(const Duration(seconds: 1), () {
                          // Send the updated LED state after the debounce delay
                          viewModel.sendLedState(
                            viewModel.pin.value,
                            viewModel.status.value,
                            value.toInt(),
                          );

                          // Refresh pin and status after the debounce delay
                          viewModel.refreshPinAndStatus(
                            viewModel.pin.value,
                            viewModel.status.value,
                            value.toInt(),
                          );
                        });
                      },
                    ),
                  )
                // LED is OFF
                : Column(
                    children: [
                      // Display the power button when the LED is OFF
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.power_settings_new,
                            color: Colors.green[300],
                            size: 40, // Adjust the icon size as needed
                          ),
                          onPressed: () {
                            // Toggle LED state and brightness
                            viewModel.sendLedState(
                              viewModel.pin.value,
                              !viewModel.status.value,
                              !viewModel.status.value ? 100 : null,
                            );

                            viewModel.refreshPinAndStatus(
                              viewModel.pin.value,
                              !viewModel.status.value,
                              !viewModel.status.value ? 100 : null,
                            );
                          },
                        ),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
