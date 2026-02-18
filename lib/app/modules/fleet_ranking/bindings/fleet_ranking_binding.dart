import 'package:get/get.dart';
import '../controllers/fleet_ranking_controller.dart';

class FleetRankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FleetRankingController>(() => FleetRankingController());
  }
}
