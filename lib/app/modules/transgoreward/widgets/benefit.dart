import 'package:flutter/material.dart';
import '../controllers/transgoreward_controller.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class BenefitCard extends StatelessWidget {
  final Benefit benefit;
  final Color primaryColor;

  const BenefitCard({
    super.key,
    required this.benefit,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> benefitTitleMap = {
      'free_delivery_10km': 'Gratis Antar 10 KM',
      'free_pickup_10km': 'Gratis Jemput 10 KM',
      'free_driver': 'Gratis Driver',
      'free_addon': 'Gratis Addon',
    };

    final Map<String, IconData> benefitIconMap = {
      'free_delivery_10km': Icons.local_shipping,
      'free_pickup_10km': Icons.shopping_bag,
      'free_driver': Icons.person,
      'free_addon': Icons.add_box,
    };

    final icon =
        benefitIconMap[benefit.benefitType] ?? Icons.card_giftcard;
    final title =
        benefitTitleMap[benefit.benefitType] ?? benefit.benefitType;
    final expireDate =
        "${benefit.expiresAt.day} ${_monthName(benefit.expiresAt.month)} ${benefit.expiresAt.year}";

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 36,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: gabaritoText(
                          text: title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      gabaritoText(
                        text: "${benefit.remainingCount} x",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  gabaritoText(
                    text: "Berlaku sampai $expireDate",
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month];
  }
}
