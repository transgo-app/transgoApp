import 'package:flutter/material.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class IntroSection extends StatelessWidget {
  final DashboardController controller;
  const IntroSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/woman.png', scale: 2),
        gabaritoText(
          text: 'Yuk, Cari Kendaraan yang Cocok!',
          fontSize: 18,
          textColor: textHeadline,
        ),
        gabaritoText(
          text:
              'Pilih lokasi, tanggal, dan durasi sewa dulu ya. Biar kami tampilin sesuai kebutuhan kamu!',
          fontSize: 14,
          textColor: textSecondary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}