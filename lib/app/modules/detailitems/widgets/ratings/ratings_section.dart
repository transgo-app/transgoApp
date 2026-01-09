import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/data.dart';
import '../../../../data/theme.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'star_rating_widget.dart';
import '../../../../data/helper/FormatTanggal.dart';

class RatingsSection extends StatelessWidget {
  final DetailitemsController controller;

  const RatingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Get data from dataServer (from dashboard - has direct fields) or detailData (has nested fleet/product)
      final averageRating = controller.dataServer?['average_rating'] != null
          ? (controller.dataServer['average_rating'] ?? 0).toDouble()
          : controller.isKendaraan
              ? (controller.detailData['fleet']?['average_rating'] ?? 0).toDouble()
              : (controller.detailData['product']?['average_rating'] ?? 0).toDouble();
      
      final ratingCount = controller.dataServer?['rating_count'] != null
          ? (controller.dataServer['rating_count'] ?? 0).toInt()
          : controller.isKendaraan
              ? (controller.detailData['fleet']?['rating_count'] ?? 0).toInt()
              : (controller.detailData['product']?['rating_count'] ?? 0).toInt();

      // Hide if no reviews
      if (averageRating == 0 || ratingCount == 0) {
        if (controller.ratings.isEmpty && !controller.isLoadingRatings.value) {
          return const SizedBox.shrink();
        }
      }

      final itemName = controller.dataServer?['name'] != null
          ? (controller.dataServer['name'] ?? 'Item')
          : controller.isKendaraan
              ? (controller.detailData['fleet']?['name'] ?? 'Kendaraan')
              : (controller.detailData['product']?['name'] ?? 'Produk');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          gabaritoText(
            text: 'Ulasan Pelanggan $itemName',
            fontSize: 18,
            textColor: textHeadline,
          ),
          const SizedBox(height: 12),
          // Overall rating card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(
                      text: averageRating.toStringAsFixed(1),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textColor: textHeadline,
                    ),
                    poppinsText(
                      text: '($ratingCount ulasan)',
                      fontSize: 14,
                      textColor: Colors.grey.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Reviews list
          if (controller.isLoadingRatings.value)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (controller.ratings.isEmpty)
            const SizedBox.shrink()
          else
            ...controller.ratings.map((rating) => _buildReviewCard(rating)),
          // "Lihat semua ulasan" button
          if (controller.totalRatings.value > 2)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    int? itemId;
                    if (controller.dataServer?['id'] != null) {
                      itemId = controller.dataServer['id'];
                    } else {
                      if (controller.isKendaraan) {
                        final fleetData = controller.detailData['fleet'] as Map?;
                        itemId = fleetData?['id'];
                      } else {
                        final productData = controller.detailData['product'] as Map?;
                        itemId = productData?['id'];
                      }
                    }
                    Get.toNamed('/reviews', arguments: {
                      'itemId': itemId,
                      'isKendaraan': controller.isKendaraan,
                      'itemName': itemName,
                    });
                  },
                  child: Text(
                    'Lihat semua ulasan',
                    style: poppinsTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildReviewCard(Map<String, dynamic> rating) {
    final customer = rating['customer'] as Map?;
    final customerName = customer?['name'] ?? 'Pelanggan';
    final comment = rating['comment'] ?? '';
    final ratingValue = (rating['rating'] ?? 0).toDouble();
    final createdAt = rating['created_at'] as String?;

    // Get first letter for avatar
    final firstLetter = customerName.isNotEmpty
        ? customerName[0].toUpperCase()
        : 'P';

    // Format date
    String formattedDate = '';
    if (createdAt != null) {
      formattedDate = formatTanggalIndonesia(createdAt);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: poppinsText(
                    text: firstLetter,
                    fontSize: 18,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Customer name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(
                      text: customerName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: textHeadline,
                    ),
                    if (formattedDate.isNotEmpty)
                      poppinsText(
                        text: formattedDate,
                        fontSize: 12,
                        textColor: Colors.grey.shade600,
                      ),
                  ],
                ),
              ),
              // Star rating
              StarRatingWidget(rating: ratingValue, starSize: 16),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            poppinsText(
              text: comment,
              fontSize: 13,
              textColor: textPrimary,
            ),
          ],
        ],
      ),
    );
  }
}
