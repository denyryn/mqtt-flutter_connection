import 'package:get/get.dart';

class Utils extends GetxController {
  void refreshVariables(RxList vars) {
    for (var variable in vars) {
      variable.refresh();
    }
  }

  void refreshVariableValue(RxObjectMixin variable, value) {
    variable.value = value;
    variable.refresh();
  }
}
