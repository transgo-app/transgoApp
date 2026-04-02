import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/saved_addresses/controllers/saved_address_form_controller.dart';

class SavedAddressFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedAddressFormController());
  }
}
