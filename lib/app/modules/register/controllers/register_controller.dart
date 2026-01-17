import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:transgomobileapp/app/data/helper/Storage_helper.dart';
import 'package:transgomobileapp/app/widget/Dialog/DialogSuccessUploadRegister.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBerhasilDaftar.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class RegisterController extends GetxController {
  final TextEditingController namaLengkapC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController nomorTelpC = TextEditingController();
  final TextEditingController nomorDaruratC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();
  final TextEditingController referralCodeC = TextEditingController();

  RxString selectedJenisKelamin = ''.obs;
  RxString errorTextNama = ''.obs;
  RxString errorTextEmail = ''.obs;
  RxString errorTextNomorTelp = ''.obs;
  RxString errorTextNomorTelpDarurat = ''.obs;
  RxString errorTextPassword = ''.obs;
  RxString errorTextPasswordConfirmation = ''.obs;
  RxString errorTextRole = ''.obs;
  RxString jenisKelaminC = ''.obs;
  RxString pickedDate = ''.obs;
  RxString progressValue = '0'.obs;
  RxString selectedRole = 'customer'.obs;
  RxString errorTextReferral = ''.obs;

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  RxList jenisKelamin = [
    {'id': 'male', 'name': 'Pria'},
    {'id': 'female', 'name': 'Wanita'},
    {'id': '-', 'name': 'Tidak Ingin Menjawab'},
  ].obs;
  RxList roles = [
    {'id': 'customer', 'name': 'Customer - Sewa Mobil/Motor'},
    {
      'id': 'product_customer',
      'name': 'Product Customer - Sewa Iphone/Kamera, dll'
    },
  ].obs;

  var dataArgumentsParamPost = Get.arguments['paramPost'];
  var dataArgumentsDetailKendaraan = Get.arguments['detailKendaraan'];

  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;

  RxBool isUploadFile = false.obs;

  late Map<String, dynamic> paramPost;
  final int maxFileSize = 2 * 1024 * 1024;
  RxBool isLoadingPhoto = false.obs;

  var pickedImages = <String, XFile?>{
    "ktp": null,
    "kartu_keluarga": null,
    "sim_npwp": null,
    "id_kerja": null,
    "data_pendukung": null,
    "supporting_documents_url": null,
  }.obs;

  var fileSizes = <String, String>{
    "ktp": "",
    "kartu_keluarga": "",
    "sim_npwp": "",
    "id_kerja": "",
    "data_pendukung": "",
    "supporting_documents_url": "",
  }.obs;

  void onPickImage(String title, ImageSource source, String keyFile) async {
    await pickImage(
      title: title,
      source: source,
      isLoading: isLoadingPhoto,
      pickedImages: pickedImages,
      type: keyFile,
      compressAndAddImage: (file) => compressAndAddImage(
        file: file,
        onImageCompressed: (compressed) {
          pickedImages[keyFile] = compressed;

          _calculateAndCacheFileSize(compressed, keyFile);

          pickedImages.refresh();
        },
      ),
      validateInput: validateInput,
    );
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

  var allowedToRegistrasi = false.obs;

  void validateInput() {
    bool isValid = true;

    if (namaLengkapC.text.isEmpty) {
      errorTextNama.value = 'Nama Tidak Boleh Kosong';
      isValid = false;
    } else {
      errorTextNama.value = '';
    }

    if (emailC.text.isEmpty) {
      errorTextEmail.value = 'Email Tidak Boleh Kosong';
      isValid = false;
    } else {
      errorTextEmail.value = '';
    }

    if (nomorTelpC.text.isEmpty) {
      errorTextNomorTelp.value = 'Nomor Telepon Tidak Boleh Kosong';
      isValid = false;
    } else {
      errorTextNomorTelp.value = '';
    }
    if (selectedRole.value.isEmpty) {
      errorTextRole.value = 'Role harus dipilih';
      isValid = false;
    } else {
      errorTextRole.value = '';
    }

    if (nomorDaruratC.text.isEmpty) {
      errorTextNomorTelpDarurat.value =
          'Nomor Telepon Darurat Tidak Boleh Kosong';
      isValid = false;
    } else {
      errorTextNomorTelpDarurat.value = '';
    }

    if (passwordC.text.isEmpty) {
      errorTextPassword.value = 'Password Tidak Boleh Kosong';
      isValid = false;
    } else if (passwordC.text.length < 8) {
      errorTextPassword.value = 'Password Minimal 8 Karakter';
      isValid = false;
    } else {
      errorTextPassword.value = '';
    }

    if (confirmPasswordC.text.isEmpty) {
      errorTextPasswordConfirmation.value =
          'Konfirmasi Password Tidak Boleh Kosong';
      isValid = false;
    } else if (confirmPasswordC.text.length < 8) {
      errorTextPasswordConfirmation.value =
          'Konfirmasi Password Minimal 8 Karakter';
      isValid = false;
    } else if (confirmPasswordC.text != passwordC.text) {
      errorTextPasswordConfirmation.value = 'Konfirmasi Password Tidak Sesuai';
      isValid = false;
    } else {
      errorTextPasswordConfirmation.value = '';
    }

    if (selectedJenisKelamin.value == '') {
      isValid = false;
    }

    if (pickedDate.value == '') {
      isValid = false;
    }
    if (referralCodeC.text.isNotEmpty) {
      if (referralCodeC.text.length < 6) {
        errorTextReferral.value = 'Referral minimal 6 karakter';
        isValid = false;
      } else {
        errorTextReferral.value = '';
      }
    } else {
      errorTextReferral.value = '';
    }

    allowedToRegistrasi.value = isValid;
  }

  @override
  void onInit() {
    super.onInit();

    final productData = dataArgumentsDetailKendaraan?['product'];
    final fleetData = dataArgumentsDetailKendaraan?['fleet'];

    final bool isProductItem =
        productData != null && productData is Map && productData.isNotEmpty;

    final bool isFleetItem =
        fleetData != null && fleetData is Map && fleetData.isNotEmpty;

    initRoleByItem(
      isFleetItem: isFleetItem,
      isProductItem: isProductItem,
    );
    passwordC.addListener(
      () {
        validateInput();
      },
    );
    confirmPasswordC.addListener(
      () {
        validateInput();
      },
    );
    referralCodeC.addListener(() {
      validateInput();
    });
  }

  Future<void> daftarAccount() async {
    isLoading.value = true;

    try {
      if (!allowedToRegistrasi.value) {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan lengkapi formulir registrasi",
          icon: Icons.edit_document,
        );
        return;
      }

      final files = pickedImages.values.whereType<XFile>().toList();
      List<String> uploadedUrls = [];

      try {
        List<String> fileNames = files.map((e) => e.name).toList();

        var presignData = await getPresignedUrls(
          fileNames: fileNames,
          baseUrl: baseUrl,
          username: username,
          password: password,
        );

        uploadedUrls = await uploadImages(
          presignData: presignData,
          pickedImages: files.map((xfile) => File(xfile.path)).toList(),
          onProgress: (progress) {
            progressValue.value = progress.toString();
          },
        );
      } catch (e) {
        print("Gagal upload dokumen: $e");
        CustomSnackbar.show(
          title: "Perhatian",
          message: "Dokumen gagal di-upload, tapi registrasi tetap dilanjutkan",
          icon: Icons.warning,
        );
      }

      await registerAccount(uploadedUrls);
      print("Registration successful.");
    } catch (e) {
      print("Error registering account: $e");
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal melakukan registrasi, silakan coba lagi.",
        icon: Icons.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerAccount(List<String> uploadedUrls) async {
    try {
      if (dataArgumentsParamPost.isEmpty) {
        Map<String, String> uploadedFileUrls = {};
        int i = 0;
        pickedImages.forEach((key, xfile) {
          if (xfile != null) {
            if (i < uploadedUrls.length) {
              uploadedFileUrls[key] = uploadedUrls[i];
              i++;
            } else {
              uploadedFileUrls[key] = '';
            }
          }
        });

        String? uploadedSupportingDocument =
            uploadedFileUrls['supporting_documents_url'];

        paramPost = {
          "name": namaLengkapC.text,
          "email": emailC.text,
          "gender": selectedJenisKelamin.value == '-'
              ? 'male'
              : selectedJenisKelamin.value,
          "date_of_birth": pickedDate.value,
          "id_cards": uploadedFileUrls.entries
              .where((e) => e.key != 'supporting_documents_url')
              .map((e) => e.value)
              .toList(),
          "supporting_documents_url": uploadedSupportingDocument,
          "phone_number": nomorTelpC.text,
          "emergency_phone_number": nomorDaruratC.text,
          "password": passwordC.text,
          "role": selectedRole.value,
          "referral_code":
              referralCodeC.text.isEmpty ? null : referralCodeC.text,
        };
      } else {
        Map<String, String> uploadedFileUrls = {};
        int i = 0;
        pickedImages.forEach((key, xfile) {
          if (xfile != null) {
            uploadedFileUrls[key] = uploadedUrls[i];
            i++;
          }
        });
        String? uploadedSupportingDocument =
            uploadedFileUrls['supporting_documents_url'];

        paramPost = {
          ...dataArgumentsParamPost,
          "new_customer": {
            "name": namaLengkapC.text,
            "email": emailC.text,
            "gender": selectedJenisKelamin.value == '-'
                ? 'male'
                : selectedJenisKelamin.value,
            "date_of_birth": pickedDate.value,
            "id_cards": uploadedFileUrls.entries
                .where((e) => e.key != 'supporting_documents_url')
                .map((e) => e.value)
                .toList(),
            "supporting_documents_url": uploadedSupportingDocument,
            "phone_number": nomorTelpC.text,
            "emergency_phone_number": nomorDaruratC.text,
            "password": passwordC.text,
            "role": selectedRole.value,
            "referral_code":
                referralCodeC.text.isEmpty ? null : referralCodeC.text,
          },
        };
      }

      var response = await APIService().post(
          "${dataArgumentsParamPost.isEmpty ? '/auth/register' : '/orders/customer'}",
          paramPost);

      if (response != null) {
        if (dataArgumentsParamPost.isNotEmpty) {
          NotificationService().showNotification(
              title:
                  'Registrasi Akun Serta Pemesanan Sewa Kendaraan Berhasil Dilakukan',
              body:
                  'Terima kasih telah mendaftar di sistem Transgo! Saat ini, akun dan sewa kendaraan Anda sedang dalam proses verifikasi oleh tim admin kami. Kami menghargai kesabaran Anda selama proses ini.');
          showModalBottomSheet(
            context: Get.context!,
            builder: (context) {
              return ModalBerhasilDaftar();
            },
          );
        } else {
          NotificationService().showNotification(
              title: 'Selamat! Akun Anda telah diregistrasi! 🎉',
              body:
                  'Terima kasih telah mendaftar di sistem Transgo! Saat ini, akun Anda sedang dalam proses verifikasi oleh tim admin kami. Kami menghargai kesabaran Anda selama proses ini.');
          showModalBottomSheet(
            context: Get.context!,
            builder: (context) {
              return ModalBerhasilDaftar();
            },
          );
        }
      }
    } catch (e) {
      print("Error saat mendaftar akun: $e");
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Gagal melakukan registrasi, silakan coba lagi.",
          icon: Icons.error);
    } finally {
      isLoading.value = false;
    }
  }

  void initRoleByItem({
    required bool isFleetItem,
    required bool isProductItem,
  }) {
    if (selectedRole.value.isNotEmpty) return;

    if (isFleetItem) {
      selectedRole.value = 'customer';
    } else if (isProductItem) {
      selectedRole.value = 'product_customer';
    }
  }

  Future<void> registerWithGoogle() async {
    // Check if running on iOS
    if (Platform.isIOS) {
      CustomSnackbar.show(
        title: "Fitur Belum Tersedia",
        message: "Daftar dengan Google belum tersedia untuk iOS. Silakan gunakan formulir pendaftaran biasa.",
        icon: Icons.info_outline,
        backgroundColor: Colors.orange,
      );
      return;
    }

    isLoadingGoogle.value = true;

    try {
      // Sign in with Google
      final googleUser = await GoogleSignInService.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoadingGoogle.value = false;
        return;
      }

      // Prefill email and name from Google account
      emailC.text = googleUser['email'] ?? '';
      namaLengkapC.text = googleUser['name'] ?? '';

      // Show message that user still needs to fill required fields
      CustomSnackbar.show(
        title: "Data Google Berhasil Dimuat",
        message: "Email dan nama telah diisi. Silakan lengkapi data yang masih diperlukan.",
        icon: Icons.check_circle,
        backgroundColor: Colors.green,
      );

      // Trigger validation to update UI
      validateInput();
    } catch (e) {
      print('Error signing in with Google: $e');
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal memuat data dari Google. Silakan coba lagi.",
        icon: Icons.error,
      );
    } finally {
      isLoadingGoogle.value = false;
    }
  }
}

