import 'package:get/get.dart';
import '../controllers/led_controller.dart';

class LedDetailViewModel extends GetxController {
  final LedController _ledController = Get.put(LedController());

  // Initialize Rx variables with default values
  final RxString pin = 'Unknown'.obs;
  final RxBool status = false.obs;
  final RxInt brightness = 0.obs; // Default brightness is 0

  @override
  void onInit() {
    super.onInit();

    // Initialize values using arguments from the previous page
    final arguments = Get.arguments ?? {};
    pin.value = arguments['pin'] ?? 'Unknown';
    status.value = arguments['status'] ?? false;
    brightness.value = arguments['brightness'] ?? 0; // Default to 0 if null
  }

  void sendLedState(String pin, bool isOn, [int? brightness]) {
    _ledController.sendLedState(pin, isOn, brightness);

    // Directly update the status and brightness of the LED in the list
    var ledItem = _ledController.ledList.firstWhere((led) => led.pin == pin);

    ledItem.status = isOn;
    ledItem.brightness = brightness ?? 0; // Use 0 if brightness is null
    _ledController.ledList.refresh();
  }

  // Refresh pin, status, and brightness
  void refreshPinAndStatus(String newPin, bool newStatus, int? newBrightness) {
    pin.value = newPin;
    status.value = newStatus;

    // Handle nullable brightness value
    brightness.value = newBrightness ?? 0; // Use 0 if newBrightness is null
  }
}
