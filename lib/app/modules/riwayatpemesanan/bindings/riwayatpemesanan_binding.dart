import 'package:get/get.dart';

import '../controllers/riwayatpemesanan_controller.dart';

class RiwayatpemesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatpemesananController>(
      () => RiwayatpemesananController(),
    );
  }
}
