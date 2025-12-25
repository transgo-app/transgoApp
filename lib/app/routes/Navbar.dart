
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:transgomobileapp/app/modules/dashboard/views/dashboard_view.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/modules/profile/views/profile_view.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/controllers/riwayatpemesanan_controller.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/views/riwayatpemesanan_view.dart';



class NavigationPage extends StatefulWidget {
  final int selectedIndex;

  NavigationPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late BottomNavigationController bottomNavigationController;
  final screens = [DashboardView(), RiwayatpemesananView(), ProfileView()];
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
    Get.put(DashboardController(),);
    Get.put(RiwayatpemesananController(),);
    Get.put(ProfileController(),);
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
      } else {
        print('ProfileController belum terdaftar');
      }
        break;
      case 1:
        Get.find<RiwayatpemesananController>().onInit();
        break;
      case 2:
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
          selectedItemColor: HexColor("#264875"),
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
            color: Colors.grey
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
              icon: isRefreshing && bottomNavigationController.selectedIndex.value == 0
                  ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: HexColor("#264875"),
                    ),
                  )
                  : Icon(IconsaxPlusBold.home_2),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: isRefreshing && bottomNavigationController.selectedIndex.value == 1
                  ?  SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: HexColor("#264875"),
                    ),
                  )
                  : Icon(IconsaxPlusBold.note_1),
              label: "Riwayat",
            ),
            BottomNavigationBarItem(
              icon: isRefreshing && bottomNavigationController.selectedIndex.value == 2
                  ?  SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: HexColor("#264875"),
                    ),
                  )
                  : Icon(IconsaxPlusBold.user),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