typedef CompressAndAddImage = Future<void> Function(XFile file);
typedef ValidateInput = void Function();

Future<void> pickImage({
  required String title,
  required ImageSource source,
  required RxBool isLoading,
  required RxMap<String, XFile?> pickedImages,
  required String type,
  required CompressAndAddImage compressAndAddImage,
  required ValidateInput validateInput,
}) async {
  final picker = ImagePicker();

  try {
    isLoading.value = true;

    if (source == ImageSource.gallery) {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        await compressAndAddImage(pickedFile);
        print("Gambar untuk $type berhasil ditambahkan dari galeri.");
        validateInput();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 500), () {
          Get.dialog(DialogSuccessUploadRegister(
            kategori: title.toString(),
          ));
        });
      } else {
        print("Tidak ada gambar yang dipilih.");
      }
    } else if (source == ImageSource.camera) {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        await compressAndAddImage(pickedFile);
        print("Gambar untuk $type berhasil diambil dari kamera.");
        validateInput();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 500), () {
          Get.dialog(DialogSuccessUploadRegister(
            kategori: title.toString(),
          ));
        });
      } else {
        print("Tidak ada gambar yang diambil.");
      }
    }
  } catch (e) {
    print("Error picking image ($type): $e");
  } finally {
    isLoading.value = false;
  }
}

