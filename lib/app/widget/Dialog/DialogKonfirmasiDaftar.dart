import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/register/controllers/register_controller.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class DialogKonfirmasiDaftar extends StatelessWidget {
  const DialogKonfirmasiDaftar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
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
              const SizedBox(height: 8,),
              poppinsText(text: "Konfirmasi Pendaftaran", fontSize: 14, fontWeight: FontWeight.w600,),
              Padding(padding: EdgeInsets.symmetric(vertical: 10,), child: Divider(),),
              poppinsText(text: "Setiap data yang dikirim akan direview sesuai SOP. Mohon dipahami bahwa pengajuan dapat ditolak, dan perusahaan tidak berkewajiban memberikan penjelasan terkait alasan penolakan. Hal ini dikarenakan alasan penolakan merupakan bagian dari kerahasiaan proses verifikasi perusahaan", fontSize: 12, textAlign: TextAlign.center,),
              const SizedBox(height: 20,),
              ReusableButton(
                height: 50,
                ontap: () {
                  Get.back();
                  Future.delayed(Duration(milliseconds: 600), () {
                    controller.daftarAccount();
                  });
                },
                bgColor: primaryColor,
                title: "Lanjutkan",
              ),
              const SizedBox(height: 10,),
              CustomTextButton(title: "Batal", ontap: () {
                Get.back();
              },
              textColor: Colors.grey,
              )
            ],
          ),
      ),
    );
  }
}