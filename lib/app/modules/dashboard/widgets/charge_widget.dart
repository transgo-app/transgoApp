import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../controllers/dashboard_controller.dart';

class ChargeWidget extends StatelessWidget {
  final DashboardController controller;

  const ChargeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showDataMobil.value) {
        return const SizedBox.shrink();
      }

      final alert = controller.currentChargeAlert.value;
      if (alert == null) {
        return const SizedBox.shrink();
      }

      final alertType = alert['type'] as String?;
      
      if (alertType == 'd1') {
        return _buildD1Alert(alert);
      } else if (alertType == 'dday') {
        return _buildDDayAlert(alert);
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildD1Alert(Map<String, dynamic> alert) {
    final name = alert['name'] ?? '';
    final fleets = alert['fleets'] ?? '';
    final chargePercent = alert['chargePercent'] ?? 30;
    final timeRange = alert['timeRange'] ?? 'pukul 12.00-18.00 WIB';

    final message = 
        'Pemesanan satu hari sebelum hari $name berlaku untuk penyewaan 1 hari pada $fleets akan dikenakan biaya tambahan sebesar $chargePercent% untuk pemesanan pada $timeRange.';

    return Transform.translate(
      offset: const Offset(0, -70),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade300, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: poppinsText(
                text: message,
                fontSize: 13,
                textColor: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDDayAlert(Map<String, dynamic> alert) {
    final name = alert['name'] ?? '';
    final formattedStartDate = alert['formatted_start_date'] ?? '';
    final formattedEndDate = alert['formatted_end_date'] ?? '';
    final fleets = alert['fleets'] ?? '';

    final message = 
        'Kami informasikan bahwa pada periode $formattedStartDate sampai $formattedEndDate yang bertepatan dengan hari $name, sistem penyewaan diubah menjadi per tanggal (harian). Berlaku untuk Pemesanan $fleets.\n\nContoh: Penyewaan tanggal 1–3 akan dihitung sebagai 3 hari. Perhitungan Waktu dari Pukul 00.00 WIB - 23.59 WIB';

    return Transform.translate(
      offset: const Offset(0, -70),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade300, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: poppinsText(
                text: message,
                fontSize: 13,
                textColor: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
