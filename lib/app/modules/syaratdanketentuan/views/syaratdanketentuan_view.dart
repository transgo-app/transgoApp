import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/syaratdanketentuan_controller.dart';
import '../../../data/theme.dart';
import '../../../widget/General/text.dart';

class SyaratKetentuanView extends GetView<SyaratKetentuanController> {
  const SyaratKetentuanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            IconsaxPlusBold.arrow_left_1,
            size: 28,
          ),
        ),
        title: gabaritoText(
          text: 'Syarat & Ketentuan',
          fontSize: 16,
          textColor: textHeadline,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          gabaritoText(
            text: controller.mainTitle,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          gabaritoText(
            text: controller.description,
            fontSize: 14,
            textColor: textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...controller.sections.map(
            (section) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gabaritoText(
                  text: section.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  section.items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gabaritoText(
                          text: '${index + 1}.',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: gabaritoText(
                            text: section.items[index],
                            fontSize: 14,
                            textColor: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
