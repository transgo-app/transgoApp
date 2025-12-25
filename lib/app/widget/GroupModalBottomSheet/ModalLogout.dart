import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalLogout extends StatelessWidget {
  const ModalLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
        widget: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          IconsaxPlusBold.logout,
          color: Colors.red,
          size: 50,
        ),
        const SizedBox(
          height: 20,
        ),
        gabaritoText(
          text: "Yakin Mau Keluar?",
          fontSize: 20,
          textColor: textHeadline,
        ),
        const SizedBox(
          height: 5,
        ),
        gabaritoText(
          text:
              "Tenang, kamu bisa login lagi kapan aja kalau butuh sewa kendaraan",
          textAlign: TextAlign.center,
          textColor: textSecondary,
        ),
        const SizedBox(
          height: 20,
        ),
        ReusableButton(
          height: 50,
          ontap: () {
            Get.back();
          },
          title: "Batal",
          textColor: textPrimary,
          bgColor: Colors.white,
          borderSideColor: Colors.grey[400],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ReusableButton(
            height: 50,
            textColor: Colors.white,
            ontap: () async {
              Get.deleteAll(force: true);

              GlobalVariables.resetData();

              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('role');

              Get.offAllNamed('/login');
            },
            title: "Iya, Keluar aja",
            bgColor: Colors.red,
            borderSideColor: Colors.red,
          ),
        )
      ],
    ));
  }
}
