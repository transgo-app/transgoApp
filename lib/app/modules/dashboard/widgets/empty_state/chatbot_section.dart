import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class HelpAISection extends StatelessWidget {
  const HelpAISection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 54),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/dashboard/chatbot.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Nggak nemu jawabannya di sini?',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          gabaritoText(
            text: 'Tenang, Gogo AI siap bantu kamu eksplor lebih dalam!',
            textColor: textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: primaryColor,
                elevation: 0,
              ),
              onPressed: () {
                Get.toNamed('/chatbot');
              },
              child: gabaritoText(
                text: 'Chat dengan Gogo AI',
                textColor: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          gabaritoText(
            text: 'Dapatkan jawaban instan 24/7 dengan AI canggih',
            fontSize: 12,
            textColor: textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
