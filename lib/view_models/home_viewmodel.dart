import 'package:get/get.dart';
import 'dart:async';
import '../services/utils.dart';
import '../services/mqtt_service.dart';
import '../controllers/led_controller.dart';

class HomeViewModel extends GetxController {
  final MqttService mqttService = MqttService();
  final Utils utils = Utils();
  final LedController ledController = Get.put(LedController());

  RxBool isActive = false.obs;

  Future<void> connect() async {
    await mqttService.connect();
    utils.refreshVariableValue(isActive, true);
  }

  void disconnect() {
    mqttService.disconnect();
    utils.refreshVariableValue(isActive, false);
  }
}
