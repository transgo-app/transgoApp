import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/data.dart';
import '../../../routes/app_pages.dart';

class VerificationQueueController extends GetxController {
  RxInt timeLeft = 900.obs; // Default to 15 minutes in seconds
  RxBool isOutsideHours = false.obs;
  RxBool hasPendingOrder = false.obs;
  RxBool isLoading = false.obs;
  RxInt queuePosition = 0.obs;
  RxInt maxMinutes = 15.obs;
  RxInt baseMinutes = 15.obs;
  RxBool isOvertime = false.obs;
  RxString queueStartTimeStr = ''.obs;
  RxBool isAccountVerified = false.obs;
  RxMap activeOrderData = {}.obs;

  Timer? _countdownTimer;
  Timer? _statusPollTimer;

  @override
  void onInit() {
    super.onInit();
    checkWorkingHours();
    checkPendingOrders();
    checkVerificationStatus();

    // Start 1-second countdown timer utilizing real-time calculated offsets
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCountdown();
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

  int calculateActiveElapsedSeconds(int createdAtMs, int nowMs) {
    int totalActiveSeconds = 0;
    int currentMs = createdAtMs;
    const stepMs = 60 * 1000; // Step minute-by-minute

    while (currentMs + stepMs <= nowMs) {
      final dateObj = DateTime.fromMillisecondsSinceEpoch(currentMs);
      final hour = dateObj.hour;
      final isOutside = hour >= 23 || hour < 7;
      if (!isOutside) {
        totalActiveSeconds += 60;
      }
      currentMs += stepMs;
    }

    if (currentMs < nowMs) {
      final dateObj = DateTime.fromMillisecondsSinceEpoch(currentMs);
      final hour = dateObj.hour;
      final isOutside = hour >= 23 || hour < 7;
      if (!isOutside) {
        totalActiveSeconds += (nowMs - currentMs) ~/ 1000;
      }
    }
    return totalActiveSeconds;
  }

  void updateCountdown() {
    checkWorkingHours();
    if (isOutsideHours.value) {
      // Freeze countdown during off-hours (23:00 - 07:00)
      return;
    }

    if (queueStartTimeStr.value.isEmpty) {
      timeLeft.value = maxMinutes.value * 60;
      isOvertime.value = false;
      return;
    }

    final dateStr = queueStartTimeStr.value.contains('Z') || queueStartTimeStr.value.contains('+') 
        ? queueStartTimeStr.value 
        : '${queueStartTimeStr.value}Z';
    
    // Parse UTC to milliseconds, adding 7 hours to align with server timezone logic
    final parsedDate = DateTime.parse(dateStr).toUtc();
    final createdAtMs = parsedDate.millisecondsSinceEpoch + 7 * 3600 * 1000;
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final totalActiveSeconds = calculateActiveElapsedSeconds(createdAtMs, nowMs);

    int currentWaitingMinutes = baseMinutes.value;

    // Overtime check: If active elapsed seconds exceed the limit, add 15 minutes blocks
    if (totalActiveSeconds >= currentWaitingMinutes * 60) {
      final extraSeconds = totalActiveSeconds - (currentWaitingMinutes * 60);
      final extraBlocks = extraSeconds ~/ (15 * 60) + 1;
      currentWaitingMinutes += extraBlocks * 15;
      isOvertime.value = true;
    } else {
      isOvertime.value = false;
    }

    final calculatedTimeLeft = (currentWaitingMinutes * 60) - totalActiveSeconds;
    timeLeft.value = calculatedTimeLeft > 0 ? calculatedTimeLeft : 0;
    maxMinutes.value = currentWaitingMinutes;
  }

  Future<void> checkPendingOrders() async {
    if (GlobalVariables.token.value.isEmpty) return;
    try {
      final pendingRes = await APIService().get('/orders?page=1&limit=1&status=pending', useCache: false);
      final waitingRes = await APIService().get('/orders?page=1&limit=1&status=waiting', useCache: false);
      
      final pendingItems = pendingRes['items'] as List?;
      final waitingItems = waitingRes['items'] as List?;
      
      final pendingCount = pendingItems?.length ?? 0;
      final waitingCount = waitingItems?.length ?? 0;
      hasPendingOrder.value = pendingCount > 0 || waitingCount > 0;
      
      if (hasPendingOrder.value) {
        final activeOrder = pendingCount > 0 ? pendingItems!.first : waitingItems!.first;
        activeOrderData.value = Map<String, dynamic>.from(activeOrder);
        
        // Populate real-time queue details from the active order
        queuePosition.value = activeOrder['queue_position'] ?? 1;
        final queueWaitingTime = activeOrder['queue_waiting_time'] ?? 15;
        baseMinutes.value = queueWaitingTime;
        maxMinutes.value = queueWaitingTime;
        
        final customerStatus = activeOrder['customer']?['status'] ?? '';
        final customerCreatedAt = activeOrder['customer']?['created_at']?.toString() ?? '';
        final orderCreatedAt = activeOrder['created_at']?.toString() ?? '';
        
        queueStartTimeStr.value = customerStatus == 'pending' ? customerCreatedAt : orderCreatedAt;
        updateCountdown();
      } else {
        activeOrderData.clear();
      }
    } catch (e) {
      debugPrint('Error checking pending orders in queue: $e');
    }
  }

  Future<void> fetchQueueData(int userId) async {
    try {
      final res = await APIService().get('/verifikasi/$userId', useCache: false);
      if (res != null) {
        final data = res['data'];
        if (data != null) {
          queuePosition.value = data['queue_position'] ?? 0;
          final queueWaitingTime = data['queue_waiting_time'] ?? 15;
          baseMinutes.value = queueWaitingTime;
          maxMinutes.value = queueWaitingTime;
          queueStartTimeStr.value = data['created_at'] ?? '';
          
          updateCountdown();
        }
      }
    } catch (e) {
      debugPrint('Error fetching verification queue details: $e');
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

        final isVerified = status != 'pending' && status != 'rejected' && status != 'pending_verification';
        isAccountVerified.value = isVerified;

        // If user is verified, redirect them out of the queue screen ONLY if they have no pending orders
        if (isVerified) {
          await checkPendingOrders();
          if (!hasPendingOrder.value) {
            _countdownTimer?.cancel();
            _statusPollTimer?.cancel();
            Get.offAllNamed(Routes.DEFAULT);
            return;
          }
        }

        // Fetch queue details only if there is no pending order
        if (!hasPendingOrder.value) {
          final userId = dataUser['id'];
          if (userId != null) {
            fetchQueueData(userId);
          }
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
