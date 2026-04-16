import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../widget/Card/BackgroundCard.dart';

class DetailriwayatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchChargeSettings();
    getDataInsurance();
    isLoading.value = true;
    getDataById().then((value) {
      getDetailRiwayat();
    });
    permintaanKhususC.text = dataArguments['description'] ?? 'Tidak Ada';
    fetchTgPayBalance();
  }

  Future<void> fetchChargeSettings() async {
    try {
      final data = await APIService().get('/order-calculation-settings');
      chargeSettings.value = data ?? {};
    } catch (e) {
      chargeSettings.value = {};
    }
  }

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

  var dataArguments = Get.arguments;

  RxInt activePenanggungJawabTab = 1.obs;
  RxBool menyetujuiPembatalan = false.obs;
  TextEditingController permintaanKhususC = TextEditingController();
  TextEditingController alasanRescheduleC = TextEditingController();

  RxMap detailKendaraan = {}.obs;
  RxMap detaiItemsID = {}.obs;
  RxList riwayatAsuransi = [].obs;

  final RxMap chargeSettings = {}.obs;
  RxString googleMapEmbed = ''.obs;
  RxBool isCancelOrderDisabled = false.obs;
  RxBool isLoadingCancelTicket = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingGetSingleData = false.obs;
  RxBool hasRating = false.obs;
  
  RxDouble tgPayBalance = 0.0.obs;
  RxBool isLoadingBalance = false.obs;
  RxBool isProcessingPayment = false.obs;

  void checkCancelOrderStatus(RxMap<dynamic, dynamic> detaiItemsID) {
    isCancelOrderDisabled.value =
        detaiItemsID['payment_status'] != 'pending' ||
        detaiItemsID['order_status'] == 'on_going' ||
        detaiItemsID['order_status'] == 'done' ||
        detaiItemsID['order_status'] == null;
  }

  Future<void> getDataById() async {
    isLoadingGetSingleData.value = true;
    try {
      var dataId = await APIService().get("/orders/${dataArguments['id']}");
      detaiItemsID.value = dataId;
      getDetailRiwayat();
      checkRatingStatus();
    } catch (e) {
    } finally {
      isLoadingGetSingleData.value = false;
    }
  }

  Future<void> checkRatingStatus() async {
    try {
      if (detaiItemsID['has_rating'] == true || detaiItemsID['rating'] != null) {
        hasRating.value = true;
        return;
      }

      final fleet = detaiItemsID['fleet'];
      final product = detaiItemsID['product'];
      final orderId = detaiItemsID['id'];
      
      if ((fleet == null && product == null) || orderId == null) {
        hasRating.value = false;
        return;
      }

      final itemId = fleet?['id'] ?? product?['id'];
      if (itemId == null) {
        hasRating.value = false;
        return;
      }

      final endpoint = fleet != null 
          ? '/fleets/$itemId/ratings?page=1&limit=100'
          : '/products/$itemId/ratings?page=1&limit=100';
      
      final ratingResponse = await APIService().get(endpoint);
      final ratings = ratingResponse['items'] as List?;
      
      if (ratings != null) {
        final hasRatingForOrder = ratings.any((rating) => 
          rating['order']?['id'] == orderId || 
          rating['order_id'] == orderId
        );
        hasRating.value = hasRatingForOrder;
      } else {
        hasRating.value = false;
      }
    } catch (e) {
      hasRating.value = false;
    }
  }

  Future<void> getDetailRiwayat() async {
    var startReq = detaiItemsID['start_request'] ?? {};
    var endReq = detaiItemsID['end_request'] ?? {};
    var paramPost = {
      "fleet_id": detaiItemsID['fleet']?['id'],
      "product_id": detaiItemsID['product']?['id'],
      "customer_id": detaiItemsID['customer_id'],
      "description": detaiItemsID['description'],
      "is_out_of_town": detaiItemsID['is_out_of_town'],
      "is_with_driver": detaiItemsID['is_with_driver'],
      "insurance_id": detaiItemsID['insurance']?['id'],
      "rental_type": detaiItemsID['rental_type'],
      "start_request": {
        "is_self_pickup": startReq['is_self_pickup'] ?? false,
        "address": startReq['address'] ?? '',
        "distance": startReq['distance'] ?? 0,
        "driver_id": startReq['driver_id'] ?? 0,
      },
      "end_request": {
        "is_self_pickup": endReq['is_self_pickup'] ?? false,
        "address": endReq['address'] ?? '',
        "distance": endReq['distance'] ?? 0,
        "driver_id": endReq['driver_id'] ?? 0,
      },
      "date": detaiItemsID['start_date'],
      "duration": detaiItemsID['duration'],
      "discount": detaiItemsID['discount_percentage'],
      "service_price": detaiItemsID['service_price'],
      "out_of_town_price": detaiItemsID['out_of_town_price'],
      "other_price": null,
      "additional_services": detaiItemsID['additional_services'] ?? [],
      "addons": detaiItemsID['addons'] ?? [],
      "addons_price": detaiItemsID['addons_price'] ?? 0
    };
    try {
      var data = await APIService().post('/orders/calculate-price', paramPost);
      detailKendaraan.value = data;
      checkCancelOrderStatus(detaiItemsID);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDataInsurance() async {
    try {
      var data = await APIService().get('/insurances');
      riwayatAsuransi.value = data['items'];
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> batalkanSewaAPI() async {
    isLoadingCancelTicket.value = true;
    try {
      await APIService().delete('/orders/${detaiItemsID['id']}');
      NotificationService().showNotification(
        title:
            "Sewa ${detaiItemsID['fleet']?['name'] ?? detaiItemsID['product']?['name']} Untuk Durasi ${detaiItemsID['duration']} Telah Dibatalkan",
        body:
            "Kami menginformasikan bahwa sewa Anda telah dibatalkan. Hubungi layanan pelanggan jika perlu."
      );
    } catch (e) {
    } finally {
      isLoadingCancelTicket.value = false;
    }
  }

  Future<void> fetchTgPayBalance() async {
    if (GlobalVariables.token.value.isEmpty) {
      tgPayBalance.value = 0.0;
      return;
    }
    
    isLoadingBalance.value = true;
    try {
      final data = await APIService().get('/topup/balance');
      tgPayBalance.value = (data['balance'] ?? 0).toDouble();
    } catch (e) {
      tgPayBalance.value = 0.0;
    } finally {
      isLoadingBalance.value = false;
    }
  }

  Future<bool> payWithTransgoPay() async {
    if (isProcessingPayment.value) return false;
    
    final orderId = detaiItemsID['id'];
    final grandTotal = detailKendaraan['grand_total'] ?? 0;
    
    if (tgPayBalance.value < grandTotal) {
      CustomSnackbar.show(
        title: 'Saldo Tidak Cukup',
        message: 'Saldo anda kurang, silahkan topup terlebih dahulu',
        backgroundColor: Colors.red,
      );
      return false;
    }

    isProcessingPayment.value = true;
    try {
      await APIService().post('/orders/$orderId/pay-with-balance', {
        'amount': grandTotal,
      });
      await getDataById();
      await fetchTgPayBalance();
      CustomSnackbar.show(
        title: 'Pembayaran Berhasil',
        message: 'Pembayaran menggunakan Transgo Pay berhasil dilakukan',
        backgroundColor: Colors.green,
      );
      return true;
    } catch (e) {
      CustomSnackbar.show(
        title: 'Pembayaran Gagal',
        message: 'Terjadi kesalahan saat memproses pembayaran',
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void showChangeSchedulePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSchedulePickerSheet(context),
    );
  }

  Widget _buildSchedulePickerSheet(BuildContext context) {
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
              final dateStr = detaiItemsID['start_date'] ?? '';
              final formatted = dateStr.isNotEmpty 
                  ? formatTanggalIndonesia(dateStr) 
                  : "Pilih tanggal";
              return BackgroundCard(
                ontap: () => _handleDatePicker(context),
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
                        final dateStr = detaiItemsID['start_date'] ?? '';
                        final time = dateStr.isNotEmpty 
                            ? DateFormat('HH:mm').format(DateTime.parse(dateStr)) 
                            : "12:00";
                        return BackgroundCard(
                          ontap: () => _handleTimePicker(context),
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
                        final durasi = detaiItemsID['duration'] ?? 1;
                        return BackgroundCard(
                          ontap: () => _handleDurationPicker(context),
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
                updateOrderSchedule();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDatePicker(BuildContext context) async {
    final current = DateTime.tryParse("${detaiItemsID['start_date']}") ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final time = current;
      final newDateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
      detaiItemsID['start_date'] = newDateTime.toIso8601String();
      detaiItemsID.refresh();
    }
  }

  Future<void> _handleTimePicker(BuildContext context) async {
    final current = DateTime.tryParse("${detaiItemsID['start_date']}") ?? DateTime.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked != null) {
      final newDateTime = DateTime(current.year, current.month, current.day, picked.hour, picked.minute);
      detaiItemsID['start_date'] = newDateTime.toIso8601String();
      detaiItemsID.refresh();
    }
  }

  void _handleDurationPicker(BuildContext context) {
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
                      detaiItemsID['duration'] = val;
                      detaiItemsID.refresh();
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
  }

  Future<void> updateOrderSchedule() async {
    if (alasanRescheduleC.text.trim().isEmpty) {
      CustomSnackbar.show(
        title: 'Alasan Belum Diisi',
        message: 'Mohon tuliskan alasan perubahan jadwal Anda.',
        backgroundColor: Colors.red,
      );
      return;
    }

    final orderId = detaiItemsID['id'];
    isLoading.value = true;
    try {
      await APIService().post('/orders/$orderId/reschedule-request', {
        'new_start_date': detaiItemsID['start_date'],
        'new_duration': detaiItemsID['duration'],
        'reason': alasanRescheduleC.text,
      });
      
      Get.back();
      await getDataById();
      
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
