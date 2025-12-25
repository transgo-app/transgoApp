import 'package:get/get.dart';

import '../controllers/detailriwayat_controller.dart';

class DetailriwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailriwayatController>(
      () => DetailriwayatController(),
    );
  }
}
