// controllers/transgoreward_controller.dart
import 'package:get/get.dart';
import '../../../data/data.dart'; // pastikan APIService ada di sini

class Benefit {
  final int id;
  final String benefitType;
  final int remainingCount;
  final String tierSource;
  final DateTime expiresAt;

  Benefit({
    required this.id,
    required this.benefitType,
    required this.remainingCount,
    required this.tierSource,
    required this.expiresAt,
  });

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      id: json['id'],
      benefitType: json['benefit_type'],
      remainingCount: json['remaining_count'],
      tierSource: json['tier_source'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}

class ReferralUser {
  final int id;
  final String name;
  final String phoneNumber;
  final String memberTier;
  final int totalRentalAmount;
  final int totalOrders;
  final int totalRentalDays;

  ReferralUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.memberTier,
    required this.totalRentalAmount,
    required this.totalOrders,
    required this.totalRentalDays,
  });

  factory ReferralUser.fromJson(Map<String, dynamic> json) {
    return ReferralUser(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      memberTier: json['member_tier'] ?? '',
      totalRentalAmount: json['total_rental_amount'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      totalRentalDays: json['total_rental_days'] ?? 0,
    );
  }
}

class TransGoRewardController extends GetxController {
  RxString memberTier = ''.obs;
  RxDouble progressPercent = 0.0.obs;
  RxInt totalRentalAmount = 0.obs;
  RxInt nextThreshold = 0.obs;
  RxList<Benefit> benefits = <Benefit>[].obs;

  // Referral
  RxString referralCode = ''.obs;
  RxInt referredCount = 0.obs;
  RxList<ReferralUser> referralUsers = <ReferralUser>[].obs;

  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRewards();
    fetchReferralProgress();
    fetchReferralInfo();
  }

  /// Fetch data reward/voucher dari API
  Future<void> fetchRewards() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await APIService().get('/loyalty/me');
      memberTier.value = data['member_tier'] ?? '';
      totalRentalAmount.value = data['total_rental_amount'] ?? 0;
      nextThreshold.value = data['next_threshold'] ?? 0;
      progressPercent.value = nextThreshold.value > 0
          ? totalRentalAmount.value / nextThreshold.value
          : 0.0;

      final benefitsData = data['benefits'] as List<dynamic>? ?? [];
      benefits.value = benefitsData.map((b) => Benefit.fromJson(b)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh rewards
  Future<void> refreshRewards() async {
    benefits.clear();
    memberTier.value = '';
    totalRentalAmount.value = 0;
    nextThreshold.value = 0;
    progressPercent.value = 0.0;
    await fetchRewards();
  }

  /// Fetch list user yang diundang (referral progress)
  Future<void> fetchReferralProgress({int page = 1, int limit = 100}) async {
    try {
      final data = await APIService()
          .get('/users/referred/progress?page=$page&limit=$limit');
      final usersData = data['data'] as List<dynamic>? ?? [];
      referralUsers.value =
          usersData.map((u) => ReferralUser.fromJson(u)).toList();
    } catch (e) {
      print('Error fetchReferralProgress: $e');
    }
  }

  /// Fetch info referral user sendiri
  Future<void> fetchReferralInfo() async {
    try {
      final data = await APIService().get('/auth/me/referral');
      referralCode.value = data['referral_code'] ?? '';
      referredCount.value = data['referred_count'] ?? 0;
    } catch (e) {
      print('Error fetchReferralInfo: $e');
    }
  }
}
