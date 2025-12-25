import 'package:get/get.dart';

import '../controllers/detailitems_controller.dart';

class DetailitemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailitemsController>(
      () => DetailitemsController(),
    );
  }
}
