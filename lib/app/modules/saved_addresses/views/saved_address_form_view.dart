import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/modules/saved_addresses/controllers/saved_address_form_controller.dart';
import 'package:transgomobileapp/app/widget/address_autocomplete_field.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class SavedAddressFormView extends GetView<SavedAddressFormController> {
  const SavedAddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.editingId.value != null;
    return Scaffold(
      backgroundColor: HexColor('#F6F7F9'),
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah alamat' : 'Tambah alamat'),
        backgroundColor: Colors.white,
        foregroundColor: textHeadline,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gabaritoText(
              text: 'Label',
              fontWeight: FontWeight.w600,
              textColor: textHeadline,
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in controller.chipLabels)
                      ChoiceChip(
                        label: Text(c),
                        selected: controller.selectedChip.value == c,
                        onSelected: (_) {
                          controller.selectedChip.value = c;
                          controller.customLabelC.clear();
                        },
                        selectedColor: primaryColor.withOpacity(0.2),
                      ),
                  ],
                )),
            const SizedBox(height: 12),
            TextField(
              controller: controller.customLabelC,
              decoration: const InputDecoration(
                labelText: 'Label lainnya',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (controller.customLabelC.text.trim().isNotEmpty) {
                  controller.selectedChip.value = null;
                }
              },
            ),
            const SizedBox(height: 24),
            AddressAutocompleteField(
              controller: controller.addressC,
              title: 'Cari lokasi',
              onResolvedCoords: (lat, lng) {
                controller.resolvedLat.value = lat;
                controller.resolvedLng.value = lng;
              },
              onClearCoords: () {
                controller.resolvedLat.value = null;
                controller.resolvedLng.value = null;
              },
            ),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Jadikan alamat utama'),
                  value: controller.isDefault.value,
                  activeThumbColor: primaryColor,
                  onChanged: (v) => controller.isDefault.value = v,
                )),
            const SizedBox(height: 24),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ReusableButton(
                    title: controller.isSaving.value ? 'Menyimpan…' : 'Simpan',
                    bgColor: primaryColor,
                    ontap: controller.isSaving.value ? null : () => controller.save(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
