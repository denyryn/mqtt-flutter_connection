import 'package:get/get.dart';
import '../models/led_model.dart';

class LedsInitialization {
  final RxList<LedModel> ledList = <LedModel>[
    LedModel(pin: 'D1', status: false, brightness: 0),
    LedModel(pin: 'D2', status: false, brightness: 0),
    LedModel(pin: 'D3', status: false, brightness: 0),
    LedModel(pin: 'D4', status: false, brightness: 0),
    LedModel(pin: 'D5', status: false, brightness: 0),
  ].obs;
}
