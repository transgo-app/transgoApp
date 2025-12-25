
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class DialogUpload extends StatelessWidget {
  final RxBool isLoading;
  final VoidCallback onPickImageGallery;
  final VoidCallback onPickImageCamera;
  
  const DialogUpload({super.key, required this.isLoading, required this.onPickImageGallery, required this.onPickImageCamera, });

  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: poppinsText(
                    text: "Pilih Melalui Galeri",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
                  CustomTextButton(
                    title: "Buka Galeri",
                    ontap: onPickImageGallery,
                    textColor: Colors.blue,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: poppinsText(
                    text: "Ambil Gambar Sekarang",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
                  CustomTextButton(
                    title: "Buka Kamera",
                    ontap: onPickImageCamera,
                    textColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() => isLoading.value ? poppinsText(text: "Harap Tunggu", fontSize: 12, fontWeight: FontWeight.w600, textColor: primaryColor,) : CustomTextButton(
                title: "Tutup",
                ontap: () {
                  Get.back();
                },
                textColor: Colors.grey,
              ),)
            )
          ],
        ),
      ),
    );
  }
}