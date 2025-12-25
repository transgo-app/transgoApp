import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/widgets.dart';
import '../controllers/register_controller.dart';
import 'register_file_input.dart';
import '../../../data/theme.dart';
import '../../../widget/Dialog/DialogKonfirmasiDaftar.dart';

class RegisterUploadForm extends StatelessWidget {
  const RegisterUploadForm({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableButton(
          width: 100,
          height: 30,
          widget: gabaritoText(
            text: "Kembali",
            textColor: Colors.white,
            fontSize: 14,
          ),
          bgColor: primaryColor,
          ontap: () {
            controller.isUploadFile.value = false;
          },
        ),
        RegisterFileInput(keyFile: 'ktp', title: "Kartu Tanda Penduduk"),
        RegisterFileInput(keyFile: 'kartu_keluarga', title: "Kartu Keluarga"),
        RegisterFileInput(keyFile: 'sim_npwp', title: "SIM atau NPWP"),
        RegisterFileInput(keyFile: 'id_kerja', title: "ID Kerja, Kartu Pelajar, atau KTM"),
        RegisterFileInput(keyFile: 'data_pendukung', title: "Data Pendukung Lainnya (Opsional)"),
        const SizedBox(
          height: 15,
        ),
        Obx(
          () => ReusableButton(
            ontap: () {
              if (controller.allowedToRegistrasi.value) {
                bool semuaTerisi = controller
                    .pickedImages.entries
                    .where((e) =>
                        e.key != "data_pendukung" &&
                        (controller.selectedRole.value ==
                                'product_customer'
                            ? true
                            : e.key !=
                                'supporting_documents_url'))
                    .every((e) => e.value != null);

                if (semuaTerisi) {
                  Get.dialog(DialogKonfirmasiDaftar());
                } else {
                  CustomSnackbar.show(
                      title: "Terjadi Kesalahan",
                      message:
                          "Silahkan Input Seluruh Formulir Registrasi");
                }
              } else {
                CustomSnackbar.show(
                    title: "Terjadi Kesalahan",
                    message:
                        "Silahkan lengkapi formulir registrasi",
                    icon: Icons.edit_document);
              }
            },
            bgColor: primaryColor,
            widget: Center(
              child: controller.isLoading.value
                  ? Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        gabaritoText(
                          text:
                              "${controller.progressValue.value} %",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                        ),
                      ],
                    )
                  : gabaritoText(
                      text:
                          "${controller.dataArgumentsDetailKendaraan.isEmpty ? "Daftar Sekarang" : "Daftar & Sewa"}",
                      textColor: Colors.white,
                    ),
            ),
            height: 50,
          ),
        ),
      ],
    );
  }
}