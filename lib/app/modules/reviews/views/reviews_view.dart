import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/reviews_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../data/helper/FormatTanggal.dart';
import '../../detailitems/widgets/ratings/star_rating_widget.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusBold.arrow_left_1, size: 33),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: gabaritoText(
          text: 'Ulasan Pelanggan ${controller.itemName}',
          fontSize: 16,
          textColor: textHeadline,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.ratings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ratings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/nodata.jpg', scale: 10),
                const SizedBox(height: 16),
                poppinsText(
                  text: 'Belum ada ulasan',
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          backgroundColor: primaryColor,
          color: Colors.white,
          onRefresh: controller.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.ratings.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.ratings.length) {
                // Load more indicator
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Center(
                  child: TextButton(
                    onPressed: controller.loadMore,
                    child: poppinsText(
                      text: 'Muat lebih banyak',
                      fontSize: 14,
                      textColor: Colors.blue.shade700,
                    ),
                  ),
                );
              }

              final rating = controller.ratings[index];
              return _buildReviewCard(rating);
            },
          ),
        );
      }),
    );
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
      margin: const EdgeInsets.only(bottom: 16),
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
