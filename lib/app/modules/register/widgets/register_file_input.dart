import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widget/Card/BackgroundCard.dart';
import '../../../widget/Dialog/DialogUpload.dart';
import '../../../widget/widgets.dart';
import '../../detailitems/widgets/lihat_detail_gambar.dart';
import '../controllers/register_controller.dart';
import '../../../data/theme.dart';

class RegisterFileInput extends StatelessWidget {
  final String keyFile;
  final String title;

  const RegisterFileInput({
    super.key,
    required this.keyFile,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();

    return Obx(() {
      final dataFile = controller.pickedImages[keyFile];
      final fileSize = controller.fileSizes[keyFile] ?? "";

      if (dataFile != null) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gabaritoText(
                text: "${title}*",
                Maxlines: 2,
                overflow: TextOverflow.ellipsis,
                textColor: HexColor('#3E424B'),
              ),
              const SizedBox(height: 5),
              BackgroundCard(
                body: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(
                            text: dataFile.name,
                            Maxlines: 2,
                            overflow: TextOverflow.ellipsis,
                            textColor: HexColor('#3E424B'),
                          ),
                          const SizedBox(height: 5),
                          gabaritoText(
                            text: fileSize,
                            Maxlines: 2,
                            overflow: TextOverflow.ellipsis,
                            textColor: textSecondary,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(DialogUpload(
                          isLoading: controller.isLoadingPhoto,
                          onPickImageCamera: () => controller.onPickImage(
                              title, ImageSource.camera, keyFile),
                          onPickImageGallery: () => controller.onPickImage(
                              title, ImageSource.gallery, keyFile),
                        ));
                      },
                      child: Icon(IconsaxPlusBold.edit_2, color: solidPrimary),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(
                              LihatDetailGambar(imageUrl: File(dataFile.path)));
                        },
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: solidPrimary,
                        )),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gabaritoText(text: "$title*"),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Get.dialog(DialogUpload(
                    isLoading: controller.isLoadingPhoto,
                    onPickImageCamera: () => controller.onPickImage(
                        title, ImageSource.camera, keyFile),
                    onPickImageGallery: () => controller.onPickImage(
                        title, ImageSource.gallery, keyFile),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(Get.context!).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60)),
                          color: HexColor('#F4F7FD'),
                          border: Border.all(color: primaryColor),
                        ),
                        child: Center(
                          child: Icon(IconsaxPlusBold.document_upload,
                              color: primaryColor),
                        ),
                      ),
                      const SizedBox(height: 5),
                      gabaritoText(
                          text: "Upload File",
                          textColor: textPrimary,
                          fontSize: 16),
                      Text(
                        "Pilih File",
                        style: gabaritoTextStyle.copyWith(
                          fontSize: 14,
                          color: solidPrimary,
                          decoration: TextDecoration.underline,
                          decorationColor: solidPrimary,
                          decorationThickness: 1,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
