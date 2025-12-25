import 'package:flutter/material.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBottomSheet.dart';
import 'package:transgomobileapp/app/data/helper/FormatRupiah.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:get/get.dart';

class BottomEstimation extends StatelessWidget {
  final DetailitemsController controller;
  const BottomEstimation({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gabaritoText(
                text: "Total Biaya:",
                textColor: textPrimary,
                fontSize: 18,
              ),
              Obx(() {
                final grandTotal = controller.detailData['grand_total'] ?? 0;
                return gabaritoText(
                  text: "Rp ${formatRupiah(grandTotal)}",
                  textColor: primaryColor,
                  fontSize: 18,
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          ReusableButton(
            height: 50,
            ontap: () {
              if (!controller.isKendaraan &&
                  controller.deskripsiPermintaanKhusus.text.trim().isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message:
                      "Tujuan pemakaian dan permintaan khusus wajib diisi.",
                );
                return;
              }
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const Wrap(
                    children: [
                      RincianOrderModal(),
                    ],
                  );
                },
              );
            },
            bgColor: primaryColor,
            widget: Center(
              child: Obx(() {
                return controller.isLoadingRincian.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const gabaritoText(
                        text: "Lihat Rincian",
                        textColor: Colors.white,
                        fontSize: 16,
                      );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
