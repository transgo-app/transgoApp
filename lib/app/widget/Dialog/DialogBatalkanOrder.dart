
import 'package:lottie/lottie.dart';
import 'package:transgomobileapp/app/modules/detailriwayat/controllers/detailriwayat_controller.dart';
import 'package:transgomobileapp/app/modules/riwayatpemesanan/controllers/riwayatpemesanan_controller.dart';
import 'package:transgomobileapp/app/routes/Navbar.dart';
import '../../data/data.dart';
import '../widgets.dart';

class KonfirmasiAcction extends StatelessWidget {
  const KonfirmasiAcction({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailriwayatController>();
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(() {
          if(controller.isLoadingCancelTicket.value){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                poppinsText(text: "Harap Tunggu Sedang Membatalkan Tiket Anda", fontSize: 13, fontWeight: FontWeight.w600, textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: LinearProgressIndicator(
                    color: primaryColor,
                  ))
              ],
            );
          }else if(!controller.isLoadingCancelTicket.value) {
          return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            poppinsText(text: "Apakah Anda Yakin Melakukan Aksi Ini?", fontSize: 13, fontWeight: FontWeight.w600, textAlign: TextAlign.center,),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              CustomTextButton(
                textColor: Colors.grey,
                title: "Tutup", ontap: () {
                  Get.back();
              },),
              CustomTextButton(
                textColor: Colors.red,
                title: "Batalkan Sewa", ontap: () {
                  controller.batalkanSewaAPI().then((value) {
                    Get.back();
                    Get.dialog(
                      barrierDismissible: false,
                      PopScope(
                        canPop: false,
                        child: BatalkanSewaDialog()));
                  },);
              },),
              ],
            ),
          ],
        );
          }else{
            return Container();
          }
        },)
      ),
    );
  }
}

class BatalkanSewaDialog extends StatelessWidget {
  const BatalkanSewaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RiwayatpemesananController>();
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/cancelsewa.json'),
            const SizedBox(height: 10,),
            poppinsText(text: "Sewa Dibatalkan", fontSize: 13, fontWeight: FontWeight.w600,),
            const SizedBox(height: 10,),
            poppinsText(text: "Permintaan sewa kendaraan telah dibatalkan. Kami siap membantu Anda jika ada kebutuhan sewa kendaraan di lain waktu", textAlign: TextAlign.center, fontSize: 12,),
            const SizedBox(height: 15,),
            Obx(() =>  ReusableButton(
              bgColor: Colors.white,
              borderSideColor: Colors.grey,
              ontap: () {
                controller.getListKendaraan().then((value) {
                  Get.off(NavigationPage(selectedIndex: 1));
                  Get.delete<DetailriwayatController>();
                },);
              },
              height: 40,
              widget: controller.isLoading.value ? Center(
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ) : Center(
                child: poppinsText(text: "Tutup", textColor: Colors.grey,),
              ) ,
              textColor: Colors.grey,
            ),),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}