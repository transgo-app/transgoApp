import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:transgomobileapp/app/modules/dashboard/views/dashboard_view.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/modules/profile/views/profile_view.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/controllers/riwayatpemesanan_controller.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/views/riwayatpemesanan_view.dart';
import 'package:transgomobileapp/app/modules/transgoreward/controllers/transgoreward_controller.dart';
import 'package:transgomobileapp/app/modules/transgoreward/views/transgoreward_view.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class NavigationPage extends StatefulWidget {
  final int selectedIndex;

  NavigationPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late BottomNavigationController bottomNavigationController;

  // Screens: Home, Riwayat, Reward, Profil
  final screens = [
    DashboardView(),
    RiwayatpemesananView(),
    TransGoRewardView(),
    ProfileView(),
  ];

  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    bottomNavigationController = Get.put(BottomNavigationController());
    initControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bottomNavigationController.changeIndex(widget.selectedIndex);
    });
  }

  void initControllers() async {
    Get.put(DashboardController());
    Get.put(RiwayatpemesananController());
    Get.put(TransGoRewardController()); // Controller tambahan
    Get.put(ProfileController());
  }

  Future<void> refreshPage(int index) async {
    setState(() {
      isRefreshing = true;
    });

    switch (index) {
      case 0:
        GlobalVariables.initializeData();
        Get.find<DashboardController>().getList();
        if (Get.isRegistered<ProfileController>()) {
          final profileController = Get.find<ProfileController>();
          await profileController.getDetailUser();
          await profileController.getCheckAdditional();
        }
        break;
      case 1:
        Get.find<RiwayatpemesananController>().onInit();
        break;
      case 2:
        Get.find<TransGoRewardController>().onInit(); // Refresh reward
        break;
      case 3:
        Get.find<ProfileController>().onInit();
        break;
    }

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
    });

    bottomNavigationController.changeIndex(index); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: bottomNavigationController.selectedIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: HexColor("#79747E"),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: gabaritoTextStyle.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: gabaritoTextStyle.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) {
            if (index == bottomNavigationController.selectedIndex.value) {
              if (!isRefreshing) {
                refreshPage(index); 
              }
            } else {
              bottomNavigationController.changeIndex(index); 
            }
          },
          currentIndex: bottomNavigationController.selectedIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(IconsaxPlusBold.home_2, 0),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(IconsaxPlusBold.note_1, 1),
              label: "Riwayat",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(IconsaxPlusBold.gift, 2), // Icon reward
              label: "Reward",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(IconsaxPlusBold.user, 3),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    if (isRefreshing && bottomNavigationController.selectedIndex.value == index) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(color: HexColor("#264875")),
      );
    }
    return Icon(icon);
  }
}

class BottomNavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
