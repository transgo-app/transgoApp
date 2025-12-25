import 'dart:io';

import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/additionaldata/controllers/additionaldata_controller.dart';
import 'package:transgomobileapp/app/widget/Dialog/DialogUpload.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
 
 class AdditionaldataView extends GetView<AdditionaldataController> {
  const AdditionaldataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        centerTitle: false,
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
        backgroundColor: Colors.white,
        title: gabaritoText(
          text: "Halaman Upload Data Tambahan",
          fontSize: 16,
          textColor: textHeadline,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: gabaritoText(
              text: "Halaman ini digunakan untuk mengunggah data. Mohon pastikan data yang diunggah sesuai dengan komentar dari admin.",
              fontSize: 14,
            ),
          ),
          Divider(),
         Obx(() => Expanded(
           child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
             child: ListView.builder(
              itemCount: controller.listDataKomentar.length,
              itemBuilder: (context, index) {
                final data = controller.listDataKomentar[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        poppinsText(
                          text: '${index + 1}. ',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        Expanded(
                          child: gabaritoText(
                            text: "${data['message']}",
                            fontSize: 14,
                          ),
                        ),
                        if(index == controller.listDataKomentar.length - 1 && controller.isDataEmpty.value)
                        IconButton(
                          onPressed: () {
                             Get.dialog(DialogUpload(
                            isLoading: controller.isLoadingPhoto,
                            onPickImageCamera: () => controller.onPickImage(ImageSource.camera),
                            onPickImageGallery: () => controller.onPickImage(ImageSource.gallery),
                          ));
                          },
                          icon: Icon(Icons.add, color: Colors.black),
                        ),
                      ],
                    ),
                    if ((data['items'] as List).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (data['items'] as List).map<Widget>((imageUrl) {
                            return Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 110,
                                      height: 110,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if ((data['items'] as List).isEmpty && index == controller.listDataKomentar.length - 1)
                    Obx(() {
                      final selectedFiles = controller.pickedImages.values
                          .whereType<XFile>()
                          .toList();
                          
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedFiles.asMap().entries.map<Widget>((entry) {
                              // final fileIndex = entry.key;
                              final xfile = entry.value;
                              
                              final fileKey = controller.pickedImages.entries
                                  .where((mapEntry) => mapEntry.value == xfile)
                                  .first
                                  .key;
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(xfile.path),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      controller.removeImage(fileKey);
                                    }, 
                                    icon: Icon(Icons.delete, color: Colors.red,)
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 8),
                    Divider(),
                  ],
                );
              },
            ),

           ),
         ),),
         Obx(() {
           if(controller.isDataEmpty.value){
            return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ReusableButton(
              bgColor: primaryColor,
              ontap: () {
                controller.uploadAdditionalData();
              },
              widget: Center(
                child: controller.isLoadingSendData.value ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ) : poppinsText(text: "Upload Data", textColor: Colors.white,),
              ),
            ),
          );
           }else if(!controller.isDataEmpty.value){
            return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
           child: ReusableButton(
            bgColor: Colors.grey,
            ontap: () {
            },
            widget: Center(
              child: poppinsText(text: "Data Anda Sedang Di Verifikasi", textColor: Colors.white,),
            ),
           ),
         );
           }else{
            return Container();
           }
         },)
        
        ],
      ),
    );
  }
}