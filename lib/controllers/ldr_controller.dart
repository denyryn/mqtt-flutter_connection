import 'package:get/get.dart';
import 'dart:convert';
import '../models/ldr_model.dart';
import '../repositories/topics_repository.dart';
import '../services/mqtt_service.dart';

class LdrController extends GetxController {
  final _mqttService = Get.find<MqttService>();

  late Rx<LdrModel> ldrValue = LdrModel(intensity: 0).obs;
  RxBool isSubscribed = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLdrData();
  }

  Future<void> fetchLdrData() async {
    return getLdrData(TopicsRepository.ldrTopic);
  }

  Future<void> getLdrData(String topic) async {
    if (!isSubscribed.value) {
      await _mqttService.subscribe(topic);
      isSubscribed.value = true;
    }
    _getLdrMessage(topic);
  }

  Future<void> _getLdrMessage(String topic) async {
    _mqttService.registerCallback(topic, (String message) {
      print('Received message from topic $topic: $message');
      try {
        final ldrData = LdrModel.fromJson(jsonDecode(message));
        ldrValue.update((value) {
          value?.intensity = ldrData.intensity;
        });
        ldrValue.refresh();
      } catch (e) {
        print('Error parsing message: $e');
      }
    });
  }

  Future<bool> connectToMqtt() async {
    return await _mqttService.connect();
  }

  void disconnectFromMqtt() {
    _mqttService.disconnect();
  }

  @override
  void onClose() {
    disconnectFromMqtt();
    super.onClose();
  }
}
