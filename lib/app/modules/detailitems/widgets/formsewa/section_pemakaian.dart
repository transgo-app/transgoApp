import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';

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
                      controller.getDetailAPI();
                    },
                  ))
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gabaritoText(
                text: "Luar Kota",
                textColor: textHeadline,
              ),
              Obx(() => Radio(
                    value: "Luar Kota",
                    groupValue: controller.selectedPemakaian.value,
                    activeColor: primaryColor,
                    onChanged: (value) async {
                      controller.pemakaianLuarKota.value = true;
                      controller.selectedPemakaian.value = value!;
                      await controller.getOutOfTownRates();
                    },
                  ))
            ],
          ),
          Obx(() {
            if (!controller.pemakaianLuarKota.value) return SizedBox();

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
                const SizedBox(height: 12),
                gabaritoText(
                  text: "Pilih Wilayah Luar Kota:",
                  textColor: textHeadline,
                  fontSize: 14,
                ),
                const SizedBox(height: 10),
                ...controller.outOfTownRates.map((region) {
                  final bool isSelected =
                      controller.selectedRegion['region_name'] ==
                          region['region_name'];
                  final bool isCar =
                      controller.detailData['item']?['type_code'] == 'car';
                  final int selectedRate = isCar
                      ? region['daily_rate']
                      : region['motorcycle_daily_rate'];

                  return GestureDetector(
                    onTap: () {
                      controller.selectedRegion.value = region;
                      controller.selectedRegionId.value = region['id'];
                      controller.selectedRegionName.value =
                          region['region_name'];
                      controller.selectedRegionQuantity.value = 1;
                      controller.getDetailAPI();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? primaryColor : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? primaryColor.withOpacity(0.05)
                            : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(
                            text: region["region_name"],
                            textColor: textHeadline,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 6),
                          gabaritoText(
                            text: region["description"] ?? "",
                            textColor: Colors.grey,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                gabaritoText(
                                  text: "Rp$selectedRate / hari",
                                  textColor: solidPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        color: primaryColor,
                                        onPressed: () {
                                          if (controller.selectedRegionQuantity
                                                  .value >
                                              1) {
                                            controller
                                                .selectedRegionQuantity.value--;
                                            controller.getDetailAPI();
                                          }
                                        },
                                      ),
                                      Obx(() => gabaritoText(
                                            text: controller
                                                .selectedRegionQuantity.value
                                                .toString(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            textColor: textHeadline,
                                          )),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        color: primaryColor,
                                        onPressed: () {
                                          if (controller.selectedRegionQuantity
                                                  .value <
                                              controller.selectedDurasi.value) {
                                            controller
                                                .selectedRegionQuantity.value++;
                                            controller.getDetailAPI();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }),
          Obx(() {
            if (controller.selectedRegion.isEmpty) return const SizedBox();
            final bool isCar =
                controller.detailData['item']?['type_code'] == 'car';
            final int selectedRate = isCar
                ? controller.selectedRegion['daily_rate']
                : controller.selectedRegion['motorcycle_daily_rate'];

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: gabaritoText(
                text: "Tarif Luar Kota Dipilih: Rp$selectedRate / hari",
                textColor: solidPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
        ],
      ),
    );
  }
}
