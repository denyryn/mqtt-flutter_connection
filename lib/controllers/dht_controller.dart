import 'dart:convert';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dht_model.dart';
import '../services/mqtt_service.dart';

class DhtController extends GetxController {
  final _mqttService = Get.put(MqttService());

  late Rx<DhtModel> dhtValue = Rx(DhtModel(temperature: 0.0, humidity: 0.0));
  RxBool isSubscribed = false.obs;

  DateTime startTime = DateTime.now();
  RxList<FlSpot> temperatureData = RxList<FlSpot>([]);
  RxList<FlSpot> humidityData = RxList<FlSpot>([]);

  @override
  void onInit() {
    super.onInit();
    getDhtData('denyryn/datas/dht');
  }

  Future<void> getDhtData(String topic) async {
    if (!isSubscribed.value) {
      await _mqttService.subscribe(topic);
      isSubscribed.value = true;
    }
    _getDhtMessage(topic);
  }

  Future<void> _getDhtMessage(String topic) async {
    _mqttService.registerCallback(topic, (String message) {
      print('Received message from topic $topic: $message');
      try {
        final dhtData = DhtModel.fromJson(jsonDecode(message));
        dhtValue.update((value) {
          value?.temperature = dhtData.temperature;
          value?.humidity = dhtData.humidity;
        });
        dhtValue.refresh();

        temperatureData.add(FlSpot(
            (DateTime.now().difference(startTime).inSeconds.toDouble() / 60),
            dhtValue.value.temperature));

        humidityData.add(FlSpot(
            (DateTime.now().difference(startTime).inSeconds.toDouble() / 60),
            dhtValue.value.humidity));

        humidityData.refresh();
        temperatureData.refresh();
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
