
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import '../Button/buttons.dart';

class DialogLogin extends StatelessWidget {
  const DialogLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/needlogin.jpg', scale: 10,),
            poppinsText(text: "Untuk melanjutkan proses penyewaan kendaraan, harap lakukan autentikasi login terlebih dahulu. Pastikan akun Anda terhubung untuk pengalaman yang lebih baik!", textAlign: TextAlign.center, fontWeight: FontWeight.w600,),
            CustomTextButton(title: "Daftar & Sewa Sekarang", ontap: () {
            final arguments = {
              'paramPost': controller.paramPost,
              'detailKendaraan': controller.detailData.value
            };
            Get.toNamed('/register', arguments: arguments);
            },)
          ],
        ),
      ),
    );
  }
}