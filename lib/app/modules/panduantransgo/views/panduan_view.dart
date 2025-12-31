import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/panduan_controller.dart';
import '../../../data/theme.dart';
import '../../../widget/General/text.dart';

class PanduanView extends GetView<PanduanController> {
  const PanduanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(IconsaxPlusBold.arrow_left_1, size: 28),
        ),
        title: gabaritoText(
          text: 'Panduan Pemesanan',
          fontSize: 16,
          textColor: textHeadline,
        ),
      ),
      body: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          itemCount: controller.panduanList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final item = controller.panduanList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                gabaritoText(
                  text: item.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 6),
                gabaritoText(
                  text: item.description,
                  fontSize: 14,
                  textColor: textSecondary,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
