import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/additionaldata/bindings/additionaldata_binding.dart';
import 'package:transgomobileapp/app/modules/additionaldata/views/additionaldata_view.dart';
import 'package:transgomobileapp/app/modules/detailuser/bindings/detailuser_binding.dart';
import 'package:transgomobileapp/app/modules/detailuser/views/detailuser_view.dart';
import 'package:transgomobileapp/app/modules/login/bindings/login_binding.dart';
import 'package:transgomobileapp/app/routes/Navbar.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detailitems/bindings/detailitems_binding.dart';
import '../modules/detailitems/views/detailitems_view.dart';
import '../modules/detailriwayat/bindings/detailriwayat_binding.dart';
import '../modules/detailriwayat/views/detailriwayat_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayatpemesanan/bindings/riwayatpemesanan_binding.dart';
import '../modules/riwayatpemesanan/views/riwayatpemesanan_view.dart';
import '../modules/chatbot/bindings/chatbot_binding.dart';
import '../modules/chatbot/views/chatbot_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.Login;
  static const DEFAULT = Routes.DEFAULT;

  static final routes = [
    GetPage(
      name: _Paths.DEFAULT,
      page: () => NavigationPage(selectedIndex: 0),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.DETAILKENDARAAN,
      page: () => const DetailitemsView(),
      binding: DetailitemsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.RIWAYATPEMESANAN,
      page: () => const RiwayatpemesananView(),
      binding: RiwayatpemesananBinding(),
    ),
    GetPage(
      name: _Paths.DETAILRIWAYAT,
      page: () => const DetailriwayatView(),
      binding: DetailriwayatBinding(),
    ),
    GetPage(
      name: _Paths.ADDITIONALDATA,
      page: () => const AdditionaldataView(),
      binding: AdditionaldataBinding(),
    ),
    GetPage(
      name: _Paths.ADDITIONALDATA,
      page: () => const AdditionaldataView(),
      binding: AdditionaldataBinding(),
    ),
    GetPage(
      name: _Paths.DETAILUSER,
      page: () => const DetailuserView(),
      binding: DetailuserBinding(),
    ),
    GetPage(
      name: Routes.CHATBOT,
      page: () => const ChatbotPage(),
      binding: ChatbotBinding(),
    ),
  ];
}
