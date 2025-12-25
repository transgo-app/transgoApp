
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class ModalPilihanAsuransi extends StatelessWidget {
  const ModalPilihanAsuransi({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    return BottomSheetComponent(
      widget: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: "Pilih Asuransi", fontSize: 18,),
        const SizedBox(height: 10,),
        BackgroundCard(
          marginVertical: 5,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
            value: "0", 
            groupValue: controller.selectedAsuransi.value,
            activeColor: primaryColor,
            onChanged: (value) {
              controller.selectedAsuransi.value = '0';
              controller.selectedHargaAsuransi.value = '-';
              controller.getDetailAPI();
              controller.detailSelectedAsuransi.value = 'Tanpa Perlindungan'; 
            },),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(text: "Tanpa Perlindungan"),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: gabaritoText(text: "Bawa kendaraan dengan ekstra hati-hati, ya!", 
                    textColor: textPrimary,
                    ),
                  ),
                  gabaritoText(text: "+Rp0", 
                  textColor: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        )),
        for (var i = 0; i < controller.dataAsuransi.length; i++)
        BackgroundCard(
          marginVertical: 5,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: controller.dataAsuransi[i]['id'].toString(),
              groupValue: controller.selectedAsuransi.value, 
              activeColor: primaryColor,
              onChanged: (value) {
                controller.selectedAsuransi.value = value.toString();
                controller.selectedHargaAsuransi.value = controller.dataAsuransi[i]['price'].toString();
                controller.getDetailAPI();
              controller.detailSelectedAsuransi.value = controller.dataAsuransi[i]['name'];
            },),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(text: '${controller.dataAsuransi[i]['name']}'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: gabaritoText(text: "${controller.dataAsuransi[i]['description']}", 
                    textColor: textPrimary,
                    ),
                  ),
                  gabaritoText(text: "Rp ${formatRupiah(controller.dataAsuransi[i]['price'])}", 
                  textColor: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        )),
        const SizedBox(height: 20,),
        ReusableButton(
        height: 60,
        ontap: () {
          Get.back();
        },
        title: "Simpan Asuransi",
        bgColor: primaryColor,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ReusableButton(
          height: 60,
          textColor: textHeadline,
          ontap: () {
            Get.back();
          },
          title: "Batal",
          bgColor: Colors.white,
          borderSideColor: Colors.grey[400],
        ),
      )
      ],
    ),));
  }
}