import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/data/globalvariables.dart';
import 'package:transgomobileapp/app/data/service/APIService.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class SavedAddressFormController extends GetxController {
  final addressC = TextEditingController();
  final customLabelC = TextEditingController();
  final isDefault = false.obs;
  final isSaving = false.obs;

  Rxn<int> editingId = Rxn<int>();
  String? returnRoute;

  final Rxn<double> resolvedLat = Rxn<double>();
  final Rxn<double> resolvedLng = Rxn<double>();

  final chipLabels = ['Rumah', 'Kantor', 'Apartemen'];
  final selectedChip = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      returnRoute = args['returnRoute'] as String?;
      final ed = args['address'];
      if (ed is Map<String, dynamic>) {
        editingId.value = int.tryParse(ed['id']?.toString() ?? '');
        final lbl = ed['label']?.toString() ?? '';
        if (chipLabels.contains(lbl)) {
          selectedChip.value = lbl;
        } else if (lbl.isNotEmpty) {
          customLabelC.text = lbl;
        }
        addressC.text = ed['address']?.toString() ?? '';
        resolvedLat.value = double.tryParse(ed['latitude']?.toString() ?? '');
        resolvedLng.value = double.tryParse(ed['longitude']?.toString() ?? '');
        isDefault.value = ed['is_default'] == true;
      }
    }
  }

  @override
  void onClose() {
    addressC.dispose();
    customLabelC.dispose();
    super.onClose();
  }

  String _effectiveLabel() {
    if (customLabelC.text.trim().isNotEmpty) {
      return customLabelC.text.trim();
    }
    return selectedChip.value ?? '';
  }

  Future<void> save() async {
    final label = _effectiveLabel();
    if (label.isEmpty) {
      CustomSnackbar.show(
        title: 'Label kosong',
        message: 'Pilih atau isi label alamat.',
        icon: Icons.label_outline,
      );
      return;
    }
    final addr = addressC.text.trim();
    if (addr.isEmpty) {
      CustomSnackbar.show(
        title: 'Alamat kosong',
        message: 'Isi alamat lengkap.',
        icon: Icons.location_off,
      );
      return;
    }
    final lat = resolvedLat.value;
    final lng = resolvedLng.value;
    if (lat == null || lng == null) {
      CustomSnackbar.show(
        title: 'Koordinat belum ada',
        message: 'Pilih salah satu saran alamat dari pencarian.',
        icon: Icons.map_outlined,
      );
      return;
    }

    final name = GlobalVariables.namaUser.value.trim();
    final phone = GlobalVariables.nomorTelepon.value.trim();
    if (name.isEmpty || phone.isEmpty) {
      CustomSnackbar.show(
        title: 'Data profil belum lengkap',
        message: 'Lengkapi nama dan nomor telepon di Data Pribadi terlebih dahulu.',
        icon: Icons.person_outline,
      );
      return;
    }

    final body = <String, dynamic>{
      'label': label,
      'recipient_name': name,
      'recipient_phone': phone,
      'address': addr,
      'latitude': lat,
      'longitude': lng,
      'is_default': isDefault.value,
    };

    isSaving.value = true;
    try {
      final id = editingId.value;
      if (id != null) {
        await APIService().patch('/customer-saved-addresses/$id', body);
      } else {
        await APIService().post('/customer-saved-addresses', body);
      }
      Get.offNamed(Routes.SAVED_ADDRESSES);
      CustomSnackbar.show(
        title: 'Berhasil',
        message: editingId.value != null
            ? 'Alamat berhasil diperbarui'
            : 'Alamat berhasil disimpan',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
