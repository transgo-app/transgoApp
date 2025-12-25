
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailuser/controllers/detailuser_controller.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailuserView extends GetView<DetailuserController> {
  const DetailuserView({super.key});
  @override
  Widget build(BuildContext context) {
    final controllerProfile = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: HexColor("#FAFAFA"),
       appBar: AppBar(
          leading: Container(
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                IconsaxPlusBold.arrow_left_1,
                size: 33,
              ),
            ),
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: HexColor("#FAFAFA"),
          title: gabaritoText(
            text: "Data Pribadi",
            fontSize: 16,
            textColor: textHeadline,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                if(controller.detailPribadi)
              Column(
                children: [
                dataPribadiTextField("Nama Lengkap", controllerProfile.namaUserC),
                dataPribadiTextField("Email", controllerProfile.emailC),
                dataPribadiTextField("Nomor Telepon", controllerProfile.nomorTelpC),
                dataPribadiTextField("Nomor Darurat", controllerProfile.nomorDaruratC),
                dataPribadiTextField("Jenis Kelamin", controllerProfile.jenisKelaminC),
                dataPribadiTextField("Tanggal Lahir", controllerProfile.tanggalLahirC),
                ],
              ),
                if(!controller.detailPribadi)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                for(var i=0; i<controllerProfile.idCards.length; i++)
                 GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('${controllerProfile.idCards[i]['photo']}'));
                  },
                  child: dataFotoPribadi(i+1, )),
                ],
              )
              ],
            ),
          ),
        ),
    );
  }

  Widget dataPribadiTextField(String title, TextEditingController controller){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: title, fontSize: 14,),
        const SizedBox(height: 5,),
        SizedBox(
          height: 50,
          child: reusableTextField(
            controller: controller,
            title: title, 
            backgroundColor: HexColor('#F3F3F3'),))
      ],
      ),
    );
  }

  Widget dataFotoPribadi(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: "Dokumen Pribadi $index"),
        const SizedBox(height: 5,),
        BackgroundCard(
          height: 60,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: gabaritoText(text: "Dokumen Pribadi $index")),
                Icon(IconsaxPlusBold.document_download, color: solidPrimary,)
              ],
            )
          ],
        ))
      ],
        ),
    );
  }
}