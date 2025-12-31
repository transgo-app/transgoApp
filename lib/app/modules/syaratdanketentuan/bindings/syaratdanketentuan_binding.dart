import 'package:get/get.dart';
import '../controllers/syaratdanketentuan_controller.dart';

class SyaratKetentuanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SyaratKetentuanController>(
      () => SyaratKetentuanController(),
    );
  }
}
