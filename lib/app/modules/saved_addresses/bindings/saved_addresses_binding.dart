import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/saved_addresses/controllers/saved_addresses_controller.dart';

class SavedAddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedAddressesController());
  }
}
