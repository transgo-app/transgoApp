import 'package:lottie/lottie.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:http/http.dart' as http;

class DialogHapusAkunController extends GetxController {
  TextEditingController alasanPenghapusan = TextEditingController();

  
  Future<void> hapusAccount() async {
  try {
    var response = await http.post(
      Uri.parse('https://script.google.com/macros/s/AKfycbwcvt2uyoyX78TJY7oTbzEJhqEFc4TECgmHvcPqRlGcqNp4Hypl6vNmjnLRYcg33rF0/exec'),
      body: {
        'email': GlobalVariables.emailUser.value,
        'no_telepon': GlobalVariables.nomorTelepon.value,
        'alasan': alasanPenghapusan.value.text,
      },
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    if (response.statusCode == 302) {
          print('Redirected to: ${response.headers['location']}');
        }
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
}

class DialogHapusAkun extends StatelessWidget {
  const DialogHapusAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DialogHapusAkunController());
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gabaritoText(text: "Formulir Hapus Akun", fontSize: 14, textAlign: TextAlign.center,),
            Divider(),
            const SizedBox(height: 20,),
            gabaritoText(text: "Bantu Kami Untuk Dapat Memahami Masalah Anda", fontSize: 12, ),
            const SizedBox(height: 10,),
            reusableTextField(title: "Masukkan Alasan (Optional)", icon: Icons.account_circle, controller: controller.alasanPenghapusan,),
            const SizedBox(height: 20,),
            ReusableButton(
              height: 50,
              ontap: (){
                Get.back();
                Get.dialog(KonfirmasiHapusAkun());
              },
              bgColor: Colors.red,
              widget: Center(
                child: gabaritoText(text: "Hapus Akun", textColor: Colors.white,),
              ),
            ),
            const SizedBox(height: 10,),
            CustomTextButton(
              textColor: Colors.grey,
              title: "Batal", ontap: () {
              Get.back();
            },)
          ],
        ),
      ),
    );
  }
}

class KonfirmasiHapusAkun extends StatelessWidget {
  const KonfirmasiHapusAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DialogHapusAkunController>();
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            poppinsText(text: "Apakah Anda Yakin Untuk Menghapus Akun?", fontSize: 12, fontWeight: FontWeight.w600, textAlign: TextAlign.center,),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextButton(
                  textColor: Colors.grey,
                  title: "Batal", ontap: () {
                    Get.back();
                },),
                  CustomTextButton(
                  textColor: Colors.red,
                  title: "Hapus Akun", ontap: () {
                    controller.hapusAccount().then((value) {
                      Get.back();
                    Get.dialog(SuccessDeleteAccount());
                    },);
                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SuccessDeleteAccount extends StatelessWidget {
  const SuccessDeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Lottie.asset('assets/success.json')),
            poppinsText(text: "Penghapusan Akun Anda Sedang Di Proses", fontSize: 12, fontWeight: FontWeight.w600,),
            const SizedBox(height: 10,),
            poppinsText(text: "Proses ini akan selesai dalam waktu maksimal 1x24 jam. Konfirmasi penghapusan akun akan dikirimkan ke email Anda setelah proses selesai.", textAlign: TextAlign.center,),
            const SizedBox(height: 20,),
            ReusableButton(
              bgColor: Colors.white,
              ontap: () {
                Get.back();
              },
              title: "Tutup",
              borderSideColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}