import '../../../data/data.dart';

class RiwayatpemesananController extends GetxController {
  final ScrollController scrollController = ScrollController();
  String getOrderStatusText(int index) {
    return listKendaraan[index]['order_status_text'] ?? '-';
  }

  String getOrderStatus(int index) {
    return listKendaraan[index]['order_status'] ?? '';
  }

  String? getPaymentStatus(int index) {
    return listKendaraan[index]['payment_status'];
  }

  final RxInt indexActive = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;
  final RxBool showDataMobil = false.obs;
  final RxBool hasMore = true.obs;

  final RxString statusFilter = ''.obs;

  final RxList listKendaraan = [].obs;
  final RxMap<int, bool> orderRatingStatus = <int, bool>{}.obs; // orderId -> hasRating

  int currentPage = 1;
  static const int limit = 10;

  final List<Map<String, String>> filterTitle = const [
    {'index': '0', 'title': 'Semua', 'status': ''},
    {'index': '1', 'title': 'Menunggu', 'status': 'pending'},
    {'index': '2', 'title': 'Terkonfirmasi', 'status': 'confirmed'},
    {'index': '3', 'title': 'Sedang Berjalan', 'status': 'on_progress'},
    {'index': '4', 'title': 'Selesai', 'status': 'done'},
  ];

  @override
  void onInit() {
    super.onInit();
    getListKendaraan();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          hasMore.value) {
        getListKendaraan(true);
      }
    });
  }

  Future<void> getListKendaraan([bool isPagination = false]) async {
    if (isFetching.value) return;
    isFetching.value = true;

    if (!isPagination) {
      isLoading.value = true;
      listKendaraan.clear();
      currentPage = 1;
      hasMore.value = true;
    }

    try {
      final response = await APIService().get(
        '/orders?page=$currentPage&limit=$limit&status=${statusFilter.value}',
      );

      final List items = response['items'] ?? [];

      listKendaraan.addAll(items);
      currentPage++;

      // Check rating status for each order (run in background, don't block)
      Future.microtask(() async {
        for (var item in items) {
          final orderId = item['id'];
          if (orderId != null && item['order_status'] == 'done') {
            // Run checks sequentially with small delay to avoid overwhelming the API
            await checkOrderRatingStatus(orderId, item);
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      });

      if (items.length < limit) {
        hasMore.value = false;
      }
    } catch (e) {
      debugPrint('RiwayatpemesananController error: $e');
    } finally {
      isFetching.value = false;
      isLoading.value = false;
      showDataMobil.value = true;
    }
  }

  void changeFilter({
    required int index,
    required String status,
  }) {
    if (indexActive.value == index) return;

    indexActive.value = index;
    statusFilter.value = status;
    getListKendaraan(false);
  }

  Future<void> checkOrderRatingStatus(int orderId, Map<String, dynamic> orderData) async {
    try {
      // Check if order has rating field directly
      if (orderData['has_rating'] == true || orderData['rating'] != null) {
        orderRatingStatus[orderId] = true;
        return;
      }

      // If not, check the fleet ratings to see if there's a rating for this order
      final fleet = orderData['fleet'];
      final product = orderData['product'];
      
      if (fleet == null && product == null) return;

      final itemId = fleet?['id'] ?? product?['id'];
      if (itemId == null) return;

      final endpoint = fleet != null 
          ? '/fleets/$itemId/ratings?page=1&limit=100'
          : '/products/$itemId/ratings?page=1&limit=100';
      
      final ratingResponse = await APIService().get(endpoint);
      final ratings = ratingResponse['items'] as List?;
      
      if (ratings != null) {
        // Check if any rating has this order_id
        final hasRating = ratings.any((rating) => 
          rating['order']?['id'] == orderId || 
          rating['order_id'] == orderId
        );
        orderRatingStatus[orderId] = hasRating;
      } else {
        orderRatingStatus[orderId] = false;
      }
    } catch (e) {
      debugPrint('Error checking rating status: $e');
      orderRatingStatus[orderId] = false;
    }
  }

  bool isOrderReviewed(int orderId) {
    return orderRatingStatus[orderId] ?? false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
