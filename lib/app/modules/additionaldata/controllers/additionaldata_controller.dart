import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/data/helper/Storage_helper.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/modules/register/controllers/register_controller.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class AdditionaldataController extends GetxController {
  RxString uploadBatch = ''.obs;
  RxList listDataKomentar = [].obs;
  RxBool isDataEmpty = false.obs;
  RxBool isLoadingPhoto = false.obs;
  RxBool isLoadingSendData = false.obs;
  final controllerProfile = Get.find<ProfileController>();

  @override
  void onInit() {
    getAdminCommentar();
    super.onInit();
  }

  Future<void> getAdminCommentar() async {
    try {
      var data = await APIService().get('/customers/additional/data');
      listDataKomentar.value = data;

      if (listDataKomentar.isNotEmpty) {
        int lastIndex = listDataKomentar.length - 1;
        List items = listDataKomentar[lastIndex]['items'] ?? [];
        isDataEmpty.value = items.isEmpty;
        uploadBatch.value =
            listDataKomentar[lastIndex]['related_upload_batch'] ?? '';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  var pickedImages = <String, XFile?>{}.obs;

  var fileSizes = <String, String>{}.obs;

  int _fileCounter = 0;

  void onPickImage(ImageSource source, {String? keyFile}) {
    String fileKey = keyFile ?? 'file_${_fileCounter++}';

    pickImage(
      title: "Tambahan",
      source: source,
      isLoading: isLoadingPhoto,
      pickedImages: pickedImages,
      type: fileKey,
      compressAndAddImage: (file) => compressAndAddImage(
        file: file,
        onImageCompressed: (compressed) {
          pickedImages[fileKey] = compressed;

          _calculateAndCacheFileSize(compressed, fileKey);

          pickedImages.refresh();
        },
      ),
      validateInput: () {},
    );
  }

  void removeImage(String key) {
    if (pickedImages.containsKey(key)) {
      pickedImages.remove(key);
      fileSizes.remove(key);
      pickedImages.refresh();
      fileSizes.refresh();
      print("Gambar dengan key '$key' berhasil dihapus.");
    } else {
      print("Key '$key' tidak ditemukan.");
    }
  }

  void clearAllImages() {
    pickedImages.clear();
    fileSizes.clear();
  }

  void _calculateAndCacheFileSize(XFile file, String keyFile) async {
    try {
      final int fileSize = await file.length();
      final String sizeKb = (fileSize / 1024).toStringAsFixed(2);
      fileSizes[keyFile] = "${sizeKb}Kb";
      fileSizes.refresh();
    } catch (e) {
      print('Error calculating file size: $e');
      fileSizes[keyFile] = "- Kb";
    }
  }

  Future<void> uploadAdditionalData() async {
    isLoadingSendData.value = true;

    final files = pickedImages.values.whereType<XFile>().toList();

    if (files.isEmpty) {
      print('No images selected.');
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan Tambah Dahulu Data Gambar");
      isLoadingSendData.value = false;
      return;
    }

    try {
      final fileNames = files.map((xfile) => xfile.name).toList();

      final presignData = await getPresignedUrls(
          fileNames: fileNames,
          baseUrl: baseUrl,
          username: username,
          password: password);

      final fileList = files.map((xfile) => File(xfile.path)).toList();

      final uploadedUrls = await uploadImages(
        pickedImages: fileList,
        presignData: presignData,
        onProgress: (progress) {
          print('Upload progress: ${progress.toStringAsFixed(1)}%');
        },
      );

      final payload = {
        "uploadBatch": uploadBatch.value,
        "id_cards": uploadedUrls,
      };

      print('Sending payload: $payload');

      final response =
          await APIService().post('/customers/upload/additional', payload);

      getAdminCommentar();
      print('Upload success: $response');

      CustomSnackbar.show(
          title: "Data Verifikasi Berhasil Dikirim",
          message: "Harap Tunggu Informasi Selanjutnya Dari Admin",
          backgroundColor: Colors.green);

      controllerProfile.onInit();
    } catch (e) {
      print("Upload failed: $e");
    } finally {
      isLoadingSendData.value = false;
    }
  }

  int get selectedFilesCount => pickedImages.values.whereType<XFile>().length;

  List<String> get selectedFileNames =>
      pickedImages.values.whereType<XFile>().map((file) => file.name).toList();
}
