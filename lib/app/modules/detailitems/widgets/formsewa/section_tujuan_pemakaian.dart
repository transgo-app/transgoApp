import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';

/// Backend enum: recreation | business | family | everyday
const List<Map<String, dynamic>> _tujuanPemakaianOptions = [
  {
    'value': 'recreation',
    'label': 'Wisata & Rekreasi',
    'description': 'Liburan keluarga, city tour, atau mengunjungi tempat wisata.',
    'icon': IconsaxPlusBold.heart,
  },
  {
    'value': 'business',
    'label': 'Keperluan Bisnis/Dinas',
    'description': 'Menghadiri rapat, kunjungan kerja, atau proyek kantor.',
    'icon': IconsaxPlusBold.briefcase,
  },
  {
    'value': 'family',
    'label': 'Acara Keluarga',
    'description': 'Pernikahan (kondangan), menjenguk kerabat, atau acara duka.',
    'icon': IconsaxPlusBold.people,
  },
  {
    'value': 'everyday',
    'label': 'Transportasi Harian',
    'description':
        'Pengganti kendaraan pribadi yang sedang rusak atau sekolah/kuliah.',
    'icon': IconsaxPlusBold.clock,
  },
];

class SectionTujuanPemakaian extends StatelessWidget {
  final DetailitemsController controller;
  const SectionTujuanPemakaian({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    if (!controller.isKendaraan) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
        gabaritoText(text: "Tujuan Pemakaian"),
        gabaritoText(
          text:
              "Pilih tujuan penggunaan kendaraan Anda (opsional). Informasi ini membantu kami memberikan layanan terbaik sesuai kebutuhan Anda.",
          fontSize: 13,
          textColor: textPrimary,
        ),
        const SizedBox(height: 12),
        Obx(() {
          final selected = controller.selectedIntendedUse.value;
          return Column(
            children: _tujuanPemakaianOptions.map((option) {
              final value = option['value'] as String;
              final label = option['label'] as String;
              final description = option['description'] as String;
              final icon = option['icon'] as IconData;
              final isSelected = selected == value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.selectedIntendedUse.value =
                          isSelected ? '' : value;
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? primaryColor.withOpacity(0.06)
                            : Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              icon,
                              size: 22,
                              color: isSelected
                                  ? Colors.white
                                  : textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gabaritoText(
                                  text: label,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  textColor:
                                      isSelected ? primaryColor : textHeadline,
                                ),
                                const SizedBox(height: 4),
                                gabaritoText(
                                  text: description,
                                  fontSize: 12,
                                  textColor: textSecondary,
                                  Maxlines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
