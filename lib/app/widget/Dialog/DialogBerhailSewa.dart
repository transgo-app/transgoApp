
import 'package:lottie/lottie.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';

class DialogBerhasilSewa extends StatelessWidget {
  const DialogBerhasilSewa({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
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
                ReusableButton(
                  height: 50,
                  ontap: () {
                    // Redirect to NavigationPage (root route) with index 1 (Riwayat) and status confirmed
                    Get.offAllNamed(Routes.DEFAULT, arguments: {'index': 1, 'status': 'confirmed'});
                  },
                  bgColor: Colors.white,
                  borderSideColor: Colors.grey,
                  textColor: Colors.black,
                  widget: Center(
                    child: poppinsText(text: "Lihat Pesanan", textColor: Colors.black, fontWeight: FontWeight.w600,)
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  Get.back(); // Pop the dialog safely first
                  Get.offAllNamed(Routes.DEFAULT); // Then redirect to home
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.close, size: 16, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}