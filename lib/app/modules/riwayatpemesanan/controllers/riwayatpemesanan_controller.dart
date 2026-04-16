import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../widget/Card/BackgroundCard.dart';

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

  /// Charge settings for high season crossing check (order-calculation-settings).
  final RxMap chargeSettings = {}.obs;

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
    fetchChargeSettings();
    getListKendaraan();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          hasMore.value) {
        getListKendaraan(true);
      }
    });
  }

  Future<void> fetchChargeSettings() async {
    try {
      final data = await APIService().get('/order-calculation-settings');
      chargeSettings.value = data ?? {};
    } catch (e) {
      chargeSettings.value = {};
    }
  }

  /// True if rental period [startDate, startDate + duration - 1] crosses any high season range.
  bool rentalCrossesHighSeason(String startDateStr, int duration, dynamic orderData) {
    final ranges = chargeSettings['calendar_dates_ranges'] as List?;
    final fleet = orderData['fleet'];
    final product = orderData['product'];
    final categoryType = fleet != null ? fleet['type'] : product?['category'];
    return rentalPeriodCrossesHighSeason(
      startDateStr,
      duration,
      categoryType?.toString(),
      ranges,
    );
  }

  Future<void> refreshData() async {
    // Clear API cache for orders endpoint to ensure fresh data
    APIService.clearCache('/orders');
    
    // Force refresh by resetting all states
    isFetching.value = false;
    isLoading.value = true;
    listKendaraan.clear();
    currentPage = 1;
    hasMore.value = true;
    orderRatingStatus.clear();
    
    // Reset scroll position to top
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
    
    await getListKendaraan(false);
  }

  Future<void> getListKendaraan([bool isPagination = false]) async {
    if (isFetching.value && isPagination) return; // Only block pagination, not refresh
    isFetching.value = true;

    if (!isPagination) {
      isLoading.value = true;
      listKendaraan.clear();
      currentPage = 1;
      hasMore.value = true;
    }

    try {
      // Build query string so that when no status filter is selected ("Semua" tab),
      // we do NOT send an empty status parameter to the API. Some backends treat
      // "status=" as an actual filter that returns no data.
      final String statusQuery = statusFilter.value.isNotEmpty
          ? '&status=${statusFilter.value}'
          : '';

      // Always bypass cache for orders to get fresh data
      final response = await APIService().get(
        '/orders?page=$currentPage&limit=$limit$statusQuery',
        useCache: false, // Disable cache for orders
      );

      final List items = response['items'] ?? [];

      if (!isPagination) {
        // Create a new list to ensure GetX detects the change
        listKendaraan.value = List.from(items);
      } else {
        listKendaraan.addAll(items); // Add for pagination
      }
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

  final TextEditingController alasanRescheduleC = TextEditingController();

  void showChangeSchedulePicker(BuildContext context, dynamic data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSchedulePickerSheet(context, data),
    );
  }

  Widget _buildSchedulePickerSheet(BuildContext context, dynamic data) {
    // Local state for picker within the sheet
    final RxMap localOrder = Map<String, dynamic>.from(data).obs;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                gabaritoText(text: "Ganti Jadwal Sewa", fontSize: 18, fontWeight: FontWeight.bold),
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 10),
            const gabaritoText(
              text: "Pastikan ketersediaan unit dan harga mungkin berubah sesuai jadwal baru.",
              fontSize: 12,
              textColor: Colors.orange,
            ),
            const SizedBox(height: 20),
            gabaritoText(text: "Tanggal Mulai Baru", fontSize: 14),
            const SizedBox(height: 8),
            Obx(() {
              final dateStr = localOrder['start_date'] ?? '';
              final formatted = dateStr.isNotEmpty 
                  ? formatTanggalIndonesia(dateStr) 
                  : "Pilih tanggal";
              return BackgroundCard(
                ontap: () async {
                  final current = DateTime.tryParse("${localOrder['start_date']}") ?? DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: current,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    final time = current;
                    final newDateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                    localOrder['start_date'] = newDateTime.toIso8601String();
                  }
                },
                height: 50,
                body: Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 20, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(formatted, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gabaritoText(text: "Waktu Mulai", fontSize: 14),
                      const SizedBox(height: 8),
                      Obx(() {
                        final dateStr = localOrder['start_date'] ?? '';
                        final time = dateStr.isNotEmpty 
                            ? DateFormat('HH:mm').format(DateTime.parse(dateStr)) 
                            : "12:00";
                        return BackgroundCard(
                          ontap: () async {
                            final current = DateTime.tryParse("${localOrder['start_date']}") ?? DateTime.now();
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(current),
                            );
                            if (picked != null) {
                              final newDateTime = DateTime(current.year, current.month, current.day, picked.hour, picked.minute);
                              localOrder['start_date'] = newDateTime.toIso8601String();
                            }
                          },
                          height: 50,
                          body: Row(
                            children: [
                              const Icon(Icons.access_time, size: 20, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(time, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gabaritoText(text: "Durasi", fontSize: 14),
                      const SizedBox(height: 8),
                      Obx(() {
                        final durasi = localOrder['duration'] ?? 1;
                        return BackgroundCard(
                          ontap: () {
                            final durasiItems = List.generate(30, (i) => i + 1);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: gabaritoText(text: "Pilih Durasi Sewa", fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: durasiItems.length,
                                        itemBuilder: (context, index) {
                                          final val = durasiItems[index];
                                          return ListTile(
                                            title: Text("$val Hari"),
                                            onTap: () {
                                              localOrder['duration'] = val;
                                              Get.back();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          height: 50,
                          body: Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 20, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text("$durasi Hari", style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            gabaritoText(text: "Alasan Perubahan Jadwal", fontSize: 14),
            const SizedBox(height: 8),
            reusableTextField(
              title: "Contoh: Rencana berubah / Ada acara mendadak",
              controller: alasanRescheduleC,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ReusableButton(
              title: "Terapkan Jadwal Baru",
              bgColor: primaryColor,
              ontap: () {
                updateOrderSchedule(localOrder);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> updateOrderSchedule(RxMap localOrder) async {
    if (alasanRescheduleC.text.trim().isEmpty) {
      CustomSnackbar.show(
        title: 'Alasan Belum Diisi',
        message: 'Mohon tuliskan alasan perubahan jadwal Anda.',
        backgroundColor: Colors.red,
      );
      return;
    }

    final orderId = localOrder['id'];
    isLoading.value = true;
    try {
      await APIService().post('/orders/$orderId/reschedule-request', {
        'new_start_date': localOrder['start_date'],
        'new_duration': localOrder['duration'],
        'reason': alasanRescheduleC.text,
      });
      
      Get.back(); // close picker
      alasanRescheduleC.clear();
      await refreshData(); // refresh the list
      
      CustomSnackbar.show(
        title: 'Jadwal Berhasil Diperbarui',
        message: 'Jadwal sewa dan harga telah disesuaikan.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal Memperbarui Jadwal',
        message: 'Terjadi kesalahan atau unit tidak tersedia di jadwal tersebut.',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
