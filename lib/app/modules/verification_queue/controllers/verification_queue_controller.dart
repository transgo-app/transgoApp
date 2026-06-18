import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/data.dart';
import '../../../routes/app_pages.dart';

class VerificationQueueController extends GetxController {
  RxInt timeLeft = 900.obs; // 15 minutes in seconds
  RxBool isOutsideHours = false.obs;
  RxBool hasPendingOrder = false.obs;
  RxBool isLoading = false.obs;

  Timer? _countdownTimer;
  Timer? _statusPollTimer;

  @override
  void onInit() {
    super.onInit();
    checkWorkingHours();
    checkPendingOrders();
    checkVerificationStatus();

    // Start 1-second countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkWorkingHours();
      if (isOutsideHours.value) {
        // Freeze countdown during off-hours (23:00 - 07:00)
        return;
      }
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        timer.cancel();
      }
    });

    // Start 10-second verification status polling timer
    _statusPollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkVerificationStatus();
    });
  }

  void checkWorkingHours() {
    final currentHour = DateTime.now().hour;
    isOutsideHours.value = currentHour >= 23 || currentHour < 7;
  }

  Future<void> checkPendingOrders() async {
    if (GlobalVariables.token.value.isEmpty) return;
    try {
      final pendingRes = await APIService().get('/orders?page=1&limit=1&status=pending', useCache: false);
      final waitingRes = await APIService().get('/orders?page=1&limit=1&status=waiting', useCache: false);
      final pendingCount = (pendingRes['items'] as List?)?.length ?? 0;
      final waitingCount = (waitingRes['items'] as List?)?.length ?? 0;
      hasPendingOrder.value = pendingCount > 0 || waitingCount > 0;
    } catch (e) {
      debugPrint('Error checking pending orders in queue: $e');
    }
  }

  Future<void> checkVerificationStatus() async {
    if (GlobalVariables.token.value.isEmpty) return;
    try {
      final data = await APIService().get('/auth', useCache: false);
      if (data != null && data['user'] != null) {
        final dataUser = data['user'];
        final status = (dataUser['status'] as String? ?? '').trim().toLowerCase();
        
        GlobalVariables.statusVerificationAccount.value = dataUser['status'] ?? '';
        GlobalVariables.additional_data_status.value = dataUser['additional_data_status'] ?? '';

        // If user is verified, redirect them out of the queue screen
        if (status != 'pending' && status != 'rejected' && status != 'pending_verification') {
          _countdownTimer?.cancel();
          _statusPollTimer?.cancel();
          Get.offAllNamed(Routes.DEFAULT);
        }
      }
    } catch (e) {
      debugPrint('Error polling user verification status: $e');
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      _countdownTimer?.cancel();
      _statusPollTimer?.cancel();
      await GlobalVariables.resetData();
      Get.offAllNamed(Routes.Login);
    } catch (e) {
      debugPrint('Error logging out from queue screen: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _statusPollTimer?.cancel();
    super.onClose();
  }
}
