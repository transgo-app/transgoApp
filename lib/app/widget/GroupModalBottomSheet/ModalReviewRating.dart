import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../data/data.dart';
import '../../data/theme.dart';
import '../widgets.dart';

class ModalReviewRating extends StatefulWidget {
  final String itemName;
  final int orderId;
  final int? fleetId;
  final int? productId;
  final Function()? onSuccess;

  const ModalReviewRating({
    super.key,
    required this.itemName,
    required this.orderId,
    this.fleetId,
    this.productId,
    this.onSuccess,
  });

  @override
  State<ModalReviewRating> createState() => _ModalReviewRatingState();
}

class _ModalReviewRatingState extends State<ModalReviewRating> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    if (selectedRating == 0) {
      CustomSnackbar.show(
        title: "Perhatian",
        message: "Silakan pilih rating terlebih dahulu",
        icon: Icons.warning,
      );
      return;
    }

    if (commentController.text.trim().isEmpty) {
      CustomSnackbar.show(
        title: "Perhatian",
        message: "Silakan tuliskan pengalaman Anda",
        icon: Icons.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Determine the endpoint based on fleet or product
      final itemId = widget.fleetId ?? widget.productId;
      if (itemId == null) {
        CustomSnackbar.show(
          title: "Error",
          message: "Tidak dapat menemukan ID kendaraan/produk",
          icon: Icons.error,
        );
        return;
      }

      final endpoint = widget.fleetId != null
          ? '/fleets/$itemId/ratings'
          : '/products/$itemId/ratings';

      final response = await APIService().post(
        endpoint,
        {
          'order_id': widget.orderId,
          'rating': selectedRating,
          'comment': commentController.text.trim(),
        },
      );

      if (response != null) {
        // Close the bottom sheet first
        Get.back();
        
        // Wait for the bottom sheet to fully close before showing dialog and refreshing
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Trigger refresh in background (non-blocking)
        if (widget.onSuccess != null) {
          // Run refresh asynchronously without waiting
          widget.onSuccess!();
        }
        
        // Show success alert after a brief delay to ensure UI is ready
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (mounted) {
          Get.dialog(
            barrierDismissible: true,
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  gabaritoText(
                    text: "Ulasan Berhasil Dikirim!",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: textHeadline,
                  ),
                  const SizedBox(height: 10),
                  poppinsText(
                    text: "Terima kasih atas ulasan Anda",
                    fontSize: 14,
                    textColor: Colors.grey.shade700,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: poppinsText(
                    text: "OK",
                    fontSize: 14,
                    textColor: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print("Error submitting review: $e");
      CustomSnackbar.show(
        title: "Error",
        message: "Gagal mengirim ulasan. Silakan coba lagi.",
        icon: Icons.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: gabaritoText(
                    text: "Bagaimana pengalaman anda menyewa ${widget.itemName}?",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: textHeadline,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // Star rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Comment input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                poppinsText(
                  text: "Ceritakan pengalaman anda",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: textHeadline,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Tuliskan pengalaman anda menyewa kendaraan ini...",
                    hintStyle: poppinsTextStyle.copyWith(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: poppinsTextStyle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // TG Pay incentive
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  IconsaxPlusBold.gift,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: poppinsText(
                    text: "Dapatkan 50 TG Pay setelah memberikan ulasan !",
                    fontSize: 13,
                    textColor: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isLoading ? null : () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: poppinsText(
                    text: "Batal",
                    fontSize: 14,
                    textColor: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isLoading ? null : submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : poppinsText(
                          text: "Kirim Ulasan",
                          fontSize: 14,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        ),
      ),
    );
  }
}
