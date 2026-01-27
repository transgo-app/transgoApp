import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/data/helper/SharedPrefsHelper.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';

class DetailuserController extends GetxController {
  // true = Data Pribadi, false = Dokumen Pribadi
  final bool detailPribadi = Get.arguments is bool ? Get.arguments as bool : true;

  final ProfileController profileController = Get.find<ProfileController>();

  RxBool canSave = false.obs;
  RxBool isSaving = false.obs;
  RxString selectedGender = ''.obs;

  late Map<String, String> _initialValues;

  @override
  void onInit() {
    super.onInit();

    _initialValues = {
      'name': profileController.namaUserC.text,
      'email': profileController.emailC.text,
      'phone_number': profileController.nomorTelpC.text,
      'emergency_phone_number': profileController.nomorDaruratC.text,
      'gender': profileController.jenisKelaminC.text,
      'date_of_birth': profileController.tanggalLahirC.text,
      'nik': profileController.nikC.text,
    };

    selectedGender.value = profileController.jenisKelaminC.text;

    void listener() {
      canSave.value = _hasChanges();
    }

    profileController.namaUserC.addListener(listener);
    profileController.emailC.addListener(listener);
    profileController.nomorTelpC.addListener(listener);
    profileController.nomorDaruratC.addListener(listener);
    profileController.jenisKelaminC.addListener(listener);
    profileController.tanggalLahirC.addListener(listener);
    profileController.nikC.addListener(listener);
    profileController.passwordC.addListener(listener);
    profileController.confirmPasswordC.addListener(listener);
  }

  bool _hasChanges() {
    if (profileController.namaUserC.text != _initialValues['name']) return true;
    if (profileController.emailC.text != _initialValues['email']) return true;
    if (profileController.nomorTelpC.text != _initialValues['phone_number']) return true;
    if (profileController.nomorDaruratC.text != _initialValues['emergency_phone_number']) return true;
    if (profileController.jenisKelaminC.text != _initialValues['gender']) return true;
    if (profileController.tanggalLahirC.text != _initialValues['date_of_birth']) return true;
    if (profileController.nikC.text != _initialValues['nik']) return true;
    if (profileController.passwordC.text.isNotEmpty ||
        profileController.confirmPasswordC.text.isNotEmpty) return true;
    return false;
  }

  Future<void> saveDataPribadi() async {
    if (!canSave.value || isSaving.value) return;

    final nik = profileController.nikC.text.trim();
    if (nik.isNotEmpty && (nik.length != 16 || int.tryParse(nik) == null)) {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "NIK harus terdiri dari 16 digit angka.",
        backgroundColor: Colors.red,
      );
      return;
    }

    final newPassword = profileController.passwordC.text;
    final confirmPassword = profileController.confirmPasswordC.text;
    if (newPassword.isNotEmpty || confirmPassword.isNotEmpty) {
      if (newPassword != confirmPassword) {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Konfirmasi password tidak sesuai.",
          backgroundColor: Colors.red,
        );
        return;
      }
    }

    final body = <String, dynamic>{
      'name': profileController.namaUserC.text.trim(),
      'email': profileController.emailC.text.trim(),
      'phone_number': profileController.nomorTelpC.text.trim(),
      'emergency_phone_number': profileController.nomorDaruratC.text.trim(),
      'gender': profileController.jenisKelaminC.text.trim().isEmpty
          ? null
          : profileController.jenisKelaminC.text.trim(),
      'date_of_birth': profileController.tanggalLahirC.text.trim().isEmpty
          ? null
          : profileController.tanggalLahirC.text.trim(),
      'nik': nik,
    };

    if (newPassword.isNotEmpty) {
      body['password'] = newPassword;
    }

    // Buang field yang null atau kosong (kecuali yang wajib)
    final requiredKeys = {'name', 'email', 'phone_number', 'nik'};
    body.removeWhere((key, value) {
      if (requiredKeys.contains(key)) return false;
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    try {
      isSaving.value = true;
      final response = await APIService().patch('/customers/me', body);

      if (response != null && response['data'] != null && response['data']['user'] != null) {
        final dataUser = response['data']['user'];
        await saveUserDataToPrefs(dataUser, response, tokenKey: 'data.token');
        await GlobalVariables.initializeData();

        // Reset initial values & password fields
        _initialValues = {
          'name': profileController.namaUserC.text,
          'email': profileController.emailC.text,
          'phone_number': profileController.nomorTelpC.text,
          'emergency_phone_number': profileController.nomorDaruratC.text,
          'gender': profileController.jenisKelaminC.text,
          'date_of_birth': profileController.tanggalLahirC.text,
          'nik': profileController.nikC.text,
        };
        profileController.passwordC.clear();
        profileController.confirmPasswordC.clear();
        canSave.value = false;

        CustomSnackbar.show(
          title: "Berhasil",
          message: "Data pribadi berhasil diperbarui.",
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal menyimpan data. Pastikan NIK, email, atau nomor telepon tidak digunakan akun lain.",
        backgroundColor: Colors.red,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
