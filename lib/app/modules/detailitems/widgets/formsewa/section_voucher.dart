import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transgomobileapp/app/data/helper/FormatRupiah.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:intl/intl.dart';

class SectionVoucher extends StatelessWidget {
  final DetailitemsController controller;
  const SectionVoucher({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            gabaritoText(text: "Voucher"),
            const SizedBox(height: 4),
            gabaritoText(
              text: "Gunakan voucher untuk mendapatkan potongan harga",
              fontSize: 13,
              textColor: textPrimary,
            ),
            const SizedBox(height: 10),
            BackgroundCard(
              borderRadius: 12,
              height: 55,
              marginVertical: 10,
              paddingHorizontal: 15,
              paddingVertical: 10,
              ontap: () => _showVoucherBottomSheet(context),
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    if (controller.selectedVoucher.isEmpty) {
                      return Expanded(
                        child: gabaritoText(
                          text: "Pilih Voucher",
                          textColor: solidPrimary,
                          Maxlines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }

                    final v = controller.selectedVoucher;
                    final isPercent = v['is_percentage'] == true;
                    final amount = v['amount'];

                    return Expanded(
                      child: gabaritoText(
                        text: amount == 0
                            ? "Gratis"
                            : isPercent
                                ? "Diskon $amount%"
                                : "Potongan Rp ${formatRupiah(amount)}",
                        textColor: solidPrimary,
                        Maxlines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                  const SizedBox(width: 10),
                  Icon(IconsaxPlusBold.arrow_square_right, color: solidPrimary),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVoucherBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return _VoucherBottomSheet(
              controller: controller,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    return token != null && token.isNotEmpty;
  }
}

class _VoucherBottomSheet extends StatelessWidget {
  final DetailitemsController controller;
  final ScrollController scrollController;

  _VoucherBottomSheet({
    required this.controller,
    required this.scrollController,
  });

  final Map<String, String> categoryDescription = {
    'Diskon': 'Voucher potongan harga untuk transaksi Anda',
    'Gratis Antar': 'Dapatkan pengantaran gratis dalam jarak 5 km',
    'Gratis Jemput': 'Layanan jemput gratis dalam jarak 5 km',
    'Gratis Supir': 'Nikmati layanan supir gratis',
    'Gratis Aksesori': 'Dapatkan aksesori tambahan secara gratis',
  };

  Map<String, List<Map<String, dynamic>>> _groupVouchers(
      List<dynamic> vouchers) {
    Map<String, List<Map<String, dynamic>>> grouped = {
      'Diskon': [],
      'Gratis Antar': [],
      'Gratis Jemput': [],
      'Gratis Supir': [],
      'Gratis Aksesori': [],
    };

    for (var v in vouchers) {
      if (v == null || v is! Map<String, dynamic>) continue;

      if (v['max_discount_amount'] == null) v['max_discount_amount'] = 0;

      final reason = v['reason'] ?? "";

      if (reason.contains('loyalty_priority')) {
        grouped['Diskon']!.add(v);
      } else if (reason.contains('benefit_free_delivery')) {
        grouped['Gratis Antar']!.add(v);
      } else if (reason.contains('benefit_free_pickup')) {
        grouped['Gratis Jemput']!.add(v);
      } else if (reason.contains('benefit_free_driver')) {
        grouped['Gratis Supir']!.add(v);
      } else if (reason.contains('benefit_free_addon')) {
        grouped['Gratis Aksesori']!.add(v);
      }
    }

    return grouped;
  }

  // Fungsi untuk konversi allowedDays ke bahasa Indonesia
  String formatAllowedDays(String allowedDays) {
    final dayMap = {
      'monday': 'Senin',
      'tuesday': 'Selasa',
      'wednesday': 'Rabu',
      'thursday': 'Kamis',
      'friday': 'Jumat',
      'saturday': 'Sabtu',
      'sunday': 'Minggu',
    };

    return allowedDays
        .split(',')
        .map((d) => dayMap[d.toLowerCase()] ?? d)
        .join(', ');
  }

  // Fungsi untuk format tanggal
  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy', 'id_ID').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const gabaritoText(
            text: "Voucher Tersedia",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingVoucher.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.vouchers.isEmpty) {
                return const Center(
                  child: gabaritoText(
                    text: "Tidak ada voucher yang tersedia",
                    textColor: Colors.grey,
                  ),
                );
              }

              final grouped = _groupVouchers(controller.vouchers);
              List<Widget> voucherWidgets = [];

              grouped.forEach((category, vouchers) {
                if (vouchers.isEmpty) return;

                // Nama kategori + deskripsi
                voucherWidgets.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        gabaritoText(
                          text: category,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        if (categoryDescription[category] != null)
                          gabaritoText(
                            text: categoryDescription[category]!,
                            fontSize: 16,
                            textColor: Colors.grey.shade600,
                          ),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                );

                for (var v in vouchers) {
                  final isSelected =
                      controller.selectedVoucher['code'] == v['code'];
                  final isPercent = v['is_percentage'] == true;
                  final amount = v['amount'];
                  final maxAmount = v['max_discount_amount'] ?? 0;
                  final allowedDays = v['allowed_days'] ?? '';
                  final expiresAt = v['expires_at'] ?? '';

                  voucherWidgets.add(
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          controller.toggleVoucher(v);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Kiri: Amount
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: gabaritoText(
                                      text: amount == 0
                                          ? "Gratis"
                                          : isPercent
                                              ? "Diskon $amount% (Max Rp $maxAmount)"
                                              : "Rp ${formatRupiah(amount)}",
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      textColor: solidPrimary,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 80,
                                color: Colors.grey.shade300,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                              ),

                              // Kanan: Detail voucher
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    gabaritoText(
                                      text: v['code'] ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    if (v['min_subtotal_amount'] != null)
                                      gabaritoText(
                                        text:
                                            "Min. transaksi Rp ${v['min_subtotal_amount']}",
                                        fontSize: 12,
                                        textColor: Colors.grey.shade700,
                                      ),
                                    if (v['max_discount_amount'] != null &&
                                        v['max_discount_amount'] > 0)
                                      gabaritoText(
                                        text:
                                            "Max potongan Rp ${v['max_discount_amount']}",
                                        fontSize: 12,
                                        textColor: Colors.grey.shade700,
                                      ),
                                    if ((allowedDays ?? '').isNotEmpty)
                                      gabaritoText(
                                        text:
                                            "Berlaku hari: ${formatAllowedDays(allowedDays)}",
                                        fontSize: 12,
                                        textColor: Colors.grey.shade700,
                                      ),
                                    if ((expiresAt ?? '').isNotEmpty)
                                      gabaritoText(
                                        text:
                                            "Berlaku sampai: ${formatDate(expiresAt)}",
                                        fontSize: 12,
                                        textColor: Colors.grey.shade700,
                                      ),
                                  ],
                                ),
                              ),

                              // Icon selected
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              });

              return ListView(
                controller: scrollController,
                children: voucherWidgets,
              );
            }),
          ),
        ],
      ),
    );
  }
}
