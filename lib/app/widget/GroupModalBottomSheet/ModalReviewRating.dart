import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/data.dart';
import '../../data/theme.dart';
import '../../data/helper/Storage_helper.dart';
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
  final RxBool isAnonymous = false.obs;
  final List<XFile> pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images?.isNotEmpty == true) {
      setState(() {
        pickedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      pickedImages.removeAt(index);
    });
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

      // Handle image uploads if any
      List<String> photoUrls = [];
      if (pickedImages?.isNotEmpty == true) {
        final presignData = await getPresignedUrls(
          fileNames: pickedImages.map((e) => e.name).toList(),
          baseUrl: baseUrl,
          username: username,
          password: password,
          folder: 'user',
        );
        photoUrls = await uploadImages(
          presignData: presignData,
          pickedImages: pickedImages,
          onProgress: (p) {},
        );
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
          'is_anonymous': isAnonymous.value,
          'photos': photoUrls,
        },
      );

      if (response != null) {
        // Close the bottom sheet first
        Get.back();
        
        // Wait for the bottom sheet to fully close
        await Future.delayed(const Duration(milliseconds: 300));
        
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
        
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (mounted) {
          Get.dialog(
            barrierDismissible: true,
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Reward animation icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade100, Colors.yellow.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconsaxPlusBold.gift,
                      color: primaryColor,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  gabaritoText(
                    text: "🎉 Rating Berhasil!",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    textColor: textHeadline,
                  ),
                  const SizedBox(height: 16),
                  // Payout info card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200, width: 2),
                    ),
                    child: Column(
                      children: [
                        poppinsText(
                          text: "Selamat! Kamu mendapatkan",
                          fontSize: 13,
                          textColor: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            gabaritoText(
                              text: "50 ",
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              textColor: Colors.blue.shade700,
                            ),
                            gabaritoText(
                              text: "TG PAY",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.blue.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  poppinsText(
                    text: "Terima kasih telah memberikan ulasan! Saldo TG Pay kamu telah ditambahkan secara otomatis.",
                    fontSize: 13,
                    textColor: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: poppinsText(
                        text: "Tutup",
                        fontSize: 14,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildRewardBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: poppinsText(
        text: "+50 TG PAY",
        fontSize: 9,
        fontWeight: FontWeight.w800,
        textColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight + bottomPadding + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: gabaritoText(
                      text: "Bagaimana pengalaman anda menyewa ${widget.itemName}?",
                      fontSize: 18,
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
            // Star rating section
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 44,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                _buildRewardBadge(),
              ],
            ),
            const SizedBox(height: 28),
            // Comment input section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      poppinsText(
                        text: "Ceritakan pengalaman anda",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: textHeadline,
                      ),
                      _buildRewardBadge(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Tuliskan pengalaman anda menyewa kendaraan ini...",
                      hintStyle: poppinsTextStyle.copyWith(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: poppinsTextStyle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CheckboxListTile(
                value: isAnonymous.value,
                onChanged: (val) => isAnonymous.value = val ?? false,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: poppinsText(
                  text: "Beri ulasan secara anonim",
                  fontSize: 12,
                  textColor: Colors.grey.shade700,
                ),
              ),
            )),
            const SizedBox(height: 8),
            // Photo upload section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(IconsaxPlusLinear.image, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          poppinsText(
                            text: "Foto Pendukung (Opsional)",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: textHeadline,
                          ),
                        ],
                      ),
                      _buildRewardBadge(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Image picker area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        if (pickedImages?.isNotEmpty == true)
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: pickedImages.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(pickedImages[index].path),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        if (pickedImages?.isNotEmpty == true) const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickImages,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                                  ],
                                ),
                                child: Icon(IconsaxPlusLinear.add, color: primaryColor, size: 24),
                              ),
                              const SizedBox(height: 8),
                              poppinsText(
                                text: "Klik untuk upload foto",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.grey.shade700,
                              ),
                              poppinsText(
                                text: "Format: JPEG, PNG (Maks. 5MB)",
                                fontSize: 11,
                                textColor: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // TG Pay incentive message
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(IconsaxPlusBold.gift, color: Colors.blue.shade700, size: 24),
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
            const SizedBox(height: 28),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: isLoading ? null : () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

