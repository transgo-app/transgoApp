import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/data/helper/FormatRupiah.dart';

class SectionPemakaian extends StatelessWidget {
  final DetailitemsController controller;
  const SectionPemakaian({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      borderRadius: 10,
      marginVertical: 14,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gabaritoText(
                text: "Dalam Kota",
                textColor: solidPrimary,
              ),
              Obx(() => Radio(
                    value: "Dalam Kota",
                    groupValue: controller.selectedPemakaian.value,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      controller.pemakaianLuarKota.value = false;
                      controller.selectedPemakaian.value = value!;
                      controller.selectedRegion.value = {};
                      controller.selectedRegionId.value = 0;
                      controller.selectedRegionName.value = "";
                      controller.getDetailAPI();
                    },
                  ))
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(
                    text: "Luar Kota",
                    textColor: textHeadline,
                  ),
                  // Price alert when region is selected
                  Obx(() {
                    if (controller.selectedRegion.isEmpty || 
                        controller.selectedRegionId.value == 0) {
                      return const SizedBox.shrink();
                    }
                    final bool isCar =
                        controller.detailData['item']?['type_code'] == 'car';
                    final int selectedRate = isCar
                        ? controller.selectedRegion['daily_rate']
                        : controller.selectedRegion['motorcycle_daily_rate'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: gabaritoText(
                        text: '+ Rp ${formatRupiah(selectedRate)} / Hari',
                        textColor: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ],
              ),
              Obx(() => Radio(
                    value: "Luar Kota",
                    groupValue: controller.selectedPemakaian.value,
                    activeColor: primaryColor,
                    onChanged: (value) async {
                      controller.pemakaianLuarKota.value = true;
                      controller.selectedPemakaian.value = value!;
                      await controller.getOutOfTownRates();
                      // Set default jumlah hari to full rental duration
                      controller.selectedRegionQuantity.value = controller.selectedDurasi.value;
                    },
                  ))
            ],
          ),
          Obx(() {
            if (!controller.pemakaianLuarKota.value) return const SizedBox();

            if (controller.outOfTownRates.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 8),
                child: gabaritoText(
                  text: "Tidak ada data wilayah luar kota.",
                  textColor: Colors.red,
                  fontSize: 13,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Pilih Daerah Tujuan section
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.pink,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    gabaritoText(
                      text: "Pilih Daerah Tujuan",
                      textColor: textHeadline,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                gabaritoText(
                  text: "Pilih daerah tujuan untuk melihat tarif tambahan yang akan dikenakan",
                  textColor: textSecondary,
                  fontSize: 13,
                ),
                const SizedBox(height: 12),
                // Region dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(() {
                      // Use region ID as the value instead of the map object
                      final selectedRegionId = controller.selectedRegionId.value == 0
                          ? null
                          : controller.selectedRegionId.value;
                      
                      return DropdownButton<int>(
                        isExpanded: true,
                        isDense: false,
                        value: selectedRegionId,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        hint: gabaritoText(
                          text: "Pilih daerah tujuan...",
                          textColor: textSecondary,
                          fontSize: 14,
                        ),
                        icon: Icon(
                          IconsaxPlusBold.arrow_circle_down,
                          color: Colors.grey,
                          size: 20,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        menuMaxHeight: 400,
                        items: controller.outOfTownRates.map((region) {
                          return DropdownMenuItem<int>(
                            value: region['id'],
                            child: OverflowBox(
                              maxHeight: 220,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    gabaritoText(
                                      text: region["region_name"],
                                      textColor: textHeadline,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    if (region["description"] != null && 
                                        region["description"].toString().isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      gabaritoText(
                                        text: region["description"],
                                        textColor: textSecondary,
                                        fontSize: 12,
                                        Maxlines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newRegionId) {
                          if (newRegionId != null) {
                            // Find the region by ID
                            final region = controller.outOfTownRates.firstWhere(
                              (r) => r['id'] == newRegionId,
                            );
                            controller.selectedRegion.value = Map<String, dynamic>.from(region);
                            controller.selectedRegionId.value = newRegionId;
                            controller.selectedRegionName.value = region['region_name'];
                            // Set default jumlah hari to full rental duration when region is selected
                            controller.selectedRegionQuantity.value = controller.selectedDurasi.value;
                            controller.getDetailAPI();
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          // selectedItemBuilder must return a list with the same length as items
                          return controller.outOfTownRates.map((region) {
                            final isSelected = region['id'] == selectedRegionId;
                            
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  if (isSelected) ...[
                                    Icon(
                                      Icons.check_circle,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        gabaritoText(
                                          text: region["region_name"],
                                          textColor: textHeadline,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        if (region["description"] != null && 
                                            region["description"].toString().isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          gabaritoText(
                                            text: region["description"],
                                            textColor: textSecondary,
                                            fontSize: 12,
                                            Maxlines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // Jumlah Hari yang Dikenakan Charge section
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    gabaritoText(
                      text: "Jumlah Hari yang Dikenakan Charge",
                      textColor: textHeadline,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                gabaritoText(
                  text: "Pilih jumlah hari yang akan dikenakan biaya tambahan luar kota",
                  textColor: textSecondary,
                  fontSize: 13,
                ),
                const SizedBox(height: 12),
                // Jumlah hari dropdown
                Obx(() {
                  final rentalDuration = controller.selectedDurasi.value;
                  
                  if (rentalDuration <= 0) {
                    return const SizedBox.shrink();
                  }
                  
                  final List<int> dayOptions = List.generate(
                    rentalDuration,
                    (index) => index + 1,
                  );
                  
                  // Ensure selectedRegionQuantity is within valid range
                  final currentValue = controller.selectedRegionQuantity.value;
                  final validValue = (currentValue > 0 && currentValue <= rentalDuration)
                      ? currentValue
                      : rentalDuration;
                  
                  // Ensure value is always in the items list
                  final dropdownValue = dayOptions.contains(validValue) 
                      ? validValue 
                      : dayOptions.isNotEmpty 
                          ? dayOptions.first 
                          : null;
                  
                  // Update if needed (but avoid infinite loop)
                  if (currentValue != validValue && validValue > 0) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (controller.selectedRegionQuantity.value != validValue) {
                        controller.selectedRegionQuantity.value = validValue;
                      }
                    });
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: dropdownValue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        icon: Icon(
                          IconsaxPlusBold.arrow_circle_down,
                          color: Colors.grey,
                          size: 20,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        menuMaxHeight: 300,
                        items: dayOptions.map((days) {
                          return DropdownMenuItem<int>(
                            value: days,
                            child: gabaritoText(
                              text: "$days hari",
                              textColor: textHeadline,
                              fontSize: 14,
                            ),
                          );
                        }).toList(),
                        onChanged: controller.selectedRegionId.value == 0
                            ? null
                            : (int? newValue) {
                                if (newValue != null) {
                                  controller.selectedRegionQuantity.value = newValue;
                                  controller.getDetailAPI();
                                }
                              },
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
