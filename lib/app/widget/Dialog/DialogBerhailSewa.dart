
import 'package:lottie/lottie.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/controllers/riwayatpemesanan_controller.dart';
import 'package:transgomobileapp/app/routes/Navbar.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogBerhasilSewa extends StatelessWidget {
  const DialogBerhasilSewa({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final controllerRiwayat = Get.find<RiwayatpemesananController>();
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Lottie.asset('assets/successpemesanan.json')),
            gabaritoText(text: '${GlobalVariables.additional_data_status.value != 'not_required' || GlobalVariables.statusVerificationAccount.value != 'pending' ? 'Pesanan Sewa Kendaraan Telah Dilakukan' : 'Pesanan sewa kendaraan sedang diverifikasi.'}', fontSize: 16, fontWeight: FontWeight.w600, textAlign: TextAlign.center, ),
            const SizedBox(height: 12,),
            gabaritoText(text: '${GlobalVariables.additional_data_status.value != 'not_required' || GlobalVariables.statusVerificationAccount.value != 'pending' ?  'Cek email dan whatsapp valid anda secara berkala untuk informasi verifikasi pesanan Anda. Estimasi tunggu dalam 5 menit kedepan' : 'Pesanan akan disetujui setelah akun Anda terverifikasi oleh admin. namun karena akun anda sedang dalam tahap verifikasi maka unit akan kami benar booking sampai akun anda disetujui admin' }', textAlign: TextAlign.center, textColor: textHeadline, fontSize: 13,),
            const SizedBox(height: 30,),
             ReusableButton(
              height: 50,
              ontap: () {
              launchUrl(Uri.parse('https://wa.me/$whatsAppNumberAdmin?text=Halo Admin Transgo, saya sudah order di aplikasi. Mohon dicek terimakasih.'));
              },
              bgColor: primaryColor,
              textColor: Colors.white,
              title: "Kontak Admin Sekarang",
            ),
            const SizedBox(height: 10,),
            Obx(() => ReusableButton(
              height: 50,
              ontap: () {
                controllerRiwayat.statusFilter.value = '';
                controllerRiwayat.indexActive.value = 0;
                controllerRiwayat.getListKendaraan().then((value) {
                  controller.getList().then((value) {
                    Get.offAll(NavigationPage(selectedIndex: 1));
                    Get.delete<DetailitemsController>();
                  },); 
                },);
              },
              bgColor: Colors.white,
              borderSideColor: Colors.grey,
              textColor: Colors.black,
              widget: Center(
                child: controllerRiwayat.isLoading.value ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ) : poppinsText(text: "Lihat Riwayat Sewa", textColor: Colors.black, fontWeight: FontWeight.w600,)
              ),
            ),),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}