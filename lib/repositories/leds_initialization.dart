import 'package:get/get.dart';
import '../models/led_model.dart';

class LedsInitialization {
  final RxList<LedModel> ledList = <LedModel>[
    LedModel(pin: 'D0', status: false, brightness: 0),
    LedModel(pin: 'D4', status: false, brightness: 0),
    LedModel(pin: 'D6', status: false, brightness: 0),
  ].obs;
}
