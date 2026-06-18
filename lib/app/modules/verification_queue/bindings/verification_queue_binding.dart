import 'package:get/get.dart';
import '../controllers/verification_queue_controller.dart';

class VerificationQueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationQueueController>(
      () => VerificationQueueController(),
    );
  }
}
