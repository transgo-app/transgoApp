import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/fleet_recommendation_model.dart';
import '../../../data/data.dart';
import '../controllers/dashboard_controller.dart';

/// Fleet Recommendation Widget displayed in dashboard after search
class FleetRecommendationWidget extends StatelessWidget {
  final FleetRecommendationResponse? data;
  final bool isLoading;
  final String selectedType; // 'car' or 'motorcycle'
  final VoidCallback? onItemTap;

  const FleetRecommendationWidget({
    super.key,
    this.data,
    this.isLoading = false,
    required this.selectedType,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show if no data or loading
    if (isLoading) {
      return _buildLoadingState();
    }

    if (data == null || !data!.hasRecommendations) {
      return const SizedBox.shrink();
    }

    // Filter recommendations by selected type
    final filteredMain = data!.mainRecommendations
        .where((item) => item.type == selectedType)
        .toList();
    final filteredInTown = data!.inTownRecommendations
        .where((item) => item.type == selectedType)
        .toList();
    final filteredOutTown = data!.outOfTownRecommendations
        .where((item) => item.type == selectedType)
        .toList();

    // Don't show if no matching recommendations
    if (filteredMain.isEmpty && filteredInTown.isEmpty && filteredOutTown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Rekomendasi Pintar',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${selectedType == 'motorcycle' ? 'Motor' : 'Mobil'} Terbaik Untuk Anda',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data!.isWeekend ? 'Pilihan Akhir Pekan' : 'Pilihan Hari Kerja',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main recommendations
          if (filteredMain.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.work, size: 18, color: Colors.orange[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data!.isWeekend ? 'Unit Terlaris Akhir Pekan' : 'Unit Favorit Hari Kerja',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredMain.length,
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(
                    filteredMain[index],
                    data!.isWeekend ? 'weekend' : 'weekday',
                  );
                },
              ),
            ),
          ],

          // In-town recommendations
          if (filteredInTown.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.location_city, size: 18, color: Colors.blue[600]),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Dalam Kota',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredInTown.length,
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(filteredInTown[index], 'inTown');
                },
              ),
            ),
          ],

          // Out-of-town recommendations (only for cars)
          if (selectedType == 'car' && filteredOutTown.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.explore, size: 18, color: Colors.green[600]),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Luar Kota',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredOutTown.length,
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(filteredOutTown[index], 'outTown');
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(FleetRecommendationItem item, String context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    String statsText;
    switch (context) {
      case 'weekend':
        statsText = 'Disewa ${item.orderCount}x di akhir pekan';
        break;
      case 'weekday':
        statsText = 'Disewa ${item.orderCount}x di hari kerja';
        break;
      case 'inTown':
        statsText = 'Disewa ${item.orderCount}x dalam kota';
        break;
      case 'outTown':
        statsText = 'Disewa ${item.orderCount}x luar kota';
        break;
      default:
        statsText = 'Disewa ${item.orderCount}x';
    }

    final dashboardController = Get.find<DashboardController>();

    return GestureDetector(
      onTap: () {
        // Navigate to fleet detail with the item data
        // Note: The detail page expects a specific data structure
        Get.toNamed('/detailkendaraan', arguments: {
          'isKendaraan': true,
          'dataClient': {
            'is_with_driver':
                dashboardController.jenisSewa.value == 1 ? false : true,
            'date': dashboardController.pickedDateTimeISO.value,
            'duration': dashboardController.selectedDurasiSewa.value,
          },
          'dataServer': {
            'id': item.id,
            'name': item.name,
            'type': item.type,
            'color': item.color,
            'plate_number': item.plateNumber,
            'price': item.price,
            'price_after_discount': item.priceAfterDiscount,
            'final_price': item.finalPrice,
            'discount': item.discount,
            'has_flash_sale': item.hasFlashSale,
            'flash_sale_name': item.flashSaleName,
            'average_rating': item.averageRating,
            'rating_count': item.ratingCount,
            'photo': item.photo,
            'location': item.location,
            'tier': item.tier,
          },
        });
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                child: item.photoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.photoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          item.type == 'car' ? Icons.directions_car : Icons.two_wheeler,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      )
                    : Icon(
                        item.type == 'car' ? Icons.directions_car : Icons.two_wheeler,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      Text(
                        currencyFormat.format(item.effectivePrice),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '/hari',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (item.hasFlashSale) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FLASH SALE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Stats badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statsText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
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
