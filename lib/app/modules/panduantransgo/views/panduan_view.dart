import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/panduan_controller.dart';
import '../../../data/theme.dart';
import '../../../widget/General/text.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class PanduanView extends GetView<PanduanController> {
  const PanduanView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

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
          text: 'Panduan TransGo',
          fontSize: 16,
          textColor: textHeadline,
        ),
        centerTitle: false,
        // centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: controller.panduanList.length,
                itemBuilder: (context, index) {
                  final item = controller.panduanList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Image.asset(
                          item.image,
                          height: 420,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        gabaritoText(
                          text: item.title,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        gabaritoText(
                          text: item.description,
                          fontSize: 14,
                          textColor: textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _NavigationBar(
              pageController: pageController,
              total: controller.panduanList.length,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _NavigationBar extends StatefulWidget {
  final PageController pageController;
  final int total;

  const _NavigationBar({
    required this.pageController,
    required this.total,
  });

  @override
  State<_NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<_NavigationBar> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      final index = widget.pageController.page?.round() ?? 0;
      if (index != currentIndex) {
        setState(() => currentIndex = index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          _NavButton(
            label: 'Kembali',
            isActive: currentIndex > 0,
            onTap: currentIndex > 0
                ? () {
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.total,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentIndex
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
          _NavButton(
            label: 'Lanjut',
            isActive: currentIndex < widget.total - 1,
            onTap: currentIndex < widget.total - 1
                ? () {
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavButton({
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: gabaritoText(
          text: label,
          fontSize: 14,
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
