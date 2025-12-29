import 'package:get/get.dart';
import '../controllers/transgoreward_controller.dart';

class TransGoRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransGoRewardController>(() => TransGoRewardController());
  }
}
