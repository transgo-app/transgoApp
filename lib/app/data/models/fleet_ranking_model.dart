/// Fleet Ranking Data Models
/// Based on backend-api GET /fleets/ranking/revenue response

class FleetRankingByLocation {
  final int? locationId;
  final String locationName;
  final int orders;
  final int rentalDays;

  FleetRankingByLocation({
    this.locationId,
    required this.locationName,
    required this.orders,
    required this.rentalDays,
  });

  factory FleetRankingByLocation.fromJson(Map<String, dynamic> json) {
    return FleetRankingByLocation(
      locationId: json['location_id'],
      locationName: json['location_name'] ?? 'Unknown',
      orders: json['orders'] ?? 0,
      rentalDays: json['rental_days'] ?? 0,
    );
  }
}

class FleetRankingItem {
  final int rank;
  final int fleetId;
  final String fleetName;
  final String fleetPlateNumber;
  final String fleetType;
  final String fleetColor;
  final String fleetTier;
  final double totalRevenue;
  final int totalOrders;
  final int totalRentalDays;
  final double averageRating;
  final int ratingCount;
  final List<String> photoUrls;
  final List<FleetRankingByLocation> byLocation;

  FleetRankingItem({
    required this.rank,
    required this.fleetId,
    required this.fleetName,
    required this.fleetPlateNumber,
    required this.fleetType,
    required this.fleetColor,
    required this.fleetTier,
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalRentalDays,
    required this.averageRating,
    required this.ratingCount,
    required this.photoUrls,
    required this.byLocation,
  });

  factory FleetRankingItem.fromJson(Map<String, dynamic> json) {
    return FleetRankingItem(
      rank: json['rank'] ?? 0,
      fleetId: json['fleet_id'] ?? 0,
      fleetName: json['fleet_name'] ?? '',
      fleetPlateNumber: json['fleet_plate_number'] ?? '',
      fleetType: json['fleet_type'] ?? 'car',
      fleetColor: json['fleet_color'] ?? '',
      fleetTier: json['fleet_tier'] ?? 'reguler',
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      totalRentalDays: json['total_rental_days'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      byLocation: (json['by_location'] as List<dynamic>?)
              ?.map((e) => FleetRankingByLocation.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Get the first photo URL or null if none
  String? get primaryPhoto => photoUrls.isNotEmpty ? photoUrls.first : null;

  /// Get primary location name from by_location
  String? get primaryLocationName =>
      byLocation.isNotEmpty ? byLocation.first.locationName : null;
}

class FleetRankingMeta {
  final int totalFleets;
  final int limit;
  final String? thisWeek;
  final bool isWeeklyFilter;
  final String? type;

  FleetRankingMeta({
    required this.totalFleets,
    required this.limit,
    this.thisWeek,
    required this.isWeeklyFilter,
    this.type,
  });

  factory FleetRankingMeta.fromJson(Map<String, dynamic> json) {
    return FleetRankingMeta(
      totalFleets: json['total_fleets'] ?? 0,
      limit: json['limit'] ?? 10,
      thisWeek: json['this_week']?.toString(),
      isWeeklyFilter: json['is_weekly_filter'] ?? false,
      type: json['type'],
    );
  }
}

class FleetRankingResponse {
  final bool success;
  final String message;
  final List<FleetRankingItem> data;
  final FleetRankingMeta meta;

  FleetRankingResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory FleetRankingResponse.fromJson(Map<String, dynamic> json) {
    return FleetRankingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => FleetRankingItem.fromJson(e))
              .toList() ??
          [],
      meta: FleetRankingMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
