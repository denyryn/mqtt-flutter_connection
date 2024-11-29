// led_controller.dart
import 'package:get/get.dart';
import 'dart:convert';
import '../models/led_model.dart';
import '../services/mqtt_service.dart';
import '../repositories/leds_initialization.dart';

class LedController extends GetxController {
  late final MqttService _mqttService = Get.put(MqttService());
  final RxMap<String, LedModel> ledStates = <String, LedModel>{}.obs;

  // Initialize ledList directly without needing to declare it late
  final ledList = LedsInitialization().ledList;

  @override
  void onInit() {
    super.onInit();
    _updateLedListFromStates();
  }

  void _updateLedListFromStates() {
    final ledList = LedsInitialization().ledList; // Access the LED list

    // Iterate over ledStates and update ledList
    ledStates.forEach((pin, ledModel) {
      // Check if the LED already exists in the list
      final existingLed = ledList.firstWhere(
        (led) => led.pin == pin,
      );

      // Update the existing LED in the list
      final index = ledList.indexOf(existingLed);
      ledList[index] = ledModel;
      print("Updated LED in ledList: $ledModel");
    });
  }

  void _setupLedStateCallback() {
    const topic = 'denyryn/datas/leds/D4';
    _mqttService.registerCallback(topic, (String message) {
      try {
        final Map<String, dynamic> data = json.decode(message);
        final LedModel ledModel = LedModel.fromJson(data);
        ledStates[ledModel.pin] = ledModel;
        print("LED Pin state updated: ${ledModel.pin}");
        print("LED state updated: $ledModel");
        update();
      } catch (e) {
        print('Error parsing LED state message: $e');
      }
    });
  }

  Future<void> getLedState(String pin) async {
    String topic = 'denyryn/datas/leds/$pin';
    final success = await _mqttService.subscribe(topic);
    if (!success) {
      print("Failed to get LED state. Please check connection.");
    }
  }

  Future<void> sendLedState(String pin, bool isOn, int? brightness) async {
    String topic = 'denyryn/datas/leds/$pin';
    LedModel led = LedModel(pin: pin, status: isOn, brightness: brightness);
    String message = jsonEncode(led.toJson());

    ledStates[pin] = led;

    final success = await _mqttService.publish(topic, message);
    if (!success) {
      print("Failed to send LED state. Please check connection.");
    }
  }

  Future<bool> connectToMqtt() async {
    return await _mqttService.connect();
  }

  void disconnectFromMqtt() {
    _mqttService.disconnect();
    ledStates.clear();
  }

  @override
  void onClose() {
    disconnectFromMqtt();
    super.onClose();
  }
}
