import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/theme.dart';
import '../../../../data/helper/FormatRupiah.dart';
import '../../controllers/detailitems_controller.dart';
import '../../../../widget/widgets.dart';

class SectionDriverInfo extends StatelessWidget {
  final DetailitemsController controller;

  const SectionDriverInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isWithDriverOnly = controller.detailData['fleet']?['with_driver_only'] == true;
      final isWithDriver = controller.isWithDriver.value || isWithDriverOnly;

      if (!isWithDriver || !controller.isKendaraan) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: gabaritoText(
                    text: "Informasi & Ketentuan Sewa (Dengan Driver)",
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Text("💰", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade800,
                          fontFamily: 'Gabarito',
                        ),
                        children: [
                          const TextSpan(
                            text: "Uang Makan: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "Rp ${formatRupiah(75000)} / hari (Bayar langsung ke driver)",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint("BBM: Sesuai pemakaian atau dihitung Rp 1.600/km (Driver akan foto dashboard Odometer awal & akhir)."),
            _buildBulletPoint("Tol & Parkir: Dibayarkan penyewa sesuai pemakaian."),
            _buildBulletPoint("Overtime: Rp 50.000/jam jika pemakaian melebihi jam 17.00 WIB."),
            _buildBulletPoint("Lokasi: Biaya tambahan luar kota berlaku jika rute perjalanan melebihi 50km dari titik Pool Transgo Jakarta Selatan (Sesuai zona area)."),
            _buildBulletPoint("Akomodasi Inap: Rp 300.000 (Jika rute perjalanan menginap)."),
            _buildBulletPoint("Kelebihan Penumpang: Maks 6 orang (incl. driver) @Rp 50.000/orang. Khusus unit 2 baris maks 4 orang."),
            _buildBulletPoint("Kelebihan Barang: Maks 2 koper. Selebihnya dihitung dimensi (Maks menutupi kaca belakang: Rp 100.000)."),
            _buildBulletPoint("Zona Area: Biaya tambahan berlaku jika memasuki wilayah zona 1 atau 2."),
            
            if (isWithDriverOnly) ...[
              const Divider(height: 24, color: Colors.blue),
              Text(
                "* Armada ini disewa khusus dengan Driver (All-In Unit & Jasa Driver).",
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.blue.shade800,
                height: 1.4,
                fontFamily: 'Gabarito',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
