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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
