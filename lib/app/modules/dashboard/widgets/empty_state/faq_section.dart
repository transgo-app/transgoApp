import 'package:flutter/material.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_helpers.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class FAQSection extends StatelessWidget {
  final DashboardController controller;
  const FAQSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), child: Column(children: [
      titleInfoWidget(title: 'FAQ'),
      gabaritoText(text: 'Pertanyaan yang Sering Ditanyakan', fontSize: 25, textAlign: TextAlign.center),
      const SizedBox(height: 10),
      gabaritoText(text: 'Temukan jawaban dari pertanyaan-pertanyaan yang sering ditanyain sama pengguna Transgo. Siapa tahu kamu juga lagi nyari info yang sama', textColor: textSecondary, textAlign: TextAlign.center),
      const SizedBox(height: 10),
      for (var i = 0; i < controller.faqContent.length; i++) expansionTileDashboard(title: controller.faqContent[i]['title'] ?? '', subtitle: controller.faqContent[i]['subtitle'] ?? ''),
      const SizedBox(height: 20),
      gabaritoText(text: 'Diliput di Berbagai Media', fontSize: 25),
      const SizedBox(height: 10),
      gabaritoText(text: 'Transgo udah dipercaya banyak pengguna, dan juga pernah diliput oleh beberapa media keren berikut. Yuk, intip siapa aja yang udah bahas layanan sewa mobil & motor terdekat dari Transgo!', textColor: textSecondary, textAlign: TextAlign.center),
      const SizedBox(height: 25),
    ]));
  }
}