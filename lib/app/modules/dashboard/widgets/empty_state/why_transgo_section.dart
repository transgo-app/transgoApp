import 'package:flutter/material.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_helpers.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class WhyTransgoSection extends StatelessWidget {
  final DashboardController controller;
  const WhyTransgoSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 8), child: titleInfoWidget(title: 'Why Transgo')),
        Align(
            alignment: Alignment.centerLeft,
            child: gabaritoText(
              text: 'Kenapa Harus Transgo Buat Sewa Kendaraan?',
              fontSize: 20,
              textColor: textHeadline,
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: gabaritoText(
              text:
                  'Kami hadir dengan layanan sewa mobil dan motor di Jakarta yang cepat, mudah, dan pastinya terpercaya. Armada kami selalu terawat, harga transparan, dan pelayanannya profesional. Transgo siap nemenin perjalanan kamu—buat kerja, liburan, atau keperluan harian',
              textColor: textSecondary,
            )),
        expansionTileDashboard(
            title: 'Bisa Sewa Kapan Aja',
            subtitle:
                'Layanan sewa mobil dan motor Transgo tersedia 24 jam. Fleksibel banget buat kamu yang punya jadwal padat atau mendadak butuh kendaraan.'),
        expansionTileDashboard(
            title: 'Tanpa DP atau Deposit',
            subtitle:
                'Sewa jadi lebih simpel tanpa perlu bayar uang muka. Tinggal pilih kendaraan, isi data, dan kamu siap jalan tanpa ribet.'),
        expansionTileDashboard(
            title: 'Unit Terlindungi & Gak Perlu Survey',
            subtitle:
                'Mulai dari Rp15.000, kendaraan kamu udah terlindungi asuransi. Gak perlu repot disurvei, cukup isi data, dan kami urus sisanya.'),
        expansionTileDashboard(
            title: 'Harga Mulai dari 40K per Hari',
            subtitle:
                'Motor bisa kamu sewa mulai dari Rp40.000/hari dan mobil dari Rp200.000/hari. Harganya transparan, tanpa biaya tambahan tersembunyi.'),
        Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Image.asset('assets/totaluser.png', scale: 3)),
      ],
    );
  }
}