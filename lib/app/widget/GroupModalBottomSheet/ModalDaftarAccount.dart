
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class ModalDaftarAkun extends StatelessWidget {
  const ModalDaftarAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    return BottomSheetComponent(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(IconsaxPlusBold.info_circle, color: HexColor('#03AEC4'), size: 50,),
          maxRadius: 35,
        ),
      gabaritoText(text: "Yuk, Masuk atau Daftar Dulu!", textAlign: TextAlign.center, fontSize: 16, textColor: textHeadline,),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: gabaritoText(text: 'Biar kamu bisa lanjut sewa kendaraan, cek pesanan, dan nikmatin fitur lengkap lainnya dari Transgo.', textAlign: TextAlign.center, textColor: textPrimary,)),
        const SizedBox(height: 10,),
      ReusableButton(
      height: 50,
      textColor: Colors.white,
      ontap: () {
        print('controller.detailData: ${controller.detailData}');
        final arguments = {
          'paramPost': controller.paramPost,
          'detailKendaraan': controller.detailData,
        };
        print('arguments to register: $arguments');
        Get.toNamed('/register', arguments: arguments);
      },
      title: "Daftar & Sewa",
      bgColor: primaryColor,
      borderSideColor: primaryColor,
    ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ReusableButton(
          height: 50,
          textColor: Colors.black,
          ontap: () {
            Get.back();
          },
          title: "Kembali",
          bgColor: Colors.white,
          borderSideColor: Colors.grey,
        ),
      )
      ],
    ));
  }
}