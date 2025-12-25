import 'package:flutter/material.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class ClientSection extends StatelessWidget {
  const ClientSection({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 54),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          gabaritoText(
              text: 'Klien yang Udah Bareng Kami',
              fontSize: 20,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          gabaritoText(
            text:
                'Transgo dipercaya berbagai perusahaan dan brand untuk kebutuhan sewa kendaraan',
            textColor: textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  'assets/dashboard/client_${index + 1}.png',
                  height: 32,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primary.withOpacity(0.6)),
            ),
            child: gabaritoText(
              text: '+10.000 Lainnya',
              textColor: textPrimary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
