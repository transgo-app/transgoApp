import '../../../data/data.dart';

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
    } catch (e) {
      print(e);
    } finally {
      isLoadingGetSingleData.value = false;
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
      print('Error: $e');
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
      print('Error: $e');
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
}
