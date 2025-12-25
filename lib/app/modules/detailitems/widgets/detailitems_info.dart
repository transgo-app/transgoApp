import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../widget/widgets.dart';
import '../controllers/detailitems_controller.dart';

class DetailitemsInfo extends StatelessWidget {
  final DetailitemsController controller;

  const DetailitemsInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = controller.detailData;

    if (data.isEmpty) {
      return const Text("Tidak ada data.");
    }

    return _buildUnifiedInfo(data);
  }
  Widget _buildUnifiedInfo(Map data) {
    final item = data['item'] ?? {};
    final title = item['name'] ?? '-';
    final location = item['location'] ?? '-';
    final typeLabel = item['category'] ?? item['type'] ?? '-';
    final raw = item['raw'] ?? {};
    final color = raw['color'] ?? item['color'] ?? '-';
    final plateOrModel = raw['plate_number'] ?? raw['model'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        poppinsText(
          text: title,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 6),
        Row(
          children: [
            Icon(IconsaxPlusBold.location, size: 18, color: Colors.blue),
            const SizedBox(width: 6),
            Expanded(
              child: poppinsText(
                text: location,
                fontSize: 13,
                textColor: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(IconsaxPlusBold.category,
                        size: 24, color: Colors.blue.shade700),
                    const SizedBox(height: 4),
                    poppinsText(
                      text: typeLabel,
                      fontSize: 12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              _divider(),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.color_lens,
                        size: 24, color: Colors.blue.shade700),
                    const SizedBox(height: 4),
                    poppinsText(
                      text: color,
                      fontSize: 12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              _divider(),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.confirmation_number,
                        size: 24, color: Colors.blue.shade700),
                    const SizedBox(height: 4),
                    poppinsText(
                      text: plateOrModel,
                      fontSize: 12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        const Divider(),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 35,
      width: 1,
      color: Colors.blue.shade300,
    );
  }
}
