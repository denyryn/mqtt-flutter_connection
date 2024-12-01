import 'package:get/get.dart';
import 'dart:async';
// import '../services/mqtt_service.dart';
import '../controllers/dht_controller.dart';
import '../controllers/ldr_controller.dart';

class ObservViewModel extends GetxController {
  // final _mqttService = Get.put(MqttService());
  final dhtController = Get.put(DhtController());
  final ldrController = Get.put(LdrController());

  @override
  void onInit() {
    super.onInit();
    getLdrData();
    getDhtData();
  }

  Future<void> getLdrData() async {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      ldrController.getLdrData('denyryn/datas/ldr');
    });
  }

  Future<void> getDhtData() async {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      dhtController.getDhtData('denyryn/datas/dht');
    });
  }
}
