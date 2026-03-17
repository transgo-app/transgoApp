import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:transgomobileapp/app/data/helper/SharedPrefsHelper.dart';
import 'package:transgomobileapp/app/data/helper/AppPrefs.dart';
import 'package:transgomobileapp/app/data/service/NotificationService.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class ProfileController extends GetxController {
  final count = 0.obs;
  RxString namaUser = 'Selamat Datang di Transgo!'.obs;
  RxString emailUser = 'Layanan Rental Mobil & Motor Terbaik untuk Anda'.obs;
  RxInt userId = 0.obs;

  TextEditingController namaUserC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nomorTelpC = TextEditingController();
  TextEditingController nomorDaruratC = TextEditingController();
  TextEditingController jenisKelaminC = TextEditingController();
  TextEditingController tanggalLahirC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  /// OTP verification
  final TextEditingController otpController = TextEditingController();
  final RxInt resendCooldownSec = 0.obs;
  final RxBool isSendingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;
  Timer? _cooldownTimer;
  static const int _resendCooldownSeconds = 90;

  RxString jenisKelamin = ''.obs;
  RxString tanggalLahir = ''.obs;
  RxList detailFileUser = [].obs;
  RxList idCards = [].obs;
  RxList additionalData = [].obs;
  RxString dataUserTeks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDetailUser();
    getCheckAdditional();
  }

  Future<void> getDetailUser() async {
    try {
      var data = await APIService().get('/auth');
      var dataUser = data['user'];
      print('ini response auth ${data}');
      await saveUserDataToPrefs(dataUser, data, tokenKey: 'token');
      userId.value = dataUser['id'];
      print("INI DATA USER ${dataUser['id'].runtimeType}");
      namaUserC.text = GlobalVariables.namaUser.value;
      emailC.text = GlobalVariables.emailUser.value;
      nomorTelpC.text = dataUser['phone_number'] ?? '';
      nomorDaruratC.text = dataUser['emergency_phone_number'] ?? dataUser['phone_number'] ?? '';
      jenisKelaminC.text = GlobalVariables.jenisKelamin.value;
      tanggalLahirC.text = GlobalVariables.tanggalLahir.value; 
      nikC.text = dataUser['nik'] ?? '';

      GlobalVariables.additional_data_status.value = dataUser['additional_data_status'];
      GlobalVariables.statusVerificationAccount.value = dataUser['status'];
      GlobalVariables.isEmailVerified.value = dataUser['email_verified'] == true;
      if (!GlobalVariables.isEmailVerified.value) {
        _maybeScheduleEmailVerificationReminder();
      }

      if (GlobalVariables.idCards.isNotEmpty) {
        idCards.value = jsonDecode(GlobalVariables.idCards.value);
      }
      additionalData.value = dataUser['additional_data'];
      dataUserTeks.value = dataUser.toString();
    } catch (e) {
      print('Error: $e');
    } finally {}
  }


  Future<void> getCheckAdditional() async {
    try {
      var data = await APIService().get('/customers/status/additional');
      print('butuh data tambahan ga $data');
      GlobalVariables.statusAccount.value = data['message'];
      GlobalVariables.hexStatusAccount.value = data['hexcolor'];
      GlobalVariables.isShowStatusAccount.value = data['show_card'];
      GlobalVariables.isNeedAdditionalData.value = data['need_verification'];
    } catch (e) {
      print('Error: $e');
  } finally {}
  }

  /// Schedules a local "email belum diverifikasi" reminder at a long interval (e.g. 24h).
  /// Only schedules if last schedule was long ago to avoid spam.
  Future<void> _maybeScheduleEmailVerificationReminder() async {
    try {
      final prefs = await getAppPrefs();
      const key = 'last_email_verification_reminder_scheduled_at';
      final lastStr = prefs.getString(key);
      final lastMs = int.tryParse(lastStr ?? '') ?? 0;
      const intervalHours = 24;
      if (DateTime.now().millisecondsSinceEpoch - lastMs < intervalHours * 60 * 60 * 1000) {
        return;
      }
      await NotificationService().scheduleEmailVerificationReminder();
      await prefs.setString(key, DateTime.now().millisecondsSinceEpoch.toString());
    } catch (_) {}
  }

  /// Sends email verification OTP. Returns true if success (caller can then show OTP modal).
  Future<bool> sendEmailOtp() async {
    if (isSendingOtp.value) return false;
    isSendingOtp.value = true;
    try {
      await APIService().post('/auth/email/send-otp', {});
      resendCooldownSec.value = _resendCooldownSeconds;
      _startCooldownTimer();
      CustomSnackbar.show(
        title: 'Email dikirim',
        message: 'Kode OTP telah dikirim ke email Anda. Cek inbox atau folder spam.',
        icon: Icons.email_outlined,
        backgroundColor: Colors.orange,
      );
      return true;
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal mengirim OTP',
        message: e.toString().replaceFirst('Exception: ', ''),
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isSendingOtp.value = false;
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (resendCooldownSec.value > 0) {
        resendCooldownSec.value--;
      } else {
        _cooldownTimer?.cancel();
      }
    });
  }

  /// Resend OTP (respects cooldown).
  Future<void> resendEmailOtp() async {
    if (resendCooldownSec.value > 0 || isSendingOtp.value) return;
    await sendEmailOtp();
  }

  /// Verify email with OTP. Call Get.back() on success to close modal.
  Future<void> verifyEmailOtp() async {
    final otp = otpController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (otp.length != 6) {
      CustomSnackbar.show(
        title: 'Kode tidak valid',
        message: 'Masukkan 6 digit kode OTP.',
        icon: Icons.warning_amber_outlined,
        backgroundColor: Colors.orange,
      );
      return;
    }
    if (isVerifyingOtp.value) return;
    isVerifyingOtp.value = true;
    try {
      await APIService().post('/auth/email/verify-otp', {'otp': otp});
      await getDetailUser();
      Get.back();
      otpController.clear();
      CustomSnackbar.show(
        title: 'Email terverifikasi',
        message: 'Terima kasih, email Anda sudah terverifikasi.',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Verifikasi gagal',
        message: e.toString().replaceFirst('Exception: ', ''),
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();
    otpController.dispose();
    super.onClose();
  }

   Future<void> requestDeleteAccount() async {
    try {
      var data = await APIService().put('/orders/request-delete/${userId.value}', {});
      print("INI DATA $data");
    } catch (e) {
      print('Error: $e');
    } finally {}
  }
}
