import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import '../controllers/riwayatpemesanan_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../widget/GroupModalBottomSheet/ModalReviewRating.dart';

class RiwayatpemesananView extends GetView<RiwayatpemesananController> {
  const RiwayatpemesananView({super.key});

  String limitText(String text, {int limit = 30}) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}...';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.filterTitle.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            leading: const SizedBox.shrink(),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: gabaritoText(
              text: 'Riwayat Sewa',
              fontSize: 16,
              textColor: textHeadline,
            ),
            bottom: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              tabs: List.generate(
                controller.filterTitle.length,
                (index) => Tab(
                  child: gabaritoText(
                    text: controller.filterTitle[index]['title']!,
                  ),
                ),
              ),
              onTap: (index) {
                controller.changeFilter(
                  index: index,
                  status: controller.filterTitle[index]['status']!,
                );
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          backgroundColor: primaryColor,
          color: Colors.white,
          onRefresh: () async {
            await controller.refreshData();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (controller.listKendaraan.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/nodata.jpg', scale: 10),
                        poppinsText(
                          text: 'Data Tidak Ditemukan.',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Obx(() {
                      final itemCount = controller.listKendaraan.length +
                          (controller.hasMore.value ? 1 : 0);
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        cacheExtent: 250, // Optimized for low-end devices
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (index == controller.listKendaraan.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }

                          // Access data reactively from the list
                          final data = controller.listKendaraan[index];
                          final fleet = data['fleet'];
                          final product = data['product'];

                          final imagePath = fleet != null
                              ? (fleet['photo']?['photo'] ?? '')
                              : (product?['photo']?['photo'] ?? '');

                          final location = limitText(
                            fleet != null
                                ? (fleet['location']?['name'] ?? '')
                                : (product?['location']?['name'] ?? '-'),
                          );

                          final typeLabel = fleet != null
                              ? fleet['type_label'] ?? ''
                              : product?['category_label'] ?? '';

                          final itemName = fleet != null
                              ? fleet['name'] ?? ''
                              : product?['name'] ?? '';

                          return RepaintBoundary(
                            key: ValueKey('riwayat_${data['id']}_${data['order_status']}_${data['payment_status']}'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _customCard(
                                index,
                                data,
                                imagePath,
                                itemName,
                                location,
                                typeLabel,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _customCard(
    int index,
    dynamic data,
    String imagePath,
    String itemName,
    String itemLocation,
    String typeLabel,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detailriwayat', arguments: data),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 1.0, // 1:1 aspect ratio
                      child: Container(
                        color: Colors.grey[200],
                        child: CachedNetworkImage(
                          imageUrl: imagePath,
                          fit: BoxFit.cover, // Crop to fill, maintaining aspect ratio
                          // Optimized for low-end devices
                          memCacheWidth: 200, // ~ width * 2 for high-density
                          memCacheHeight: 200, // 1:1 ratio
                          maxWidthDiskCache: 200,
                          maxHeightDiskCache: 200,
                          filterQuality: FilterQuality.low,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      poppinsText(
                        text: itemName,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: poppinsText(
                              text: itemLocation,
                              fontSize: 12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: poppinsText(
                              text:
                                  '${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['start_date']))} - '
                                  '${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['end_date']))}',
                              fontSize: 12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.dashboard_outlined,
                              size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          poppinsText(
                            text: typeLabel,
                            fontSize: 12,
                            textColor: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      // Beri Ulasan button (only for done orders)
                      if (data['order_status'] == 'done') ...[
                        const SizedBox(height: 8),
                        Obx(() => _buildReviewButton(data, itemName)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Obx(() {
                    // Access the current data from the reactive list
                    final currentData = index < controller.listKendaraan.length
                        ? controller.listKendaraan[index]
                        : data;
                    return StatusRiwayatStyle(
                      orderStatus: currentData['order_status'],
                      paymentStatus: currentData['payment_status'],
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: poppinsText(
                    text:
                        'Rp ${NumberFormat.decimalPattern('id').format(data['total_price'])}',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textColor: primaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewButton(Map<String, dynamic> data, String itemName) {
    final orderId = data['id'];
    final isReviewed = controller.isOrderReviewed(orderId) || 
                       (data['has_rating'] ?? false) ||
                       (data['rating'] != null);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isReviewed
            ? null
            : () {
                final fleet = data['fleet'];
                final product = data['product'];
                Get.bottomSheet(
                  ModalReviewRating(
                    itemName: itemName,
                    orderId: orderId,
                    fleetId: fleet?['id'],
                    productId: product?['id'],
                    onSuccess: () {
                      // Refresh the list asynchronously without blocking
                      Future.delayed(const Duration(milliseconds: 500), () {
                        controller.getListKendaraan();
                      });
                    },
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isReviewed ? Colors.grey.shade300 : Colors.amber.shade600,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: isReviewed ? 0 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isReviewed) ...[
              const Icon(Icons.star, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
            ],
            poppinsText(
              text: isReviewed ? "Sudah dirating" : "Beri Ulasan",
              fontSize: 13,
              textColor: isReviewed ? Colors.grey.shade700 : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
