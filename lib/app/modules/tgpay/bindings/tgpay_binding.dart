import 'package:get/get.dart';
import '../controllers/tgpay_controller.dart';

class TgPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TgPayController>(
      () => TgPayController(),
    );
  }
}