typedef OnImageCompressed = void Function(XFile compressedImage);

Future<void> compressAndAddImage({
  required XFile file,
  required OnImageCompressed onImageCompressed,
  int maxSizeKB = 500,
  int maxWidth = 1000,
  int minWidth = 100,
}) async {
  try {
    final File originalFile = File(file.path);
    int originalSize = await originalFile.length();
    print(
        "Ukuran sebelum kompresi: ${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB");

    Uint8List imageBytes = await originalFile.readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      print("Gagal mendekode gambar.");
      return;
    }

    int targetWidth =
        decodedImage.width > maxWidth ? maxWidth : decodedImage.width;
    img.Image resizedImage = img.copyResize(decodedImage, width: targetWidth);

    int quality = 80;
    Uint8List compressedBytes =
        Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));

    while (compressedBytes.length > maxSizeKB * 1024 && quality > 10) {
      quality -= 10;
      compressedBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
    }

    while (compressedBytes.length > maxSizeKB * 1024) {
      int newWidth = (resizedImage.width * 0.8).toInt();
      if (newWidth < minWidth) break;
      resizedImage = img.copyResize(resizedImage, width: newWidth);
      compressedBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
    }

    final Directory tempDir = await getTemporaryDirectory();
    final File compressedFile = File("${tempDir.path}/${file.name}");
    await compressedFile.writeAsBytes(compressedBytes);

    final int compressedSize = await compressedFile.length();
    print(
        "Ukuran setelah kompresi: ${(compressedSize / 1024).toStringAsFixed(2)} KB (Kualitas akhir: $quality%)");

    onImageCompressed(XFile(compressedFile.path));
  } catch (e) {
    print("Error saat mengompresi gambar: $e");
  }
}
