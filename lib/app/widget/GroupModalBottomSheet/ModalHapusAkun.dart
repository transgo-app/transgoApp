import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class ModalHapusAkun extends StatelessWidget {
  const ModalHapusAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return BottomSheetComponent(
        widget: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          IconsaxPlusBold.profile_delete,
          color: Colors.red,
          size: 50,
        ),
        const SizedBox(
          height: 20,
        ),
        gabaritoText(
          text: "Yakin Mau Menonaktifkan Akun?",
          fontSize: 20,
          textColor: Colors.red,
        ),
        const SizedBox(
          height: 5,
        ),
        gabaritoText(
          text:
              "Tindakan ini akan menonaktifkan akun kamu dan proses penonaktifan akan berlangsung dalam 3 hari ke depan.",
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
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ReusableButton(
            height: 50,
            textColor: Colors.white,
            ontap: () {
              controller.requestDeleteAccount().then((value) async {
                if (!Get.isSnackbarOpen) {
                  Get.back();
                }
                controller.getCheckAdditional();
              });
            },
            title: "Iya, Nonaktifkan Akun",
            bgColor: Colors.red,
            borderSideColor: Colors.red,
          ),
        )
      ],
    ));
  }
}
