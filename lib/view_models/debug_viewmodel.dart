import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import 'package:mqtt_simple_connection/models/debug_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/debug_repository.dart';

class DebugViewmodel extends GetxController {
  final _mqttService = Get.put(MqttService());

  late DebugRefRepository debugRefRepository;
  late DebugModel debugInit = DebugModel(topic: '', name: '', state: false);
  late RxBool isDebugging = false.obs;

  final TextEditingController topicFieldController = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();

  final isLoading = false.obs;
  final debugMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initDebugRepository();
    await loadDebug();
    await _initFormDefaultValue();
    _getMessage();
  }

  void toggleDebug(bool state) async {
    isDebugging.value = state;
    await updateDebug();

    if (!state && debugInit.topic.isNotEmpty) {
      _mqttService.unsubscribe(debugInit.topic);
      return;
    }
    _mqttService.subscribe(debugInit.topic);
    _getMessage();
  }

  Future<void> _getMessage() async {
    _mqttService.registerCallback(debugInit.topic, (String message) {
      debugMessage.value = message;
      print("message: $message");
      debugMessage.refresh();
    });
  }

  Future<void> _initFormDefaultValue() async {
    topicFieldController.text = debugInit.topic;
    nameFieldController.text = debugInit.name ?? '';
    isDebugging.value = debugInit.state;
  }

  Future<void> _initDebugRepository() async {
    final prefs = await SharedPreferences.getInstance();
    debugRefRepository = DebugRefRepository(prefs);
    loadDebug();
  }

  Future<void> loadDebug() async {
    isLoading.value = true;
    debugInit = debugRefRepository.loadDebug();
    isLoading.value = false;
  }

  Future<void> saveDebug() async {
    final topic = topicFieldController.text.trim();
    final name = nameFieldController.text.trim();
    final state = isDebugging.value;
    DebugModel debugref = DebugModel(topic: topic, name: name, state: state);

    await debugRefRepository.saveDebug(debugref);
    loadDebug();
  }

  Future<void> updateDebug() async {
    final topic = topicFieldController.text.trim();
    final name = nameFieldController.text.trim();
    final state = isDebugging.value;
    DebugModel debugref = DebugModel(topic: topic, name: name, state: state);

    debugMessage.value = '';

    await debugRefRepository.updateDebug(debugref);
    loadDebug();
  }

  Future<void> clearDebug() async {
    await debugRefRepository.clearDebug();
    loadDebug();
  }
}
