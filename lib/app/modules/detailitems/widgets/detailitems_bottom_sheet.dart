import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
import '../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/modules/detailitems/views/detailformsewa.dart';

class DetailitemsBottomSheet extends StatelessWidget {
  final DetailitemsController controller;

  const DetailitemsBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final double rentPrice =
        (controller.detailData['rent_price'] ?? 0).toDouble();
    final double discount =
        (controller.detailData['discount_percentage'] ?? 0).toDouble();
    final double finalPrice = rentPrice - (rentPrice * discount / 100);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gabaritoText(
              text: "Harga Mulai",
              fontSize: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: gabaritoText(
                text:
                    "Rp ${NumberFormat.decimalPattern('id').format(finalPrice)} / Hari",
                fontSize: 16,
                textColor: primaryColor,
              ),
            ),
            if (discount > 0)
              Text(
                "Rp ${formatRupiah(rentPrice)}",
                style: gabaritoTextStyle.copyWith(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 0.8,
                  color: textSecondary,
                ),
              ),

            const SizedBox(height: 10),
            ReusableButton(
              height: 50,
              ontap: () {
                Get.to(DetailFormSewa());
              },
              bgColor: solidPrimary,
              title: "Lanjut Ke Form Sewa",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
