import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class TgPayController extends GetxController {
  // Tab management
  final PageController pageController = PageController();
  RxInt currentTabIndex = 0.obs;

  // Balance
  RxDouble balance = 0.0.obs;
  RxBool isLoadingBalance = false.obs;
  RxBool isLoadingMethods = false.obs;
  
  // User ID (fetched from auth endpoint)
  RxInt userId = 0.obs;
  RxBool isSubmittingTopup = false.obs;

  // Top Up Form
  RxString selectedAmount = ''.obs;
  RxString customAmount = ''.obs;
  RxString selectedPaymentMethod = 'QRIS'.obs; // 'QRIS' or 'VIRTUAL_ACCOUNT'
  RxString selectedBank = ''.obs;

  // Predefined amounts
  final List<int> predefinedAmounts = [
    10000,
    25000,
    50000,
    100000,
    250000,
    500000,
    1000000,
    2500000,
    5000000,
  ];

  // Payment method config (from /payments/methods)
  RxBool qrEnabled = true.obs;
  RxBool vaEnabled = true.obs;
  RxInt qrMinAmount = 1000.obs;
  RxInt qrMaxAmount = 9999999999.obs;
  RxInt vaMinAmount = 10000.obs;
  RxInt vaMaxAmount = 9999999999.obs;

  // Available banks for Virtual Account (populated from API)
  final RxList<Map<String, String>> availableBanks = <Map<String, String>>[].obs;

  // Current topup session
  Rxn<Map<String, dynamic>> lastTopup = Rxn<Map<String, dynamic>>();
  String? lastTopupReferenceId; // client_reference_id from payment service
  RxString lastTopupStatus = ''.obs;
  Timer? _statusTimer;
  
  // QR Modal trigger
  Rxn<String> qrImageUrl = Rxn<String>();
  
  // VA Modal trigger
  Rxn<Map<String, String>> vaDetails = Rxn<Map<String, String>>();

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
    fetchPaymentMethods();
    fetchBalance();
  }
  
  Future<void> fetchUserId() async {
    final token = GlobalVariables.token.value;
    if (token.isEmpty) return;
    
    try {
      final data = await APIService().get('/auth');
      final dataUser = data['user'] as Map<String, dynamic>?;
      if (dataUser != null && dataUser['id'] != null) {
        userId.value = dataUser['id'] is int 
            ? dataUser['id'] as int 
            : int.tryParse(dataUser['id'].toString()) ?? 0;
      }
    } catch (e) {
      // Silently fail - user might not be logged in
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _statusTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchPaymentMethods() async {
    if (isLoadingMethods.value) return;

    isLoadingMethods.value = true;
    try {
      final uri = Uri.parse('https://payment.transgo.id/api/v1/payments/methods');

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      // If you eventually require auth, you can add bearer token here
      if (GlobalVariables.token.value.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${GlobalVariables.token.value}';
      }

      final res = await http.get(uri, headers: headers);

      if (res.statusCode != 200) {
        print('Failed to fetch payment methods: ${res.statusCode}');
        return;
      }

      final body = json.decode(res.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        print('Payment methods response missing data field');
        return;
      }

      // QR config
      final qr = data['qr'] as Map<String, dynamic>?;
      if (qr != null) {
        qrEnabled.value = qr['enabled'] == true;
        final min = qr['minimumAmount']?['value'];
        final max = qr['maximumAmount']?['value'];
        if (min is int) qrMinAmount.value = min;
        if (max is int) qrMaxAmount.value = max;
      }

      // VA config
      final va = data['virtualAccount'] as Map<String, dynamic>?;
      if (va != null) {
        vaEnabled.value = va['enabled'] == true;
        final min = va['minimumAmount']?['value'];
        final max = va['maximumAmount']?['value'];
        if (min is int) vaMinAmount.value = min;
        if (max is int) vaMaxAmount.value = max;

        final channels = va['acceptedChannels'] as List<dynamic>? ?? [];

        // Map Pivot bank codes to display names
        final Map<String, String> nameMap = {
          'BCA': 'BCA',
          'BRI': 'BRI',
          'MANDIRI': 'Mandiri',
          'BNI': 'BNI',
          'CIMB': 'CIMB',
          'PERMATA': 'Permata',
          'BSI': 'BSI',
          'BNC': 'BNC',
          'DANAMON': 'Danamon',
        };

        if (channels.isNotEmpty) {
          final banksList = channels.map((c) {
            final code = c.toString();
            return {
              'code': code,
              'name': nameMap[code] ?? code,
            };
          }).toList();
          availableBanks.assignAll(banksList);
          print('Loaded ${availableBanks.length} banks: ${availableBanks.map((b) => b['code']).join(', ')}');
        } else {
          availableBanks.clear();
          print('No VA channels found in API response');
        }

        // Ensure selectedBank is valid
        if (selectedBank.value.isEmpty && availableBanks.isNotEmpty) {
          selectedBank.value = availableBanks.first['code'] ?? '';
        } else if (availableBanks
            .every((bank) => bank['code'] != selectedBank.value)) {
          selectedBank.value =
              availableBanks.isNotEmpty ? availableBanks.first['code'] ?? '' : '';
        }
      }
    } catch (_) {
      // swallow errors for now; UI will just use defaults
    } finally {
      isLoadingMethods.value = false;
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentTabIndex.value = index;
  }

  Future<void> fetchBalance() async {
    if (GlobalVariables.token.value.isEmpty) {
      balance.value = 0.0;
      return;
    }
    
    isLoadingBalance.value = true;
    try {
      final data = await APIService().get('/topup/balance');
      balance.value = (data['balance'] ?? 0).toDouble();
      debugPrint('=== BALANCE FETCHED ===');
      debugPrint('Balance: ${balance.value}');
    } catch (e) {
      debugPrint('Error fetching balance: $e');
      // Keep current balance on error, don't reset to 0
    } finally {
      isLoadingBalance.value = false;
    }
  }

  void selectPredefinedAmount(int amount) {
    selectedAmount.value = amount.toString();
    customAmount.value = '';
    
    // If amount < VA minimum and method is VA, switch to QRIS
    if (amount < vaMinAmount.value &&
        selectedPaymentMethod.value == 'VIRTUAL_ACCOUNT') {
      selectedPaymentMethod.value = 'QRIS';
      selectedBank.value = '';
    }
  }

  void setCustomAmount(String value) {
    // Remove non-numeric characters
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    customAmount.value = numericValue;
    selectedAmount.value = '';
    
    // If amount < VA minimum and method is VA, switch to QRIS
    if (numericValue.isNotEmpty) {
      final amount = int.tryParse(numericValue) ?? 0;
      if (amount < vaMinAmount.value &&
          selectedPaymentMethod.value == 'VIRTUAL_ACCOUNT') {
        selectedPaymentMethod.value = 'QRIS';
        selectedBank.value = '';
      }
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    if (method == 'QRIS') {
      selectedBank.value = '';
    } else if (method == 'VIRTUAL_ACCOUNT' && selectedBank.value.isEmpty && availableBanks.isNotEmpty) {
      selectedBank.value = availableBanks.first['code']!;
    }
  }

  void selectBank(String bankCode) {
    selectedBank.value = bankCode;
  }

  int get currentAmount {
    if (selectedAmount.value.isNotEmpty) {
      return int.tryParse(selectedAmount.value) ?? 0;
    }
    if (customAmount.value.isNotEmpty) {
      return int.tryParse(customAmount.value) ?? 0;
    }
    return 0;
  }

  bool get canSubmitTopup {
    final amount = currentAmount;
    if (amount < qrMinAmount.value) return false;
    if (selectedPaymentMethod.value == 'VIRTUAL_ACCOUNT' && selectedBank.value.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> submitTopup() async {
    if (!canSubmitTopup) return;
    if (isSubmittingTopup.value) return;

    final token = GlobalVariables.token.value;
    if (token.isEmpty) {
      CustomSnackbar.show(
        title: 'Gagal',
        message: 'Silakan login kembali untuk melakukan top up',
      );
      return;
    }

    if (userId.value == 0) {
      // Try to fetch user ID if not available
      await fetchUserId();
      if (userId.value == 0) {
        CustomSnackbar.show(
          title: 'Gagal',
          message: 'User ID tidak valid. Silakan login ulang.',
        );
        return;
      }
    }

    final amount = currentAmount;

    // Map UI method to payment service method
    final method =
        selectedPaymentMethod.value == 'VIRTUAL_ACCOUNT' ? 'VIRTUAL_ACCOUNT' : 'QR';

    // Map bank code to payment channel
    String channel;
    if (method == 'QR') {
      // QRIS uses fixed channel from payment service
      channel = 'ID_QRIS';
    } else {
      // For Virtual Account, use raw bank code from /payments/methods (e.g. BRI, BNI)
      // The payment service will translate this to the correct provider code.
      channel = selectedBank.value;
    }

    final uri = Uri.parse('https://payment.transgo.id/api/v1/payments/topup');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'user_id': userId.value,
      'amount': amount,
      'currency': 'IDR',
      'method': method,
      'channel': channel,
      'name': GlobalVariables.namaUser.value,
      'email': GlobalVariables.emailUser.value,
      'phone': GlobalVariables.nomorTelepon.value,
    });

    isSubmittingTopup.value = true;

    try {
      // Log request details for debugging
      debugPrint('=== TG PAY TOPUP REQUEST ===');
      debugPrint('URL: $uri');
      debugPrint('Method: $method, Channel: $channel');
      debugPrint('Amount: $amount, User ID: ${userId.value}');
      debugPrint('Body: $body');
      
      final res = await http.post(uri, headers: headers, body: body);

      // Log response for debugging
      debugPrint('=== TG PAY TOPUP RESPONSE ===');
      debugPrint('Status Code: ${res.statusCode}');
      debugPrint('Response Body: ${res.body}');

      if (res.statusCode < 200 || res.statusCode >= 300) {
        // Parse error response if possible
        String errorMessage = 'Gagal membuat top up. (${res.statusCode})';
        try {
          final errorData = json.decode(res.body) as Map<String, dynamic>?;
          final message = errorData?['message'] ?? errorData?['error'] ?? '';
          if (message.toString().isNotEmpty) {
            errorMessage = 'Gagal: $message (${res.statusCode})';
          }
        } catch (_) {
          // If can't parse, use default message
        }
        
        debugPrint('=== TOPUP ERROR ===');
        debugPrint('Status: ${res.statusCode}');
        debugPrint('Response: ${res.body}');
        debugPrint('Request was: method=$method, channel=$channel, amount=$amount');
        debugPrint('User ID: ${userId.value}');
        debugPrint('Headers: $headers');
        debugPrint('Request Body: $body');
        
        // Show detailed error in snackbar
        String detailedError = errorMessage;
        try {
          final errorData = json.decode(res.body) as Map<String, dynamic>?;
          final errorDetail = errorData?['error'] ?? errorData?['errors'];
          if (errorDetail != null) {
            detailedError = '$errorMessage\nDetail: $errorDetail';
          }
        } catch (_) {
          // Keep original error message
        }
        
        CustomSnackbar.show(
          title: 'Gagal Membuat Top Up',
          message: detailedError,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      // Decode response
      final Map<String, dynamic> root =
          json.decode(res.body) as Map<String, dynamic>;
      final Map<String, dynamic> data =
          (root['data'] as Map<String, dynamic>? ?? <String, dynamic>{});

      // Store full response for later use
      lastTopup.value = root;
      lastTopupStatus.value = (root['status'] as String? ?? '').toLowerCase();

      // Reference id if provided
      final ref = root['client_reference_id'] ??
          root['clientReferenceId'] ??
          root['reference_id'];
      if (ref is String && ref.isNotEmpty) {
        lastTopupReferenceId = ref;
      } else {
        lastTopupReferenceId = null;
      }

      // Start polling status if we have a reference id
      _statusTimer?.cancel();
      if (lastTopupReferenceId != null) {
        _statusTimer = Timer.periodic(
          const Duration(seconds: 5),
          (_) => _pollTopupStatus(),
        );
      }

      // If QRIS, trigger QR modal (qrUrl is nested inside data.charge_details[0].qr.qrUrl)
      if (method == 'QR') {
        String qrUrl = '';
        try {
          final List<dynamic>? chargeDetails =
              data['charge_details'] as List<dynamic>?;
          if (chargeDetails != null && chargeDetails.isNotEmpty) {
            final Map<String, dynamic>? firstCharge =
                chargeDetails.first as Map<String, dynamic>?;
            final Map<String, dynamic>? qr =
                firstCharge?['qr'] as Map<String, dynamic>?;
            qrUrl = qr?['qrUrl']?.toString() ?? '';
          }
        } catch (_) {
          qrUrl = '';
        }
        if (qrUrl.isNotEmpty) {
          qrImageUrl.value = qrUrl;
        }
      } else if (method == 'VIRTUAL_ACCOUNT') {
        // Extract VA details from response
        // Response has VA in two places:
        // 1. data.charge_details[0].virtualAccount (camelCase)
        // 2. data.virtual_account (snake_case)
        Map<String, String> vaInfo = {};
        try {
          Map<String, dynamic>? va;
          
          // Try charge_details first (camelCase)
          final List<dynamic>? chargeDetails =
              data['charge_details'] as List<dynamic>?;
          if (chargeDetails != null && chargeDetails.isNotEmpty) {
            final Map<String, dynamic>? firstCharge =
                chargeDetails.first as Map<String, dynamic>?;
            // Try camelCase first
            va = firstCharge?['virtualAccount'] as Map<String, dynamic>?;
            // Fallback to snake_case
            if (va == null) {
              va = firstCharge?['virtual_account'] as Map<String, dynamic>?;
            }
          }
          
          // If not found in charge_details, try root level
          if (va == null) {
            va = data['virtual_account'] as Map<String, dynamic>?;
          }
          
          if (va != null) {
            // Try both camelCase and snake_case field names
            vaInfo['number'] = va['virtualAccountNumber']?.toString() ?? 
                              va['virtual_account_number']?.toString() ?? '';
            vaInfo['name'] = va['virtualAccountName']?.toString() ?? 
                            va['virtual_account_name']?.toString() ?? '';
            vaInfo['bank'] = (va['channel']?.toString() ?? selectedBank.value).toUpperCase();
            // Get expiry if available (try both formats)
            final expiry = va['expiryAt'] ?? va['expires_at'] ?? va['expiry_at'];
            if (expiry != null) {
              vaInfo['expiry'] = expiry.toString();
            }
            
            debugPrint('=== VA DETAILS EXTRACTED ===');
            debugPrint('Number: ${vaInfo['number']}');
            debugPrint('Name: ${vaInfo['name']}');
            debugPrint('Bank: ${vaInfo['bank']}');
          }
        } catch (e) {
          debugPrint('=== VA EXTRACTION ERROR ===');
          debugPrint('Error: $e');
          vaInfo = {};
        }
        if ((vaInfo['number']?.isNotEmpty ?? false)) {
          vaDetails.value = vaInfo;
          debugPrint('=== VA DETAILS SET ===');
        } else {
          debugPrint('=== VA DETAILS EMPTY ===');
          debugPrint('VA Info: $vaInfo');
        }
      }

      CustomSnackbar.show(
        title: 'Berhasil',
        message: 'Top up berhasil dibuat. Silakan selesaikan pembayaran.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Gagal',
        message: 'Terjadi kesalahan saat membuat top up.',
      );
    } finally {
      isSubmittingTopup.value = false;
    }
  }

  Future<void> _pollTopupStatus() async {
    final ref = lastTopupReferenceId;
    if (ref == null) return;

    final uri = Uri.parse(
        'https://payment.transgo.id/api/v1/payments/status?reference_id=$ref');
    final token = GlobalVariables.token.value;
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final res = await http.get(uri, headers: headers);
      
      debugPrint('=== POLLING STATUS ===');
      debugPrint('Status Code: ${res.statusCode}');
      debugPrint('Response: ${res.body}');
      
      if (res.statusCode != 200) {
        debugPrint('Status check failed with code: ${res.statusCode}');
        return;
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;
      
      // Try multiple possible status locations
      String? status;
      
      // Check data.data.status (nested)
      final nestedData = responseData['data'] as Map<String, dynamic>?;
      if (nestedData != null) {
        status = nestedData['status']?.toString().toLowerCase();
      }
      
      // Fallback to root level status
      if (status == null || status.isEmpty) {
        status = responseData['status']?.toString().toLowerCase() ?? '';
      }
      
      // Also check charge_details[0].status
      if ((status.isEmpty || status == 'created') && nestedData != null) {
        final chargeDetails = nestedData['charge_details'] as List<dynamic>?;
        if (chargeDetails != null && chargeDetails.isNotEmpty) {
          final firstCharge = chargeDetails.first as Map<String, dynamic>?;
          final chargeStatus = firstCharge?['status']?.toString().toLowerCase();
          if (chargeStatus != null && chargeStatus.isNotEmpty) {
            status = chargeStatus;
          }
        }
      }
      
      debugPrint('Extracted Status: $status');
      lastTopupStatus.value = status;

      // Check for completed status (handle various formats)
      final isCompleted = status == 'completed' || 
                         status == 'success' || 
                         status == 'captured' ||
                         status == 'paid';
      
      final isTerminal = isCompleted ||
                         status == 'failed' ||
                         status == 'expired' ||
                         status == 'cancelled' ||
                         status == 'refunded';

      if (isTerminal) {
        _statusTimer?.cancel();
        _statusTimer = null;
        
        debugPrint('Payment reached terminal status: $status');

        if (isCompleted) {
          debugPrint('Payment completed! Fetching balance...');
          await fetchBalance();
          
          CustomSnackbar.show(
            title: 'Pembayaran Berhasil',
            message: 'Saldo Anda telah diperbarui',
            backgroundColor: Colors.green,
          );
        }
      }
    } catch (e) {
      debugPrint('Error polling status: $e');
      // Continue polling on next tick
    }
  }
}
