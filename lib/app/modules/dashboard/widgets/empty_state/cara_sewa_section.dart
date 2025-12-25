import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_helpers.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class CaraSewaSection extends StatelessWidget {
  final DashboardController controller;
  const CaraSewaSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleInfoWidget(title: "Cara Sewa"),
        gabaritoText(
          text: 'Gak Ribet, Begini Langkah Sewa di Transgo',
          fontSize: 20,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        infoCaraSewa(
            "Pesan Kendaraan Sesuai Kebutuhanmu",
            'Mulai dari website atau aplikasi, pilih unit kendaraan, lokasi penjemputan, dan tanggal sewa yang kamu inginkan. Gampang dan fleksibel, tinggal klik!',
            IconsaxPlusBold.global_search),
        infoCaraSewa(
            'Pesanan Diproses, Tunggu Sebentar ya!',
            'Setelah kamu memesan, tim Transgo akan memprosesnya. Kamu bakal dapat notifikasi lewat email atau WhatsApp soal status pesananmu. Tenang, kami gercep kok!',
            IconsaxPlusBold.timer),
        infoCaraSewa(
            'Saatnya Bayar dengan Mudah',
            'Kalau pesanan kamu sudah diverifikasi, invoice akan langsung dikirim lewat sistem paper.id. Kamu bisa bayar langsung di tempat sesuai panduan yang kami kirimkan.',
            IconsaxPlusBold.money_time,
            withLine: false),
        const SizedBox(height: 20),
      ],
    );
  }
}