import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/fleet_recommendation_model.dart';
import '../../../data/data.dart';
import '../controllers/dashboard_controller.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

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
    final dashboardController = Get.find<DashboardController>();
    
    return Obx(() {
      final hasInteracted = dashboardController.hasInteractedRecommendation.value;
      final activeTab = dashboardController.selectedRecommendationTab.value;
      
      // If we have interacted but data is null (and not loading), something is wrong, hide.
      // But if not interacted, we show the teaser bar.
      if (hasInteracted && data == null && !isLoading) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Rekomendasi Pintar + Title
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
                        gabaritoText(
                          text: 'Rekomendasi Pintar',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          textColor: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  gabaritoText(
                    text: '${selectedType == 'motorcycle' ? 'Motor' : 'Mobil'} Terbaik Untuk Anda',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            if (hasInteracted) ...[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getTabIcon(activeTab),
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: gabaritoText(
                                text: _getTabLabel(hasInteracted, activeTab, data?.category ?? 'weekday'),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                textAlign: hasInteracted ? TextAlign.start : TextAlign.center,
                                Maxlines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Ganti Button (Dropdown)
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'clear') {
                        dashboardController.clearRecommendationFilter();
                      } else {
                        dashboardController.selectedRecommendationTab.value = value;
                        dashboardController.hasInteractedRecommendation.value = true;
                        // Fetch data when filter changes
                        await dashboardController.fetchRecommendations();
                      }
                    },
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    offset: const Offset(0, 56),
                    itemBuilder: (context) => [
                      _buildPopupMenuItem(
                        value: 'time',
                        icon: Icons.navigation_rounded,
                        title: 'Pilihan ${data?.category == "weekend" ? "Weekend" : "Weekday"}',
                        subtitle: 'Unit favorit di cabang ini',
                      ),
                      _buildPopupMenuItem(
                        value: 'usage',
                        icon: Icons.explore_outlined,
                        title: 'Tujuan Perjalanan',
                        subtitle: 'Dalam kota & luar kota',
                      ),
                      _buildPopupMenuItem(
                        value: 'purpose',
                        icon: Icons.favorite_border_rounded,
                        title: 'Tujuan Pemakaian',
                        subtitle: 'Wisata, Bisnis, Keluarga, dll',
                      ),
                      if (hasInteracted) ...[
                        const PopupMenuDivider(),
                        _buildPopupMenuItem(
                          value: 'clear',
                          icon: Icons.close_rounded,
                          title: 'Bersihkan Filter',
                          subtitle: 'Tutup rekomendasi pintar',
                          textColor: Colors.red,
                          iconColor: Colors.red,
                        ),
                      ],
                    ],
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.settings_outlined, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          gabaritoText(
                            text: 'Ganti',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isLoading) 
              _buildLoadingState()
            else if (hasInteracted && data != null) ...[
              const SizedBox(height: 24),
              _buildActiveTabContent(
                activeTab, 
                data!.mainRecommendations.where((i) => i.type == selectedType).toList(), 
                data!.inTownRecommendations.where((i) => i.type == selectedType).toList(), 
                data!.outOfTownRecommendations.where((i) => i.type == selectedType).toList(), 
                data!.category
              ),
            ],
          ],
        ),
      );
    });
  }

  IconData _getTabIcon(String tab) {
    switch (tab) {
      case 'time': return Icons.navigation_rounded;
      case 'usage': return Icons.explore_outlined;
      case 'purpose': return Icons.favorite_rounded;
      default: return Icons.auto_awesome;
    }
  }

  String _getTabLabel(bool hasInteracted, String activeTab, String category) {
    if (!hasInteracted) return "Pilih kendaraan favoritmu";
    
    switch (activeTab) {
      case 'time':
        return category == "weekend" ? "Spesial Weekend" : "Pilihan Weekday";
      case 'usage':
        return "Tujuan Perjalanan";
      case 'purpose':
        return "Tujuan Pemakaian";
      default:
        return "";
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? textColor,
    Color? iconColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.black87),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textColor ?? Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: (textColor ?? Colors.grey[500])!.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(
    String activeTab,
    List<FleetRecommendationItem> filteredMain,
    List<FleetRecommendationItem> filteredInTown,
    List<FleetRecommendationItem> filteredOutTown,
    String category,
  ) {
    switch (activeTab) {
      case 'time':
        return _buildRecommendationSection(
          title: category == "weekend" ? 'Unit Terlaris Akhir Pekan' : 'Unit Favorit Hari Kerja',
          subtitle: 'Berdasarkan ketersediaan di Cabang',
          icon: Icons.work_outline,
          iconBgColor: Colors.orange[50]!,
          iconColor: Colors.orange[600]!,
          items: filteredMain,
          context: category,
        );
      case 'usage':
        return Column(
          children: [
            _buildRecommendationSection(
              title: 'Dalam Kota',
              subtitle: 'Armada gesit untuk mobilitas perkotaan',
              icon: Icons.location_on_outlined,
              iconBgColor: Colors.blue[50]!,
              iconColor: Colors.blue[600]!,
              items: filteredInTown,
              context: 'inTown',
            ),
            if (selectedType == 'car' && filteredOutTown.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildRecommendationSection(
                title: 'Luar Kota',
                subtitle: 'Unit bertenaga dan nyaman untuk perjalanan antar kota',
                icon: Icons.explore_outlined,
                iconBgColor: Colors.green[50]!,
                iconColor: Colors.green[600]!,
                items: filteredOutTown,
                context: 'outTown',
              ),
            ],
          ],
        );
      case 'purpose':
        // Simplified purpose categories like web-app logic
        final recreation = filteredMain.take(2).toList();
        final business = filteredInTown.take(2).toList();
        final family = filteredOutTown.take(2).toList();
        final everyday = filteredMain.length > 2 ? filteredMain.skip(2).take(2).toList() : filteredMain.take(2).toList();

        return Column(
          children: [
            if (recreation.isNotEmpty)
              _buildRecommendationSection(
                title: 'Wisata & Rekreasi',
                subtitle: 'Unit yang nyaman untuk berlibur',
                icon: Icons.beach_access_outlined,
                iconBgColor: Colors.purple[50]!,
                iconColor: Colors.purple[600]!,
                items: recreation,
                context: 'recreation',
              ),
            if (business.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildRecommendationSection(
                title: 'Bisnis / Dinas',
                subtitle: 'Tampil profesional dalam perjalanan bisnis',
                icon: Icons.business_center_outlined,
                iconBgColor: Colors.indigo[50]!,
                iconColor: Colors.indigo[600]!,
                items: business,
                context: 'business',
              ),
            ],
            if (family.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildRecommendationSection(
                title: 'Acara Keluarga',
                subtitle: 'Muat banyak dan nyaman untuk sekeluarga',
                icon: Icons.people_outline,
                iconBgColor: Colors.teal[50]!,
                iconColor: Colors.teal[600]!,
                items: family,
                context: 'family',
              ),
            ],
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRecommendationSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required List<FleetRecommendationItem> items,
    required String context,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    gabaritoText(
                      text: subtitle,
                      fontSize: 10,
                      textColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 340, // Reduced height for tighter UI
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _buildRecommendationCard(items[index], context);
            },
          ),
        ),
      ],
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
      symbol: 'Rp',
      decimalDigits: 0,
    );

    String statsText;
    switch (context) {
      case 'weekend':
        statsText = 'Disewa ${item.orderCount} hari di akhir pekan';
        break;
      case 'weekday':
        statsText = 'Disewa ${item.orderCount} hari di hari kerja';
        break;
      case 'inTown':
        statsText = 'Disewa ${item.orderCount}x dalam kota';
        break;
      case 'outTown':
        statsText = 'Disewa ${item.orderCount}x luar kota';
        break;
      case 'recreation':
        statsText = 'Disewa ${item.orderCount}x untuk wisata';
        break;
      case 'business':
        statsText = 'Disewa ${item.orderCount}x untuk bisnis';
        break;
      case 'family':
        statsText = 'Disewa ${item.orderCount}x untuk keluarga';
        break;
      default:
        statsText = 'Disewa ${item.orderCount}x';
    }

    final dashboardController = Get.find<DashboardController>();

    return GestureDetector(
      onTap: () {
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
        width: 240, // Slightly narrower
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
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
                aspectRatio: 1.2, // Slightly wider aspect ratio
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
                      fontSize: 13,
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
                        ' / hari',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stats badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statsText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
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

  Widget _buildInitialView() {
    final dashboardController = Get.find<DashboardController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 14, color: primaryColor),
                const SizedBox(width: 4),
                gabaritoText(
                  text: 'Rekomendasi Pintar',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  textColor: primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Pilih kendaraan favoritmu',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: gabaritoText(
              text: 'Temukan unit terbaik berdasarkan kebiasaan penyewa lain di cabang ini',
              fontSize: 12,
              textColor: Colors.grey[600],
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              dashboardController.selectedRecommendationTab.value = 'time';
              dashboardController.hasInteractedRecommendation.value = true;
              dashboardController.fetchRecommendations();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: gabaritoText(
              text: 'Lihat Rekomendasi',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

