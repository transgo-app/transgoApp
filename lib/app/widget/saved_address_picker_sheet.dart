import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/data/service/APIService.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

Future<void> showCustomerSavedAddressPicker(
  BuildContext context, {
  required bool isPengambilan,
  required TextEditingController textController,
}) async {
  final c = Get.find<DetailitemsController>();
  try {
    final raw =
        await APIService().get('/customer-saved-addresses', useCache: false);
    List<dynamic> list = [];
    if (raw is List) {
      list = raw;
    } else if (raw is Map && raw['data'] is List) {
      list = raw['data'] as List;
    }
    if (!context.mounted) return;
    if (list.isEmpty) {
      CustomSnackbar.show(
        title: 'Belum ada alamat',
        message: 'Tambah alamat di Profil → Alamat tersimpan.',
        icon: Icons.location_off,
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pilih alamat tersimpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textHeadline,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Get.toNamed(Routes.SAVED_ADDRESSES);
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text(
                        'TAMBAH BARU',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(foregroundColor: primaryColor),
                    ),
                  ],
                ),
              ),
              // Address list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final item = list[i] as Map<String, dynamic>;
                    final label = item['label']?.toString() ?? '';
                    final addr = item['address']?.toString() ?? '';
                    final def = item['is_default'] == true;
                    return GestureDetector(
                      onTap: () {
                        final lat = double.tryParse(
                            item['latitude']?.toString() ?? '');
                        final lng = double.tryParse(
                            item['longitude']?.toString() ?? '');
                        textController.text = addr;
                        if (lat != null && lng != null) {
                          if (isPengambilan) {
                            c.setStartDeliveryCoords(lat, lng);
                          } else {
                            c.setEndDeliveryCoords(lat, lng);
                          }
                        } else {
                          if (isPengambilan) {
                            c.clearStartDeliveryCoords();
                          } else {
                            c.clearEndDeliveryCoords();
                          }
                        }
                        Navigator.pop(ctx);
                        c.getDetailAPI(false);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _iconForLabel(label),
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (def) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'UTAMA',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    addr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  } catch (e) {
    CustomSnackbar.show(
      title: 'Gagal memuat alamat',
      message: e.toString(),
      icon: Icons.error_outline,
    );
  }
}

IconData _iconForLabel(String label) {
  switch (label.toLowerCase()) {
    case 'rumah':
      return Icons.home_rounded;
    case 'kantor':
      return Icons.work_rounded;
    case 'apartemen':
      return Icons.apartment_rounded;
    default:
      return Icons.location_on_rounded;
  }
}
