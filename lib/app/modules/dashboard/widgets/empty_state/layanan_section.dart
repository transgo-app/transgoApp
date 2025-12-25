import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_helpers.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class LayananSection extends StatelessWidget {
  final DashboardController controller;
  const LayananSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleInfoWidget(title: "Layanan"),
        gabaritoText(
          text: 'Layanan Sewa Lengkap, Siap Temani Perjalananmu',
          fontSize: 20,
          textAlign: TextAlign.center,
          textColor: textHeadline,
        ),
        const SizedBox(height: 10),
        gabaritoText(
          text:
              'Kami menawarkan berbagai layanan sewa mobil & motor di Jakarta yang fleksibel dan nyaman. Semua dirancang buat memenuhi kebutuhan perjalanan kamu, kapan pun dan ke mana pun tujuannya.',
          textColor: textSecondary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Column(
          children: controller.cardDataLayanan.map((data) {
            return cardInformationDashboard(
              imagePath: data['imagePath']!,
              scale: 3.0,
              title: data['title']!,
              subtitle: data['subtitle']!,
            );
          }).toList(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: gabaritoText(
                text:
                    'Transgo nggak cuma soal sewa mobil dan motor di Jakarta, lho — masih banyak layanan seru lainnya yang bisa kamu pakai!',
                textColor: textHeadline,
                fontSize: 16,
              )),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: controller.scrollLeft,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: HexColor('#FAFAFA'),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(IconsaxPlusBold.arrow_left_1),
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: controller.scrollRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: HexColor('#FAFAFA'),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(IconsaxPlusBold.arrow_right),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller.scrollControllerLayanan,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < controller.cardDataLayananLainnya.length; i++)
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: cardInformationDashboard(
                          imagePath: controller.cardDataLayananLainnya[i]['imagePath']!,
                          scale: 4.0,
                          title: controller.cardDataLayananLainnya[i]['title']!,
                          subtitle: controller.cardDataLayananLainnya[i]['subtitle']!,
                          width: 300,
                          height: 300)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}