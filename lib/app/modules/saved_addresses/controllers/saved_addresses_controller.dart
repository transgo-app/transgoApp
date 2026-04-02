import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/data/service/APIService.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class SavedAddressesController extends GetxController {
  final addresses = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final raw =
          await APIService().get('/customer-saved-addresses', useCache: false);
      List<dynamic> list = [];
      if (raw is List) {
        list = raw;
      } else if (raw is Map && raw['data'] is List) {
        list = raw['data'] as List;
      }
      addresses.assignAll(list.map((e) => Map<String, dynamic>.from(e as Map)));
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal memuat',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> remove(int id) async {
    try {
      await APIService().delete('/customer-saved-addresses/$id');
      await load();
      CustomSnackbar.show(
        title: 'Dihapus',
        message: 'Alamat berhasil dihapus',
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    }
  }

  Future<void> setDefault(int id) async {
    try {
      await APIService()
          .patch('/customer-saved-addresses/$id/set-default', <String, dynamic>{});
      await load();
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    }
  }

  void openForm({Map<String, dynamic>? address, String? returnRoute}) {
    Get.toNamed(
      Routes.SAVED_ADDRESS_FORM,
      arguments: {
        'address': address,
        'returnRoute': returnRoute,
      },
    )?.then((_) => load());
  }
}
