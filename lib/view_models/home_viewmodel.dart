import 'package:get/get.dart';
import 'dart:convert';
import '../services/mqtt_service.dart';
import '../controllers/led_controller.dart';
import '../models/led_model.dart';

class HomeViewModel extends GetxController {
  final MqttService mqttService = MqttService();
  final LedController ledController = Get.put(LedController());

  // late RxList<LedModel> ledList;

  @override
  void onInit() {
    super.onInit();
    // Subscribe to the MQTT topics for each LED pin
    for (var led in ledController.ledList) {
      getLedState(led.pin);
    }
    // ledList = ledController.ledList;
  }

  Future<void> connect() async {
    await mqttService.connect();
  }

  Future<void> getLedState(String pin) async {
    String topic = 'denyryn/datas/leds/$pin';
    mqttService.registerCallback(topic, (message) {
      final Map<String, dynamic> data = json.decode(message);
      final LedModel led = LedModel.fromJson(data);

      // Find the corresponding LED in the list and update its status and brightness
      var ledItem = ledController.ledList.firstWhere((led) => led.pin == pin,
          orElse: () => LedModel(pin: pin, status: false, brightness: 0));

      ledItem.status = led.status;
      ledItem.brightness = led.brightness;
    });
  }

  void disconnect() {
    mqttService.disconnect();
  }
}
