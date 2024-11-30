import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes.dart';
import '../view_models/home_viewmodel.dart';
import '../widgets/led_button.dart';

class HomePage extends StatelessWidget {
  final HomeViewModel _viewModel = Get.put(HomeViewModel());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT LED Control'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.power_settings_new_outlined),
              onPressed: () => {
                _viewModel.mqttService.isConnected.value
                    ? _viewModel.disconnect()
                    : _viewModel.connect()
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.bug_report_outlined),
              onPressed: () => {Get.toNamed(Routes.debug)},
            ),
          )
        ],
      ),
      body: Obx(
        () => Center(
          child: _viewModel.mqttService.isConnected.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Control LED State',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    // Use LedButton for each LED
                    ..._viewModel.ledController.ledList.map((led) {
                      return Column(
                        children: [
                          LedButton(
                            pin: led.pin,
                            status: led.status.obs, // Pass status as RxBool
                            onPressed: () {
                              Get.toNamed(
                                Routes.ledDetail,
                                arguments: {
                                  'viewModel': _viewModel,
                                  'pin': led.pin,
                                  'status': led.status,
                                  'brightness': led.brightness,
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ],
                )
              : Center(
                  child: Text(
                  "Disconnected",
                  style: TextStyle(
                      fontSize: context.textTheme.bodyLarge!.fontSize),
                )),
        ),
      ),
    );
  }
}
