import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import '../controllers/riwayatpemesanan_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

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
          onRefresh: () => controller.getListKendaraan(),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.listKendaraan.isEmpty) {
              return Center(
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
              );
            }

            return SingleChildScrollView(
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listKendaraan.length +
                        (controller.hasMore.value ? 1 : 0),
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _customCard(
                          data,
                          imagePath,
                          itemName,
                          location,
                          typeLabel,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _customCard(
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
                  child: Image.network(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
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
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14),
                          const SizedBox(width: 4),
                          poppinsText(text: itemLocation, fontSize: 12),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14),
                          const SizedBox(width: 4),
                          poppinsText(
                            text:
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['start_date']))} - '
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['end_date']))}',
                            fontSize: 12,
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
                StatusRiwayatStyle(
                  orderStatus: data['order_status'],
                  paymentStatus: data['payment_status'],
                ),
                poppinsText(
                  text:
                      'Rp ${NumberFormat.decimalPattern('id').format(data['total_price'])}',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textColor: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
