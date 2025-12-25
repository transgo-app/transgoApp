import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/additionaldata/controllers/additionaldata_controller.dart';


class AdditionaldataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdditionaldataController>(
      () => AdditionaldataController(),
    );
  }
}
