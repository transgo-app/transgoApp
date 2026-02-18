import 'package:get/get.dart';
import '../../../data/service/APIService.dart';
import '../../../data/models/fleet_ranking_model.dart';

class FleetRankingController extends GetxController {
  // Selected fleet type tab: 'car' or 'motorcycle'
  RxString selectedType = 'car'.obs;
  
  // Ranking data
  RxList<FleetRankingItem> rankingItems = <FleetRankingItem>[].obs;
  
  // Loading state
  RxBool isLoading = false.obs;
  
  // Error state
  RxString errorMessage = ''.obs;
  
  // Limit for ranking items
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchRanking();
  }

  /// Fetch fleet ranking from API
  Future<void> fetchRanking() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final endpoint = '/fleets/ranking/revenue?limit=$limit&type=${selectedType.value}';
      final response = await APIService().get(endpoint);
      
      if (response != null) {
        final rankingResponse = FleetRankingResponse.fromJson(response);
        rankingItems.value = rankingResponse.data;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat data ranking';
      print('Error fetching fleet ranking: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch fleet type and refresh data
  void switchType(String type) {
    if (selectedType.value != type) {
      selectedType.value = type;
      fetchRanking();
    }
  }

  /// Get rank badge color based on position
  int getRankBadgeColor(int rank) {
    switch (rank) {
      case 1:
        return 0xFFFFD700; // Gold
      case 2:
        return 0xFFC0C0C0; // Silver
      case 3:
        return 0xFFCD7F32; // Bronze
      default:
        return 0xFF1F61D9; // Primary blue
    }
  }

  /// Format rental days text
  String formatRentalDays(int days) {
    return 'Telah tersewa $days hari';
  }
}
