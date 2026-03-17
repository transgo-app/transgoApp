import 'package:get/get.dart';
import 'package:transgomobileapp/app/data/helper/AppPrefs.dart';
import 'package:transgomobileapp/app/data/service/LocationTrackingService.dart';

class GlobalVariables {
  static RxString userId = 'Selamat Datang'.obs;
  static RxString namaUser = 'Selamat Datang'.obs;
  static RxString emailUser =
      'Kami menawarkan berbagai layanan sewa mobil & motor yang fleksibel dan nyaman, siap memenuhi kebutuhan perjalanan Anda.'
          .obs;
  static RxString token = ''.obs;
  static RxString fcmToken = ''.obs;
  static RxString nomorTelepon = ''.obs;
  static RxString nomorDarurat = ''.obs;
  static RxString jenisKelamin = ''.obs;
  static RxString tanggalLahir = ''.obs;
  static RxString idCards = ''.obs;
  static RxString statusAccount = ''.obs;
  static RxString statusVerificationAccount = ''.obs;
  static RxString hexStatusAccount = ''.obs;
  static RxBool isNeedAdditionalData = false.obs;
  static RxBool isShowStatusAccount = false.obs;
  static RxString additional_data_status = ''.obs;
  /// True if user has verified their email via OTP; false or null from API = not verified.
  static RxBool isEmailVerified = true.obs;

  static Future<void> initializeData() async {
    final prefs = await getAppPrefs();
    namaUser.value = prefs.getString('namaUser') ?? 'Selamat Datang';
    emailUser.value = prefs.getString('emailUser') ??
        'Kami menawarkan berbagai layanan sewa mobil & motor yang fleksibel dan nyaman, siap memenuhi kebutuhan perjalanan Anda.';
    token.value = prefs.getString('accessToken') ?? '';
    nomorTelepon.value = prefs.getString('noTelp') ?? '';
    nomorDarurat.value = prefs.getString('noTelpDarurat') ?? '';
    jenisKelamin.value = prefs.getString('jenisKelamin') ?? '';
    tanggalLahir.value = prefs.getString('tanggalLahir') ?? '';
    idCards.value = prefs.getString('idCards') ?? '';
  }

  Future<bool> isLoggedIn() async {
    final prefs = await getAppPrefs();
    String? token = prefs.getString('accessToken');

    return token != null && token.isNotEmpty;
  }

  static Future<void> resetData() async {
    // Stop customer location tracking when user logs out
    try {
      LocationTrackingService.instance.stop();
    } catch (_) {}

    final prefs = await getAppPrefs();

    await prefs.remove('namaUser');
    await prefs.remove('emailUser');
    await prefs.remove('accessToken');
    await prefs.remove('noTelp');
    await prefs.remove('noTelpDarurat');
    await prefs.remove('jenisKelamin');
    await prefs.remove('tanggalLahir');
    await prefs.remove('idCards');

    namaUser.value = 'Selamat Datang';
    emailUser.value = 'Selalu ingat transgo solusi mobil & motor termurah';
    token.value = '';
    nomorTelepon.value = '';
    nomorDarurat.value = '';
    jenisKelamin.value = '';
    tanggalLahir.value = '';
    idCards.value = '';
    statusAccount = ''.obs;
    hexStatusAccount = ''.obs;
    isNeedAdditionalData = false.obs;
    isShowStatusAccount = false.obs;
    additional_data_status = ''.obs;
    isEmailVerified.value = true;
  }
}
