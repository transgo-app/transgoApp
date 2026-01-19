import 'dart:async';
import 'package:geocoding/geocoding.dart';
import '../../../data/data.dart';

class DetailitemsController extends GetxController {
  late bool isKendaraan;

  @override
  void onInit() {
    super.onInit();
    isKendaraan = Get.arguments['isKendaraan'] ?? true;

    final dateStr = dataClient['date'];
    final durationStr = dataClient['duration'];

    DateTime startDate = DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
    int duration = int.tryParse(durationStr?.toString() ?? '1') ?? 1;

    dataClient['startDate'] = startDate.toIso8601String();
    dataClient['endDate'] =
        startDate.add(Duration(days: duration)).toIso8601String();
    selectedDurasi.value = duration;
    if (isLoggedIn) {
      getMyVouchers();
      fetchTgPayBalance();
    }

    getDetailAPI(true).then((_) {
      getAddons();
      checkChargeSettings();
      fetchRatings();
    });
    getDataInsurance();

    ever(detailData, (_) {
      updateTotalHarga();
    });

    ever(selectedPengambilan, (value) {
      if (!isPengembalianManual.value) {
        selectedPengembalian.value = value;
        detailLokasiPengembalian.value = detailLokasiPengambilan.value;
        lokasiPengembalianC.text = lokasiPengambilanC.text;
        pengembalianSendiri.value = pengambilanSendiri.value;
      }
    });
  }

  Timer? _apiDebounce;
  RxString selectedPemakaian = 'Dalam Kota'.obs;
  RxString lapentorUrl = ''.obs;
  RxBool pemakaianLuarKota = false.obs;
  RxList outOfTownRates = [].obs;
  RxMap selectedRegion = {}.obs;
  RxInt selectedRegionId = 0.obs;
  RxString selectedRegionName = "".obs;
  RxBool isWithDriver = false.obs;
  bool get isLoggedIn {
    return GlobalVariables.token.value.isNotEmpty;
  }

  RxString selectedPengambilan = ''.obs;
  RxString googleMapEmbed = ''.obs;
  RxString selectedPengembalian = ''.obs;
  RxString selectedAsuransi = '0'.obs;
  RxString selectedHargaAsuransi = '-'.obs;
  RxString titikJalanGeolocator = ''.obs;
  RxString estimasiPembayaranTotal = ''.obs;
  RxInt selectedRegionQuantity = 1.obs;

  RxString detailLokasiPengambilan = ''.obs;
  RxString detailLokasiPengembalian = ''.obs;
  RxString detailSelectedAsuransi = 'Pilih Asuransi'.obs;

  TextEditingController lokasiPengambilanC = TextEditingController();
  TextEditingController lokasiPengembalianC = TextEditingController();
  TextEditingController deskripsiPermintaanKhusus = TextEditingController();

  RxList dataAsuransi = [].obs;
  RxMap detailData = {}.obs;
  RxList dataAddons = <Map<String, dynamic>>[].obs;

  // Charge settings
  RxMap chargeSettings = {}.obs;
  Rxn<Map<String, dynamic>> currentChargeAlert = Rxn<Map<String, dynamic>>();

  // Ratings
  RxList ratings = [].obs;
  RxBool isLoadingRatings = false.obs;
  RxInt totalRatings = 0.obs;
  RxList selectedAddons = <Map<String, dynamic>>[].obs;
  RxList addonsList = <Map<String, dynamic>>[].obs;
  RxList vouchers = [].obs;
  RxMap selectedVoucher = {}.obs;
  RxBool isLoadingVoucher = false.obs;

  RxBool pengambilanSendiri = true.obs;
  RxBool pengembalianSendiri = true.obs;
  RxBool isLoadinggetdetailkendaraan = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingRincian = false.obs;

  RxBool isPengembalianManual = false.obs;

