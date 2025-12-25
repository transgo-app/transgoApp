import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/detailuser/controllers/detailuser_controller.dart';


class DetailuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailuserController>(
      () => DetailuserController(),
    );
  }
}
