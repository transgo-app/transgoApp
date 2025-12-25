import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class DriverOption extends StatelessWidget {
  final DetailitemsController controller;

  const DriverOption({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
        gabaritoText(
          text: "Pilihan Supir",
        ),
        const SizedBox(height: 4),
        gabaritoText(
          text: "Pilih apakah ingin menggunakan supir atau tidak",
          fontSize: 13,
          textColor: textPrimary,
        ),
        const SizedBox(height: 10),
        Obx(
          () => BackgroundCard(
            borderRadius: 10,
            marginVertical: 14,
            paddingHorizontal: 16,
            paddingVertical: 0,
            body: Column(
              children: [
                // Tanpa Supir
                GestureDetector(
                  onTap: () {
                    controller.isWithDriver.value = false;
                    controller.getDetailAPI();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gabaritoText(
                          text: "Tanpa Supir",
                          textColor: controller.isWithDriver.value ? textPrimary : solidPrimary,
                          fontSize: 14,
                        ),
                        Radio<bool>(
                          value: false,
                          groupValue: controller.isWithDriver.value,
                          activeColor: solidPrimary,
                          onChanged: (value) {
                            controller.isWithDriver.value = value!;
                            controller.getDetailAPI();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(height: 1, color: Colors.grey.shade300),

                // Dengan Supir
                GestureDetector(
                  onTap: () {
                    controller.isWithDriver.value = true;
                    controller.getDetailAPI();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gabaritoText(
                          text: "Dengan Supir",
                          textColor: controller.isWithDriver.value ? solidPrimary : textPrimary,
                          fontSize: 14,
                        ),
                        Radio<bool>(
                          value: true,
                          groupValue: controller.isWithDriver.value,
                          activeColor: solidPrimary,
                          onChanged: (value) {
                            controller.isWithDriver.value = value!;
                            controller.getDetailAPI();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
