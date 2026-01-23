import 'package:get/get.dart';
import '../controllers/reviews_controller.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments ?? {};
    Get.lazyPut<ReviewsController>(
      () => ReviewsController(
        itemId: args['itemId'] ?? 0,
        isKendaraan: args['isKendaraan'] ?? true,
        itemName: args['itemName'] ?? 'Item',
      ),
    );
  }
}