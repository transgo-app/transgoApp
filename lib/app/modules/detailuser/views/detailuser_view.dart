
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
    final detailController = Get.find<DetailuserController>();
    return Scaffold(
      backgroundColor: HexColor("#FAFAFA"),
      resizeToAvoidBottomInset: true,
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
            text: controller.detailPribadi ? "Data Pribadi" : "Dokumen Pribadi",
            fontSize: 16,
            textColor: textHeadline,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(controller.detailPribadi)
                        Column(
                          children: [
                            dataPribadiTextField("Nama Lengkap", controllerProfile.namaUserC),
                            dataPribadiTextField("Email", controllerProfile.emailC),
                            dataPribadiTextField("Nomor Telepon", controllerProfile.nomorTelpC),
                            dataPribadiTextField("Nomor Darurat", controllerProfile.nomorDaruratC),
                      jenisKelaminDropdown(detailController, controllerProfile),
                            dataPribadiTextField("Tanggal Lahir", controllerProfile.tanggalLahirC),
                            dataPribadiTextField("NIK", controllerProfile.nikC),
                            const SizedBox(height: 10),
                            dataPribadiTextField("Password Baru", controllerProfile.passwordC, obscureText: true),
                            dataPribadiTextField("Konfirmasi Password", controllerProfile.confirmPasswordC, obscureText: true),
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
                                child: dataFotoPribadi(i+1, ),
                              ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              if (controller.detailPribadi)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() {
                    final canSave = detailController.canSave.value;
                    final isSaving = detailController.isSaving.value;
                    return ReusableButton(
                      height: 50,
                      bgColor: canSave ? solidPrimary : Colors.grey,
                      ontap: canSave && !isSaving
                          ? () => detailController.saveDataPribadi()
                          : null,
                      widget: Center(
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : gabaritoText(
                                text: "Simpan",
                                textColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
    );
  }

  Widget jenisKelaminDropdown(
      DetailuserController detailController, ProfileController profileController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gabaritoText(text: "Jenis Kelamin", fontSize: 14),
          const SizedBox(height: 5),
          Obx(() {
            final value = detailController.selectedGender.value.isEmpty
                ? null
                : detailController.selectedGender.value;
            return DropdownButtonFormField<String>(
              value: value,
              items: const [
                DropdownMenuItem(
                  value: 'male',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (val) {
                if (val == null) return;
                detailController.selectedGender.value = val;
                profileController.jenisKelaminC.text = val;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: HexColor('#F3F3F3'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: solidPrimary, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget dataPribadiTextField(String title, TextEditingController controller,
      {bool obscureText = false}){
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
            obscureText: obscureText,
            backgroundColor: HexColor('#F3F3F3'),
          ),
        )
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