import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import 'empty_state/empty_state_section.dart';
import '../../../widget/widgets.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class ResultsArea extends StatelessWidget {
  final DashboardController controller;
  const ResultsArea({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -70),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Obx(() {
          if (controller.showDataMobil.value == false) {
            return EmptyStateSection(controller: controller);
          } else if (controller.isLoading.value) {
            return Center(child: poppinsText(text: "Harap Tunggu...."));
          }

          if (controller.listKendaraan.isNotEmpty) {
            return KendaraanList(controller: controller);
          }

          if (controller.listProduk.isNotEmpty) {
            return ProdukList(controller: controller);
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  Image.asset('assets/nodata.jpg', scale: 10),
                  poppinsText(
                    text: "Data Tidak Ditemukan",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class KendaraanList extends StatelessWidget {
  final DashboardController controller;
  const KendaraanList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: gabaritoText(
              text:
                  "Hasil Pencarian: ${controller.jumlahData['total_items'] ?? ''} Kendaraan",
              fontSize: 18,
              textColor: textHeadline,
            ),
          ),
          Obx(() => ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.listKendaraan.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.listKendaraan.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 10),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      ),
                    );
                  }

                  final data = controller.listKendaraan[index];

                  return ItemCard(
                    data: data,
                    isKendaraan: true,
                    onTap: () {
                      Get.toNamed('/detailkendaraan', arguments: {
                        'isKendaraan': true,
                        'dataClient': {
                          'is_with_driver':
                              controller.jenisSewa.value == 1 ? false : true,
                          'date': controller.pickedDateTimeISO.value,
                          'duration': controller.selectedDurasiSewa.value,
                        },
                        'dataServer': data,
                      });
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}

class ProdukList extends StatelessWidget {
  final DashboardController controller;
  const ProdukList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: gabaritoText(
              text: "Hasil Pencarian: ${controller.jumlahData['total_items'] ?? ''} Produk",
              fontSize: 18,
              textColor: textHeadline,
            ),
          ),
          Obx(() => ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.listProduk.length,
                itemBuilder: (context, index) {
                  final data = controller.listProduk[index];
                  return ItemCard(
                    data: data,
                    isKendaraan: false,
                    onTap: () {
                      Get.toNamed('/detailkendaraan', arguments: {
                        'isKendaraan': false,
                        'dataClient': {
                          'date': controller.pickedDateTimeISO.value,
                          'duration': controller.selectedDurasiSewa.value,
                        },
                        'dataServer': data,
                      });
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;
  final bool isKendaraan;

  const ItemCard(
      {super.key, required this.data, this.onTap, this.isKendaraan = false});

  @override
  Widget build(BuildContext context) {
    final String photo = isKendaraan
        ? (data['photo']?['photo'] ??
            ((data['photos'] != null && (data['photos'] as List).isNotEmpty)
                ? data['photos'][0]['photo']
                : 'https://transgo.id/logo/image%203.svg'))
        : (data['photo']?['photo'] ?? '');

    final name = data['name'] ?? '-';
    String mapVehicleType(dynamic type) {
      switch (type) {
        case 'car':
          return 'mobil';
        case 'motorcycle':
          return 'motor';
        default:
          return type?.toString() ?? '-';
      }
    }

    final type = mapVehicleType(data['type']);
    final statusLabel = data['status_label'] ?? '';
    final category =
        isKendaraan ? (data['type'] ?? '-') : (data['category_label'] ?? '');
    final location = data['location']?['location'] ?? '-';
    final brand = isKendaraan
        ? (data['brandRelation']?['name'] ?? '-')
        : data['specifications']?['brand'] ?? '';
    final color = isKendaraan
        ? (data['color'] ?? '-')
        : data['specifications']?['color'] ?? '';
    final capacity = data['specifications']?['size'] ?? '';
    final price = (data['price'] ?? 0).round();
    final discount = data['discount'] ?? 0;
    final priceAfter = (price - (price * discount / 100)).round();
    final weekly = (data['weekly_price'] ?? 0).round();
    final monthly = (data['monthly_price'] ?? 0).round();
    final averageRating = (data['average_rating'] ?? 0).toDouble();
    final ratingCount = (data['rating_count'] ?? 0).toInt();
    final tier = isKendaraan ? (data['tier']?.toString().toLowerCase() ?? '') : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(photo, discount, statusLabel, type, category),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(
                      text: name, fontSize: 16, fontWeight: FontWeight.w700),
                  if (isKendaraan && tier.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildTierChip(tier),
                  ],
                  if (isKendaraan && averageRating > 0 && ratingCount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          '⭐',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        poppinsText(
                          text: '${averageRating.toStringAsFixed(1)} ($ratingCount ulasan)',
                          fontSize: 13,
                          textColor: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: (isKendaraan
                        ? [
                            productSpecIfValid(Icons.location_on, location),
                            productSpecIfValid(Icons.drive_eta, type),
                            productSpecIfValid(Icons.label, brand),
                            productSpecIfValid(Icons.color_lens, color),
                          ]
                        : [
                            productSpecIfValid(Icons.location_on, location),
                            productSpecIfValid(Icons.label, brand),
                            productSpecIfValid(Icons.color_lens, color),
                            productSpecIfValid(Icons.sd_storage, capacity),
                          ])
                    .whereType<Widget>()
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPriceSection(
                  discount, price, priceAfter, weekly, monthly),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: poppinsText(
                    text: "Sewa Sekarang",
                    fontSize: 14,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget? productSpecIfValid(IconData icon, dynamic value) {
    if (value == null) return null;
    final v = value.toString().trim();
    if (v.isEmpty || v == '-') return null;
    return productSpec(icon, v);
  }

  Widget _buildImageSection(String photo, int discount, String statusLabel,
      String type, String category) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18), topRight: Radius.circular(18)),
      child: Stack(
        children: [
          Image.network(photo,
              height: 250, width: double.infinity, fit: BoxFit.cover),
          if (discount > 0)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(20)),
                child: poppinsText(
                    text: "-$discount%",
                    fontSize: 12,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20)),
              child: poppinsText(
                  text: statusLabel,
                  fontSize: 12,
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20)),
              child: poppinsText(
                  text: category,
                  fontSize: 12,
                  textColor: Colors.blue.shade50,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      int discount, num price, num priceAfter, num? weekly, num? monthly) {
    final weeklyPrice = discount > 0
        ? ((priceAfter * (weekly ?? 0) / price)).round()
        : (weekly ?? 0);

    final monthlyPrice = discount > 0
        ? ((priceAfter * (monthly ?? 0) / price)).round()
        : (monthly ?? 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          poppinsText(
              text: "HARGA SEWA", fontSize: 12, fontWeight: FontWeight.w600),
          const SizedBox(height: 6),
          if (discount > 0)
            Text.rich(TextSpan(children: [
              TextSpan(
                text:
                    "Rp ${NumberFormat.decimalPattern('id').format(priceAfter)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ),
              const TextSpan(
                text: " / Hari",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ])),
          Text(
            "Rp ${NumberFormat.decimalPattern('id').format(price)} / Hari",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: discount > 0 ? Colors.grey.shade700 : Colors.black,
              decoration: discount > 0
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          const SizedBox(height: 14),
          if ((weekly ?? 0) > 0 || (monthly ?? 0) > 0) ...[
            Divider(color: Colors.blue.shade200, thickness: 1),
            if ((weekly ?? 0) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  poppinsText(
                      text: "Mingguan:",
                      fontSize: 13,
                      textColor: Colors.grey.shade800),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (discount > 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(weeklyPrice)}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      if (discount > 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(weekly)}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                              decoration: TextDecoration.lineThrough),
                        ),
                      if (discount == 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(weekly)}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                    ],
                  ),
                ],
              ),
            if ((monthly ?? 0) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  poppinsText(
                      text: "Bulanan:",
                      fontSize: 13,
                      textColor: Colors.grey.shade800),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (discount > 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(monthlyPrice)}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      if (discount > 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(monthly)}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                              decoration: TextDecoration.lineThrough),
                        ),
                      if (discount == 0)
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(monthly)}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTierChip(String tier) {
    // Normalize tier to lowercase for comparison
    final tierLower = tier.toLowerCase();
    
    if (tierLower == 'premium') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFB84D), // Lighter golden-orange
              Color(0xFFFF9500), // Darker golden-orange
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            poppinsText(
              text: 'Premium',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    } else if (tierLower == 'reguler' || tierLower == 'regular') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4CAF50), // Lighter green
              Color(0xFF2E7D32), // Darker green
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            poppinsText(
              text: 'Reguler',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }
    
    // Default: return empty if tier doesn't match
    return const SizedBox.shrink();
  }

  Widget productSpec(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Flexible(
              child: poppinsText(
                  text: value, fontSize: 13, textColor: Colors.grey.shade800)),
        ],
      ),
    );
  }
}
