import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/modules/saved_addresses/controllers/saved_addresses_controller.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class SavedAddressesListView extends GetView<SavedAddressesController> {
  const SavedAddressesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F6F7F9'),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              IconsaxPlusBold.arrow_left_1,
              size: 33,
            ),
          ),
        ),
        title: const Text('Alamat tersimpan'),
        backgroundColor: Colors.white,
        foregroundColor: textHeadline,
        elevation: 0,
      ),
      floatingActionButton: Obx(() {
        if (controller.addresses.length >= 5) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () => controller.openForm(),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.addresses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gabaritoText(
                    text: 'Belum ada alamat tersimpan',
                    fontSize: 16,
                    textColor: textSecondary,
                  ),
                  const SizedBox(height: 16),
                  ReusableButton(
                    height: 48,
                    title: 'Tambah alamat',
                    bgColor: primaryColor,
                    ontap: () => controller.openForm(),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (_, i) {
            final a = controller.addresses[i];
            final id = int.tryParse(a['id']?.toString() ?? '') ?? 0;
            final def = a['is_default'] == true;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: gabaritoText(
                        text: a['label']?.toString() ?? '',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (def)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Utama',
                          style: TextStyle(fontSize: 10, color: primaryColor),
                        ),
                      ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: gabaritoText(
                    text: a['address']?.toString() ?? '',
                    fontSize: 12,
                    textColor: textSecondary,
                    Maxlines: 3,
                  ),
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') {
                      controller.openForm(address: a);
                    } else if (v == 'default') {
                      controller.setDefault(id);
                    } else if (v == 'delete') {
                      controller.remove(id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit', child: Text('Ubah')),
                    if (!def)
                      const PopupMenuItem(
                          value: 'default', child: Text('Jadikan utama')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('Hapus')),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
