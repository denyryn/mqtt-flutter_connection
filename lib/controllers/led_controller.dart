// led_controller.dart
import 'package:get/get.dart';
import 'package:mqtt_simple_connection/repositories/topics_repository.dart';
import 'dart:convert';
import '../models/led_model.dart';
import '../services/mqtt_service.dart';
import '../repositories/leds_initialization.dart';

class LedController extends GetxController {
  late final MqttService _mqttService = Get.put(MqttService());
  final RxMap<String, LedModel> ledStates = <String, LedModel>{}.obs;
  static const LedTopic = '${TopicsRepository.ledsTopic}/';

  // Initialize ledList directly without needing to declare it late
  final ledList = LedsInitialization().ledList;

  Future<void> getLedState(String pin) async {
    String topic = LedTopic + pin;
    final success = await _mqttService.subscribe(topic);
    if (!success) {
      print("Failed to get LED state. Please check connection.");
    }
  }

  Future<void> sendLedState(String pin, bool isOn, int? brightness) async {
    String topic = LedTopic + pin;
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
}
