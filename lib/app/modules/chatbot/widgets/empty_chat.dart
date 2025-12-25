import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotEmptyView extends GetView<ChatbotController> {
  const ChatbotEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Halo Customer TG 👋\nAda yang bisa saya bantu hari ini?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Saya siap membantu Anda dengan informasi rental mobil dan motor TransGo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickAction(
                icon: IconsaxPlusBold.car,
                label: 'Cek\nKetersediaan',
                color: Colors.blue,
                message: 'Saya ingin cek ketersediaan kendaraan',
              ),
              _quickAction(
                icon: IconsaxPlusBold.money,
                label: 'Cek\nHarga',
                color: Colors.green,
                message: 'Saya ingin mengetahui harga sewa kendaraan',
              ),
              _quickAction(
                icon: IconsaxPlusBold.location,
                label: 'Lokasi\nPickup',
                color: Colors.orange,
                message: 'Di mana lokasi pickup TransGo?',
              ),
              _quickAction(
                icon: IconsaxPlusBold.message_question,
                label: 'FAQ &\nTips',
                color: Colors.purple,
                message: 'Saya ingin melihat FAQ dan tips rental',
              ),
            ],
          ),
          const SizedBox(height: 28),
          _dailyCard(),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required String message,
  }) {
    return GestureDetector(
      onTap: () {
        controller.sendTemplate(message);
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _dailyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'TransGo Daily',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          _DailyItem(
            title: 'Menguak Rahasia Kecepatan Maksimal...',
            subtitle: 'Siapa yang tidak terpesona dengan mobil...',
          ),
          SizedBox(height: 12),
          _DailyItem(
            title: 'Menguak Rahasia Perjalanan Tanpa...',
            subtitle: 'Temukan bagaimana Transgo...',
          ),
        ],
      ),
    );
  }
}

class _DailyItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DailyItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
