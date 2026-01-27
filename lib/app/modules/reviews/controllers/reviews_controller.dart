import 'package:get/get.dart';
import '../../../data/data.dart';

class ReviewsController extends GetxController {
  final int itemId;
  final bool isKendaraan;
  final String itemName;

  ReviewsController({
    required this.itemId,
    required this.isKendaraan,
    required this.itemName,
  });

  RxList ratings = [].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;
  RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings({int page = 1, bool loadMore = false}) async {
    if (isLoading.value && !loadMore) return;
    
    isLoading.value = true;
    try {
      final endpoint = isKendaraan 
          ? '/fleets/$itemId/ratings?page=$page&limit=10'
          : '/products/$itemId/ratings?page=$page&limit=10';
      
      var data = await APIService().get(endpoint);
      
      if (data != null && data['items'] != null) {
        if (loadMore) {
          ratings.addAll(data['items'] as List);
        } else {
          ratings.value = data['items'] as List;
        }
        
        totalItems.value = data['meta']?['total_items'] ?? 0;
        currentPage.value = data['pagination']?['current_page'] ?? 1;
        totalPages.value = data['pagination']?['total_page'] ?? 1;
        hasMore.value = data['pagination']?['next_page'] != null;
      } else {
        if (!loadMore) {
          ratings.value = [];
        }
      }
    } catch (e) {
      print("Error fetching ratings: $e");
      if (!loadMore) {
        ratings.value = [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      fetchRatings(page: currentPage.value + 1, loadMore: true);
    }
  }

  Future<void> refresh() async {
    currentPage.value = 1;
    hasMore.value = true;
    await fetchRatings(page: 1);
  }
}
