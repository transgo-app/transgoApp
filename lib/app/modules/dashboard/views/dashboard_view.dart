import 'package:url_launcher/url_launcher.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_card.dart';
import '../widgets/results_list.dart';

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
                    ResultsArea(controller: controller),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              right: 32,
              bottom: controller.showWhatsApp.value ? 48 : -80,
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
