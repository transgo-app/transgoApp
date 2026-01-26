import 'package:url_launcher/url_launcher.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_card.dart';
import '../widgets/filter_widget.dart';
import '../widgets/results_list.dart';
import '../widgets/charge_widget.dart';
import '../widgets/flash_sale_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  Future<void> _openWhatsAppAdmin() async {
    final apiService = APIService();
    final uri = Uri.parse(apiService.getWhatsAppAdminUrl());
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            backgroundColor: primaryColor,
            color: Colors.white,
            onRefresh: () async {
              if (Get.isRegistered<ProfileController>()) {
                final profileController = Get.find<ProfileController>();
                await profileController.getDetailUser();
                await profileController.getCheckAdditional();
              }
              await controller.fetchFlashSales();
              // Only fetch TG Pay and TG Rewards if user is logged in (not guest mode)
              if (GlobalVariables.token.value.isNotEmpty) {
                await controller.fetchTgPayBalance();
                await controller.fetchTgRewardTier();
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    HeaderWidget(controller: controller),
                    SearchCard(controller: controller),
                    FilterWidget(controller: controller),
                    ChargeWidget(controller: controller),
                    ResultsArea(controller: controller),
                  ],
                ),
              ),
            ),
          ),
          // Flash sale overlay at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: FlashSaleWidget(controller: controller),
            ),
          ),
          // WhatsApp button at bottom right
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              right: MediaQuery.of(context).size.width < 360 ? 8.0 : 20.0, // Closer to right edge
              bottom: controller.showWhatsApp.value 
                  ? (MediaQuery.of(context).padding.bottom + 50) // Closer to bottom, accounting for bottom nav bar
                  : -100, // Hide completely when scrolling down
              child: GestureDetector(
                onTap: _openWhatsAppAdmin,
                child: Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/wa_green.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
