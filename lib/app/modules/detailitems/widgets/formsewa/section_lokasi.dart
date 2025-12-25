import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalPengambilanPengembalian.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class SectionLokasi extends StatelessWidget {
  final DetailitemsController controller;
  const SectionLokasi({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.detailData;
    final isKendaraan = controller.isKendaraan;

    final lokasiAsal = item["location"] ?? "-";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: "Lokasi Pengambilan"),
        gabaritoText(
          text: isKendaraan
              ? "Pilih lokasi kendaraan bakal kamu ambil di hari pertama sewa, ya!"
              : "Pilih lokasi produk akan kamu ambil di hari pertama sewa, ya!",
          fontSize: 13,
          textColor: textPrimary,
        ),
        BackgroundCard(
          ontap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        ModalPengambilanPengembalianKendaraan(
                          labelTitle: "Pilih Lokasi Pengambilan",
                          tempatAsal: lokasiAsal,
                          controllerView: controller.lokasiPengambilanC,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: 8,
          height: 50,
          marginVertical: 10,
          paddingHorizontal: 10,
          paddingVertical: 10,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Expanded(
                      child: gabaritoText(
                    text: controller.getLocationPengambilanText(
                        controller.detailLokasiPengambilan.value),
                    textColor: solidPrimary,
                    Maxlines: 2,
                    overflow: TextOverflow.ellipsis,
                  ))),
              SizedBox(width: 10),
              Icon(IconsaxPlusBold.arrow_square_right, color: solidPrimary)
            ],
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
        gabaritoText(text: "Lokasi Pengembalian"),
        gabaritoText(
          text: isKendaraan
              ? "Lokasi pengembalian otomatis mengikuti lokasi pengambilan."
              : "Lokasi pengembalian otomatis mengikuti lokasi pengambilan.",
          fontSize: 13,
          textColor: textPrimary,
        ),
        BackgroundCard(
          borderRadius: 8,
          height: 50,
          marginVertical: 10,
          paddingHorizontal: 10,
          paddingVertical: 10,
          body: Obx(() {
            if (!controller.isPengembalianManual.value) {
              controller.selectedPengembalian.value =
                  controller.selectedPengambilan.value;
              controller.detailLokasiPengembalian.value =
                  controller.detailLokasiPengambilan.value;
              controller.lokasiPengembalianC.text =
                  controller.lokasiPengambilanC.text;
              controller.pengembalianSendiri.value =
                  controller.pengambilanSendiri.value;
            }

            return GestureDetector(
              onTap: () {
                controller.isPengembalianManual.value = true;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: [
                            ModalPengambilanPengembalianKendaraan(
                              isPengambilan: false,
                              labelTitle: "Pilih Lokasi Pengembalian",
                              tempatAsal: lokasiAsal,
                              controllerView: controller.lokasiPengembalianC,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: gabaritoText(
                        text: controller.getLocationPengembalianText(
                            controller.detailLokasiPengembalian.value),
                        textColor: solidPrimary,
                        Maxlines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(IconsaxPlusBold.arrow_square_right,
                        color: solidPrimary),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
