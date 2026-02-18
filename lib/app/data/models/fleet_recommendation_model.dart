/// Fleet Recommendation Data Models
/// Based on backend-api GET /fleets/recommendations response

class FleetRecommendationItem {
  final int id;
  final String name;
  final String type;
  final String color;
  final String plateNumber;
  final int price;
  final int? priceAfterDiscount;
  final int? finalPrice;
  final int discount;
  final bool hasFlashSale;
  final String? flashSaleName;
  final double averageRating;
  final int ratingCount;
  final String orderCount;
  final Map<String, dynamic>? photo;
  final Map<String, dynamic>? location;
  final String? tier;

  FleetRecommendationItem({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.plateNumber,
    required this.price,
    this.priceAfterDiscount,
    this.finalPrice,
    required this.discount,
    required this.hasFlashSale,
    this.flashSaleName,
    required this.averageRating,
    required this.ratingCount,
    required this.orderCount,
    this.photo,
    this.location,
    this.tier,
  });

  factory FleetRecommendationItem.fromJson(Map<String, dynamic> json) {
    return FleetRecommendationItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 'car',
      color: json['color'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      price: json['price'] ?? 0,
      priceAfterDiscount: json['price_after_discount'],
      finalPrice: json['final_price'],
      discount: json['discount'] ?? 0,
      hasFlashSale: json['has_flash_sale'] ?? false,
      flashSaleName: json['flash_sale_name'],
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      orderCount: json['order_count']?.toString() ?? '0',
      photo: json['photo'],
      location: json['location'],
      tier: json['tier'],
    );
  }

  /// Get photo URL from nested photo object
  String? get photoUrl => photo?['photo'];

  /// Get location name from nested location object
  String? get locationName => location?['name'];

  /// Get effective price (after discount or flash sale)
  int get effectivePrice => finalPrice ?? priceAfterDiscount ?? price;
}

class FleetRecommendationResponse {
  final String category; // 'weekday' or 'weekend'
  final List<FleetRecommendationItem> mainRecommendations;
  final List<FleetRecommendationItem> inTownRecommendations;
  final List<FleetRecommendationItem> outOfTownRecommendations;

  FleetRecommendationResponse({
    required this.category,
    required this.mainRecommendations,
    required this.inTownRecommendations,
    required this.outOfTownRecommendations,
  });

  factory FleetRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return FleetRecommendationResponse(
      category: json['category'] ?? 'weekday',
      mainRecommendations: (json['main_recommendations'] as List<dynamic>?)
              ?.map((e) => FleetRecommendationItem.fromJson(e))
              .toList() ??
          [],
      inTownRecommendations: (json['in_town_recommendations'] as List<dynamic>?)
              ?.map((e) => FleetRecommendationItem.fromJson(e))
              .toList() ??
          [],
      outOfTownRecommendations:
          (json['out_of_town_recommendations'] as List<dynamic>?)
                  ?.map((e) => FleetRecommendationItem.fromJson(e))
                  .toList() ??
              [],
    );
  }

  /// Check if this is a weekend period
  bool get isWeekend => category == 'weekend';

  /// Check if there are any recommendations
  bool get hasRecommendations =>
      mainRecommendations.isNotEmpty ||
      inTownRecommendations.isNotEmpty ||
      outOfTownRecommendations.isNotEmpty;
}