  Timer? _debounce;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  Future<void> getAddressFromCoordinates(
      double latitude, double longitude) async {
    isLoading.value = true;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        titikJalanGeolocator.value =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void onPositionChanged(dynamic camera, bool hasGesture) {
    isLoading.value = true;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      getAddressFromCoordinates(
        camera.center.latitude,
        camera.center.longitude,
      );
    });
  }

  @override
  void onClose() {
    // Cancel all timers
    _debounce?.cancel();
    _apiDebounce?.cancel();
    
    // Dispose focus nodes
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    
    // Clear large data structures to free memory
    dataAsuransi.clear();
    dataAddons.clear();
    addonsList.clear();
    vouchers.clear();
    ratings.clear();
    
    Get.delete<DetailitemsController>();
    super.onClose();
  }

  var dataClient = Get.arguments['dataClient'];
  var dataServer = Get.arguments['dataServer'];
  late Map<String, dynamic> paramPost;
  var selectedDurasi = 1.obs;

  void updateTotalHarga() {
    final harga = isKendaraan
        ? (detailData['rent_price'] ?? 0) -
            ((detailData['rent_price'] ?? 0) *
                    (detailData['discount_percentage'] ?? 0) /
                    100)
                .toInt()
        : (detailData['product']?['price_after_discount'] ??
            detailData['product']?['price'] ??
            0);
    totalHarga.value = harga * selectedDurasi.value;
  }

  var totalHarga = 0.obs;

  Map<String, dynamic> normalizeItem(Map<String, dynamic> response) {
    final raw = isKendaraan ? response['fleet'] : response['product'];

    String mappedType(String? t) {
      switch (t) {
        case 'car':
          return 'Mobil';
        case 'motorcycle':
          return 'Motor';
        default:
          return t ?? '-';
      }
    }

    final normalized = {
      "id": raw?['id'],
      "name": raw?['name'],
      "price": raw?['price'],
      "type": mappedType(raw?['type']),
      "type_code": raw?['type'],
      "price_after_discount": raw?['price_after_discount'],
      "category": raw?['category'],
      "model": raw?['model'] ?? "",
      "location": raw?['location']?['location'] ?? "",
      "map_url": raw?['location']?['map_url'] ?? "",
      "redirect_url": raw?['location']?['redirect_url'] ?? "",
      "lapentor_url": raw?['lapentor_url'] ?? "",
      "full_location": raw?['location'] ?? {},
      "raw": raw,
      "color": raw?['color'] ?? raw?['specifications']?['color'] ?? "",
    };

    return normalized;
  }

  String getLocationPengambilanText(String value) {
    if (value.isEmpty) return "Pilih Lokasi Pengambilan";

    final defaultLocation = detailData['item']?['location'] ?? "-";

    return pengambilanSendiri.value ? defaultLocation : lokasiPengambilanC.text;
  }

  String getLocationPengembalianText(String value) {
    if (value.isEmpty) return "Pilih Lokasi Pengembalian";

    final defaultLocation = detailData['item']?['location'] ?? "-";

    return pengembalianSendiri.value
        ? defaultLocation
        : lokasiPengembalianC.text;
  }

  RxBool menyetujuiSnK = false.obs;
  
  // TG Pay balance
  RxDouble tgPayBalance = 0.0.obs;
  RxBool isLoadingTgPayBalance = false.obs;
  RxBool useTgPayBalance = false.obs;
  
  Future<void> fetchTgPayBalance() async {
    if (GlobalVariables.token.value.isEmpty) {
      tgPayBalance.value = 0.0;
      return;
    }
    
    isLoadingTgPayBalance.value = true;
    try {
      final data = await APIService().get('/topup/balance');
      tgPayBalance.value = (data['balance'] ?? 0).toDouble();
    } catch (e) {
      tgPayBalance.value = 0.0;
    } finally {
      isLoadingTgPayBalance.value = false;
    }
  }

  Future getDetailAPI([bool needLoading = false, bool? isOrder = false]) async {
    _apiDebounce?.cancel();
    if (needLoading) {
      isLoadinggetdetailkendaraan.value = true;
    } else {
      isLoadingRincian.value = true;
    }

    paramPost = {
      isKendaraan ? "fleet_id" : "product_id": dataServer['id'],
      "description": deskripsiPermintaanKhusus.text,
      "is_out_of_town": isKendaraan ? pemakaianLuarKota.value : false,
      if (pemakaianLuarKota.value) ...{
        "region_id": selectedRegionId.value,
        "region_name": selectedRegionName.value,
      },
      "is_with_driver": isKendaraan ? isWithDriver.value : false,
      "out_of_town_days": selectedRegionQuantity.value,
      if (int.tryParse(selectedAsuransi.value) != null &&
          int.parse(selectedAsuransi.value) > 0)
        "insurance_id": int.parse(selectedAsuransi.value),
      "start_request": {
        "is_self_pickup": pengambilanSendiri.value,
        if (!pengambilanSendiri.value) "address": lokasiPengambilanC.text,
      },
      "end_request": {
        "is_self_pickup": pengembalianSendiri.value,
        if (!pengembalianSendiri.value) "address": lokasiPengembalianC.text,
      },
      "date": dataClient['date'],
      "duration": int.parse(dataClient['duration']),
      if (selectedVoucher.isNotEmpty) "voucher_code": selectedVoucher['code'],
      if (selectedAddons.isNotEmpty)
        "addons": selectedAddons
            .map((addon) => {
                  "addon_id": addon['id'],
                  "name": addon['name'],
                  "price": (addon['price'] is RxInt)
                      ? (addon['price'] as RxInt).value
                      : addon['price'],
                  "quantity": (addon['quantity'] is RxInt)
                      ? (addon['quantity'] as RxInt).value
                      : addon['quantity'],
                })
            .toList(),
      "use_balance": useTgPayBalance.value,
    };
    Map<String, dynamic>? response;

    try {
      response = await APIService().post(
        isOrder == true
            ? '/orders/customer'
            : '/orders/calculate-price/customer',
        paramPost,
      );

      if (response != null && isOrder != true) {
        final item = normalizeItem(response);

        detailData.value = {
          ...response,
          "item": item,
          "location": item["location"],
          "map_url": item["map_url"],
          "lapentor_url": item["lapentor_url"],
        };

        estimasiPembayaranTotal.value = response['grand_total'].toString();
        print("📌 DETAIL ITEMS RESPONSE:");
        print(detailData);

        if (googleMapEmbed.value.isEmpty)
          googleMapEmbed.value = item["map_url"];

        if (needLoading) {
          selectedPengambilan.value = item["location"];
          selectedPengembalian.value = item["location"];
        }
        
        // Check charge settings after detail data is loaded
        checkChargeSettings();
      }

      if (response != null && isOrder == true) {
        NotificationService().showNotification(
          title: "Pesanan Anda Sedang Diproses",
          body: "Tunggu konfirmasi selanjutnya",
        );
        return 200;
      }
    } catch (e) {
      print("Error getDetailAPI: $e");
    } finally {
      isLoading.value = false;
      isLoadinggetdetailkendaraan.value = false;
      isLoadingRincian.value = false;
    }
  }

  Future<void> getDataInsurance() async {
    try {
      var data = await APIService().get('/insurances');
      dataAsuransi.value = data['items'];
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAddons({int page = 1, int limit = 10}) async {
    final startDate =
        dataClient['startDate'] ?? DateTime.now().toIso8601String();
    final endDate = dataClient['endDate'] ??
        DateTime.now().add(Duration(days: 1)).toIso8601String();
    final category =
        detailData['item']?['category'] ?? detailData['item']?['type_code'];

    final apiUrl = '/addons?'
        'page=$page'
        '&limit=$limit'
        '&q='
        '&category=$category'
        '&start_date=${startDate.split('T').first}'
        '&end_date=${endDate.split('T').first}';

    try {
      var response = await APIService().get(apiUrl);
      addonsList.value = (response['items'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getAddons: $e');
    }
  }

  void toggleVoucher(Map<String, dynamic> voucher) {
    if (selectedVoucher.isNotEmpty &&
        selectedVoucher['code'] == voucher['code']) {
      selectedVoucher.value = {};
      getDetailAPI();
    } else {
      selectedVoucher.value = voucher;
      getDetailAPI();
    }
  }

  Future<void> getOutOfTownRates() async {
    try {
      var res = await APIService().get("/out-of-town-rates");

      outOfTownRates.value = (res['items'] as List).map((item) {
        return {
          "id": item["id"],
          "region_name": item["region_name"],
          "description": item["description"] ?? "",
          "daily_rate":
              int.tryParse(item["daily_rate"].toString().split(".")[0]) ?? 0,
          "motorcycle_daily_rate": int.tryParse(
                  item["motorcycle_daily_rate"].toString().split(".")[0]) ??
              0,
        };
      }).toList();
    } catch (e) {
      print("Error getOutOfTownRates: $e");
    }
  }

  Future<void> getMyVouchers() async {
    if (!isLoggedIn) return;
    isLoadingVoucher.value = true;
    try {
      final res = await APIService().get('/discount/vouchers/me');

      final now = DateTime.now();

      vouchers.value = (res as List).where((v) {
        final isUsed = v['is_used'] == true;
        final expiredAt = DateTime.tryParse(v['expires_at'] ?? '');
        final minSubtotal = v['min_subtotal_amount'] ?? 0;

        if (isUsed) return false;
        if (expiredAt == null || expiredAt.isBefore(now)) return false;
        if (totalHarga.value < minSubtotal) return false;

        return true;
      }).toList();
    } catch (e) {
      print('Error getMyVouchers: $e');
    } finally {
      isLoadingVoucher.value = false;
    }
  }

  void selectVoucher(Map<String, dynamic> voucher) {
    selectedVoucher.value = voucher;
    getDetailAPI();
  }

  void chooseRegion(Map<String, dynamic> region) {
    selectedRegion.value = region;
    selectedRegionId.value = region['id'];
    selectedRegionName.value = region['region_name'];
    final isCar = detailData['item']?['type_code'] == 'car';

    final hargaLuarKota =
        isCar ? region['daily_rate'] : region['motorcycle_daily_rate'];

    print("➡ Harga luar kota terpilih: $hargaLuarKota");
    getDetailAPI();
  }

  // Charge settings methods
  Future<void> fetchChargeSettings() async {
    try {
      var data = await APIService().get('/order-calculation-settings');
      chargeSettings.value = data ?? {};
    } catch (e) {
      print("Error fetching charge settings: $e");
      chargeSettings.value = {};
    }
  }

  // Calculate high season charge amount for D-1
  int getHighSeasonChargeAmount() {
    final alert = currentChargeAlert.value;
    if (alert == null || alert['type'] != 'd1') {
      return 0;
    }

    final chargePercent = alert['chargePercent'] ?? 0;
    if (chargePercent == 0) return 0;

    // Get base rent price for 1 day
    final basePrice = detailData['rent_price'] ?? 0;
    if (basePrice == 0) return 0;

    // Calculate charge: percentage of base price for 1 day
    final chargeAmount = (basePrice * chargePercent / 100).round();
    return chargeAmount;
  }

  String formatFleetNames(List<dynamic> fleets) {
    if (fleets.isEmpty) return '';
    
    final fleetMap = {
      'car': 'Mobil',
      'motorcycle': 'Motor',
    };
    
    final names = fleets
        .map((f) => fleetMap[f.toString()] ?? f.toString())
        .where((name) => name.isNotEmpty)
        .toList();
    
    if (names.isEmpty) return '';
    if (names.length == 1) return names.first;
    if (names.length == 2) return '${names[0]} dan ${names[1]}';
    return names.join(', ');
  }

  Future<void> checkChargeSettings() async {
    if (!isKendaraan) {
      currentChargeAlert.value = null;
      return;
    }

    final dateStr = dataClient['date'];
    if (dateStr == null || dateStr.isEmpty) {
      currentChargeAlert.value = null;
      return;
    }

    final categoryType = detailData['item']?['type_code'] as String?;
    if (categoryType != 'car' && categoryType != 'motorcycle') {
      currentChargeAlert.value = null;
      return;
    }

    // Fetch settings if not already fetched
    if (chargeSettings.isEmpty) {
      await fetchChargeSettings();
    }

    final calendarRanges = chargeSettings['calendar_dates_ranges'] as List?;
    if (calendarRanges == null || calendarRanges.isEmpty) {
      currentChargeAlert.value = null;
      return;
    }

    try {
      // Parse date from ISO string and convert to local (WIB on user device)
      // Example formats: "2026-01-11T12:00:00.000Z" or "2026-01-11T12:00:00+07:00"
      final dateTime = DateTime.tryParse(dateStr) ?? DateTime.now();
      final selectedDate = dateTime.toLocal();

      // Use local hour so 19:00 WIB stays 19, not converted to UTC
      final int selectedHour = selectedDate.hour;

      Map<String, dynamic>? mostRelevantAlert;
      DateTime? mostRelevantDate;

      for (var range in calendarRanges) {
        final fleets = range['fleets'] as List?;
        if (fleets == null || fleets.isEmpty) continue;

        // Check if selected category matches fleets
        if (!fleets.contains(categoryType)) continue;

        final startDateStr = range['start_date'] as String?;
        final endDateStr = range['end_date'] as String?;
        if (startDateStr == null || endDateStr == null) continue;

        // Parse dates - extract date part from ISO string to avoid timezone issues
        final startDateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(startDateStr);
        final endDateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(endDateStr);
        
        if (startDateMatch == null || endDateMatch == null) continue;
        
        final startYear = int.parse(startDateMatch.group(1)!);
        final startMonth = int.parse(startDateMatch.group(2)!);
        final startDay = int.parse(startDateMatch.group(3)!);
        
        final endYear = int.parse(endDateMatch.group(1)!);
        final endMonth = int.parse(endDateMatch.group(2)!);
        final endDay = int.parse(endDateMatch.group(3)!);
        
        // Normalize to date only (remove time)
        final startDateOnly = DateTime(startYear, startMonth, startDay);
        final endDateOnly = DateTime(endYear, endMonth, endDay);
        final selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

        // Convert dates to comparable integer format (YYYYMMDD)
        final selectedDays = selectedDateOnly.year * 10000 + selectedDateOnly.month * 100 + selectedDateOnly.day;
        final startDays = startYear * 10000 + startMonth * 100 + startDay;
        final endDays = endYear * 10000 + endMonth * 100 + endDay;
        final d1Days = startDays - 1; // One day before start date
        
        // Check D-1 (one day before start date)
        // Only show D-1 alert if booking time is 12:00 WIB or later
        final isD1 = selectedDays == d1Days && selectedHour >= 12;
        
        if (isD1) {
          // D-1 alert
          final fleetNames = formatFleetNames(fleets);
          final chargePercent = selectedHour > 18 ? 50 : 30;
          final timeRange = selectedHour > 18 
              ? 'setelah pukul 18.00 WIB' 
              : 'pukul 12.00-18.00 WIB';
          
          final alert = {
            'type': 'd1',
            'name': range['name'] ?? '',
            'fleets': fleetNames,
            'chargePercent': chargePercent,
            'timeRange': timeRange,
            'range': range,
          };

          // Keep the most relevant (earliest start date)
          if (mostRelevantAlert == null || 
              (mostRelevantDate == null || startDateOnly.isBefore(mostRelevantDate))) {
            mostRelevantAlert = alert;
            mostRelevantDate = startDateOnly;
          }
        }

        // Check D-DAY (within the period, inclusive) - only if not D-1
        if (!isD1) {
          // Check if selected date is within the period (inclusive)
          if (selectedDays >= startDays && selectedDays <= endDays) {
            final fleetNames = formatFleetNames(fleets);
            
            final alert = {
              'type': 'dday',
              'name': range['name'] ?? '',
              'formatted_start_date': range['formatted_start_date'] ?? '',
              'formatted_end_date': range['formatted_end_date'] ?? '',
              'fleets': fleetNames,
              'range': range,
            };

            // Keep the most relevant (earliest start date)
            if (mostRelevantAlert == null || 
                (mostRelevantDate == null || startDateOnly.isBefore(mostRelevantDate))) {
              mostRelevantAlert = alert;
              mostRelevantDate = startDateOnly;
            }
          }
        }
      }

      currentChargeAlert.value = mostRelevantAlert;
    } catch (e) {
      print("Error checking charge settings: $e");
      currentChargeAlert.value = null;
    }
  }

  // Ratings methods
  Future<void> fetchRatings({int page = 1, int limit = 2}) async {
    if (isLoadingRatings.value) return;
    
    isLoadingRatings.value = true;
    try {
      // Get item ID from dataServer (passed from dashboard) or detailData
      int? itemId;
      if (dataServer['id'] != null) {
        itemId = dataServer['id'];
      } else {
        if (isKendaraan) {
          final fleetData = detailData['fleet'] as Map?;
          itemId = fleetData?['id'];
        } else {
          final productData = detailData['product'] as Map?;
          itemId = productData?['id'];
        }
      }
      
      if (itemId == null) {
        ratings.value = [];
        totalRatings.value = 0;
        return;
      }

      final endpoint = isKendaraan 
          ? '/fleets/$itemId/ratings?page=$page&limit=$limit'
          : '/products/$itemId/ratings?page=$page&limit=$limit';
      
      var data = await APIService().get(endpoint);
      
      if (data != null && data['items'] != null) {
        ratings.value = data['items'] as List;
        totalRatings.value = data['meta']?['total_items'] ?? 0;
      } else {
        ratings.value = [];
        totalRatings.value = 0;
      }
    } catch (e) {
      print("Error fetching ratings: $e");
      ratings.value = [];
      totalRatings.value = 0;
    } finally {
      isLoadingRatings.value = false;
    }
  }
}
