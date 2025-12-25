import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalBerhasilDaftar extends StatelessWidget {
  const ModalBerhasilDaftar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(IconsaxPlusBold.tick_circle, color: HexColor('#62D620'), size: 50,),
          maxRadius: 35,
        ),
      gabaritoText(text: "Akun Kamu Udah Berhasil Didaftarkan!", textAlign: TextAlign.center, fontSize: 16, textColor: textHeadline,),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: gabaritoText(text: 'Cek email kamu secara berkala buat info verifikasi. Kamu juga bisa langsung login pakai email dan password yang tadi kamu buat. Proses verifikasi biasanya gak sampai 5 menit, kok!', textAlign: TextAlign.center, textColor: textPrimary,)),
        const SizedBox(height: 10,),
      ReusableButton(
      height: 50,
      textColor: Colors.white,
      ontap: () {
      // Get.offAllNamed('/dashboard');
      Get.offAllNamed('/login');
      },
      title: "Oke, Mengerti",
      bgColor: primaryColor,
      borderSideColor: primaryColor,
    ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ReusableButton(
          height: 50,
          textColor: Colors.black,
          ontap: () {
            launchUrl(Uri.parse('https://wa.me/$whatsAppNumberAdmin?text=Halo Admin Transgo, saya sudah order di aplikasi. Mohon dicek terimakasih.'));
          },
          title: "Hubungi Admin Sekarang",
          bgColor: Colors.white,
          borderSideColor: Colors.grey,
        ),
      )
      ],
    ));
  }
}