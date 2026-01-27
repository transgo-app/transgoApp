import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class DetailriwayatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getDataInsurance();
    isLoading.value = true;
    getDataById().then((value) {
      getDetailRiwayat();
    });
    permintaanKhususC.text = dataArguments['description'] ?? 'Tidak Ada';
    fetchTgPayBalance();
  }

  var dataArguments = Get.arguments;

  RxInt activePenanggungJawabTab = 1.obs;
  RxBool menyetujuiPembatalan = false.obs;
  TextEditingController permintaanKhususC = TextEditingController();

  RxMap detailKendaraan = {}.obs;
  RxMap detaiItemsID = {}.obs;
  RxList riwayatAsuransi = [].obs;
  RxString googleMapEmbed = ''.obs;
  RxBool isCancelOrderDisabled = false.obs;
  RxBool isLoadingCancelTicket = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingGetSingleData = false.obs;
  RxBool hasRating = false.obs;
  
  // Transgo Pay balance
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
      // Error handled silently
    } finally {
      isLoadingGetSingleData.value = false;
    }
  }

  Future<void> checkRatingStatus() async {
    try {
      // Check if order has rating field directly
      if (detaiItemsID['has_rating'] == true || detaiItemsID['rating'] != null) {
        hasRating.value = true;
        return;
      }

      // If not, check the fleet ratings to see if there's a rating for this order
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
        // Check if any rating has this order_id
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
    var startReq = dataArguments['start_request'] ?? {};
    var endReq = dataArguments['end_request'] ?? {};
    var paramPost = {
      "fleet_id": dataArguments['fleet']?['id'],
      "product_id": dataArguments['product']?['id'],
      "customer_id": dataArguments['customer_id'],
      "description": dataArguments['description'],
      "is_out_of_town": dataArguments['is_out_of_town'],
      "is_with_driver": dataArguments['is_with_driver'],
      "insurance_id": detaiItemsID['insurance']?['id'],
      "rental_type": dataArguments['rental_type'],
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
      "date": dataArguments['start_date'],
      "duration": dataArguments['duration'],
      "discount": dataArguments['discount'],
      "service_price": dataArguments['service_price'],
      "out_of_town_price": dataArguments['out_of_town_price'],
      "other_price": null,
      "additional_services": dataArguments['additional_services'] ?? [],
      "addons": dataArguments['addons'] ?? [],
      "addons_price": dataArguments['addons_price'] ?? 0
    };
    try {
      var data = await APIService().post('/orders/calculate-price', paramPost);
      detailKendaraan.value = data;
      checkCancelOrderStatus(detaiItemsID);
    } catch (e) {
      // Error handled silently
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
      await APIService().delete('/orders/${dataArguments['id']}');
      NotificationService().showNotification(
        title:
            "Sewa ${detaiItemsID['fleet']?['name'] ?? detaiItemsID['product']?['name']} Untuk Durasi ${detaiItemsID['duration']} Telah Dibatalkan",
        body:
            "Kami menginformasikan bahwa sewa Anda telah dibatalkan. Hubungi layanan pelanggan jika perlu."
      );
    } catch (e) {
      // Error handled silently
    } finally {
      isLoadingCancelTicket.value = false;
    }
  }

  String getDescriptionByPrice(RxList<dynamic> items, int targetPrice) {
    var item = items.firstWhere((item) => item['price'] == targetPrice,
        orElse: () => null);
    return item != null
        ? item['description'] ?? ''
        : 'Item dengan harga $targetPrice tidak ditemukan.';
  }

  String getTitle(RxList<dynamic> items, int targetPrice) {
    var item = items.firstWhere((item) => item['price'] == targetPrice,
        orElse: () => null);
    return item != null ? item['name'] ?? '' : 'Item dengan harga $targetPrice tidak ditemukan.';
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
    
    final orderId = dataArguments['id'];
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
      // Call API to pay with Transgo Pay balance
      await APIService().post('/orders/$orderId/pay-with-balance', {
        'amount': grandTotal,
      });
      
      // Refresh order data and balance
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
}
