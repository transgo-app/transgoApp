import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:transgomobileapp/app/data/helper/Storage_helper.dart';
import 'package:transgomobileapp/app/widget/Dialog/DialogSuccessUploadRegister.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBerhasilDaftar.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../services/google_auth_service.dart';
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

  // Argumen dari berbagai entry point (detail sewa, login Google, dll)
  var dataArgumentsParamPost = Get.arguments?['paramPost'] ?? {};
  var dataArgumentsDetailKendaraan = Get.arguments?['detailKendaraan'];
  var dataArgumentsPrefillFromGoogle = Get.arguments?['prefillFromGoogle'];

  RxBool isLoading = false.obs;
  RxBool isUploadFile = false.obs;
  RxBool isEmailVerified = false.obs;
  RxBool isOtpSent = false.obs;
  RxBool isSendingRegisterOtp = false.obs;
  RxString emailVerificationToken = ''.obs;
  RxString emailValue = ''.obs;
  RxInt emailResendCount = 0.obs;
  RxInt emailResendCooldownSeconds = 0.obs;
  Timer? _emailCooldownTimer;
  String _lastEmailValue = '';

  final TextEditingController emailOtpController = TextEditingController();

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
      if (isEmailVerified.value) {
        errorTextEmail.value = '';
      } else {
        if (!isOtpSent.value) {
          errorTextEmail.value = 'Klik "Verifikasi" dulu';
          isValid = false;
        } else if (emailOtpController.text.trim().replaceAll(RegExp(r'[^0-9]'), '').length != 6) {
          errorTextEmail.value = 'Masukkan OTP 6 digit';
          isValid = false;
        } else {
          errorTextEmail.value = '';
        }
      }
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

  bool _looksLikeEmail(String value) {
    final v = value.trim().toLowerCase();
    return v.length >= 5 && v.contains('@') && v.contains('.');
  }

  String _normalizedEmail() {
    return emailC.text.trim().toLowerCase();
  }

  void _resetEmailVerificationState() {
    isEmailVerified.value = false;
    isOtpSent.value = false;
    emailVerificationToken.value = '';
    emailOtpController.text = '';
    emailResendCount.value = 0;
    emailResendCooldownSeconds.value = 0;
    _emailCooldownTimer?.cancel();
    _emailCooldownTimer = null;
  }

  void _startEmailCooldown() {
    _emailCooldownTimer?.cancel();
    emailResendCooldownSeconds.value = 60;
    _emailCooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (emailResendCooldownSeconds.value <= 1) {
        emailResendCooldownSeconds.value = 0;
        t.cancel();
        return;
      }
      emailResendCooldownSeconds.value = emailResendCooldownSeconds.value - 1;
    });
  }

  Future<void> sendRegisterEmailOtp() async {
    final email = _normalizedEmail();
    if (!_looksLikeEmail(email)) {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Email tidak valid",
        icon: Icons.mail_outline,
      );
      return;
    }

    if (isSendingRegisterOtp.value) return;
    isSendingRegisterOtp.value = true;

    try {
      // Sending a new OTP invalidates previous verification/OTP input.
      isEmailVerified.value = false;
      emailVerificationToken.value = '';
      isOtpSent.value = false;
      emailOtpController.text = '';

      final res = await APIService().post('/auth/email/register/send-otp', {
        'email': email,
        'name': namaLengkapC.text.trim(),
      });
      if (res is! Map) {
        _resetEmailVerificationState();
        validateInput();
        return;
      }
      _startEmailCooldown();
      isOtpSent.value = true;
      validateInput();
      CustomSnackbar.show(
        title: "Berhasil",
        message: "Kode verifikasi sudah dikirim ke email kamu",
        icon: Icons.check,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      print("Error sendRegisterEmailOtp: $e");
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal mengirim kode verifikasi, coba lagi ya.",
        icon: Icons.error,
        backgroundColor: Colors.red,
      );
      _resetEmailVerificationState();
      validateInput();
    } finally {
      isSendingRegisterOtp.value = false;
    }
  }

  Future<void> resendRegisterEmailOtp() async {
    if (!isOtpSent.value) return;
    if (isSendingRegisterOtp.value) return;
    if (emailResendCooldownSeconds.value > 0) return;
    if (emailResendCount.value >= 5) return;

    // resend count: first send is count 0, resend increments to 1..5
    emailResendCount.value = emailResendCount.value + 1;
    await sendRegisterEmailOtp();
  }

  Future<bool> verifyRegisterEmailOtp(String otp) async {
    final email = _normalizedEmail();
    if (!_looksLikeEmail(email)) return false;

    try {
      final res = await APIService().post('/auth/email/register/verify-otp', {
        'email': email,
        'otp': otp.trim(),
      });

      final token = res?['verification_token']?.toString();
      if (token == null || token.isEmpty) {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Token verifikasi tidak ditemukan, silakan coba lagi.",
          icon: Icons.error,
          backgroundColor: Colors.red,
        );
        return false;
      }

      emailVerificationToken.value = token;
      isEmailVerified.value = true;
      isOtpSent.value = false;
      emailOtpController.text = '';
      // Once verified, reset resend counters.
      emailResendCount.value = 0;
      emailResendCooldownSeconds.value = 0;
      _emailCooldownTimer?.cancel();
      _emailCooldownTimer = null;

      validateInput();
      return true;
    } catch (e) {
      print("Error verifyRegisterEmailOtp: $e");
      CustomSnackbar.show(
        title: "Kode salah / kedaluwarsa",
        message: "Silakan coba lagi atau kirim ulang kodenya.",
        icon: Icons.error,
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<void> prefillRegisterFromGoogle() async {
    try {
      final account = await GoogleAuthService.instance
          .signIn(forceAccountSelection: true);
      if (account == null) {
        // User batal memilih akun atau terjadi error, diam saja sesuai requirement.
        return;
      }

      namaLengkapC.text = account.displayName ?? '';
      emailC.text = account.email;

      // Biarkan field lain (termasuk password) tetap kosong dan tetap bisa diedit.

      CustomSnackbar.show(
        title: "Berhasil",
        message:
            "Data dari Google berhasil diambil, silakan lengkapi data lainnya.",
        icon: Icons.check,
        backgroundColor: Colors.green,
      );

      validateInput();
    } catch (e) {
      print('Error prefill register from Google: $e');
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal mengambil data dari Google. Silakan coba lagi.",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Prefill dari login Google (jika ada)
    if (dataArgumentsPrefillFromGoogle != null) {
      final name = dataArgumentsPrefillFromGoogle['name'] as String? ?? '';
      final email = dataArgumentsPrefillFromGoogle['email'] as String? ?? '';

      if (name.isNotEmpty) {
        namaLengkapC.text = name;
      }
      if (email.isNotEmpty) {
        emailC.text = email;
      }
    }

    emailValue.value = emailC.text;
    _lastEmailValue = emailC.text;
    emailC.addListener(() {
      emailValue.value = emailC.text;
      final current = emailC.text;
      if (current != _lastEmailValue) {
        _lastEmailValue = current;
        _resetEmailVerificationState();
      }
      validateInput();
    });

    emailOtpController.addListener(() {
      // Keep button state in sync with OTP input.
      validateInput();
    });

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
        isLoading.value = false;
        return;
      }

      // transgoApp uses register-partner endpoint (no captcha required)
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
          pickedImages: files,
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
      final normalizedEmail = _normalizedEmail();

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
          "email": normalizedEmail,
          "email_verification_token": emailVerificationToken.value.isEmpty
              ? null
              : emailVerificationToken.value,
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
          "created_with": "application",
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
            "email": normalizedEmail,
            "email_verification_token": emailVerificationToken.value.isEmpty
                ? null
                : emailVerificationToken.value,
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
          "created_with": "application",
        };
      }

      var response = await APIService().post(
          "${dataArgumentsParamPost.isEmpty ? '/auth/register-partner' : '/orders/customer'}",
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

  @override
  void onClose() {
    _emailCooldownTimer?.cancel();
    emailOtpController.dispose();
    super.onClose();
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
    Uint8List imageBytes = await file.readAsBytes();
    int originalSize = imageBytes.length;
    print(
        "Ukuran sebelum kompresi: ${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB");
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

    Directory tempDir;
    try {
      tempDir = await getTemporaryDirectory();
    } catch (_) {
      tempDir = Directory.systemTemp;
    }
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
