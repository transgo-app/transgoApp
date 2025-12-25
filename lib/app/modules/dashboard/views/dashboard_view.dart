import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/data.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_card.dart';
import '../widgets/results_list.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          if (Get.isRegistered<ProfileController>()) {
            final profileController = Get.find<ProfileController>();
            await profileController.getDetailUser();
            await profileController.getCheckAdditional();
          } else {
            print('ProfileController belum terdaftar');
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
    );
  }
}
