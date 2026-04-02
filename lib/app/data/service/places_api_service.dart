import 'package:transgomobileapp/app/data/service/APIService.dart';

class PlacePrediction {
  final String placeId;
  final String description;

  PlacePrediction({required this.placeId, required this.description});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class PlaceDetailsResult {
  final double lat;
  final double lng;
  final String formattedAddress;

  PlaceDetailsResult({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
  });

  factory PlaceDetailsResult.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResult(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      formattedAddress: json['formatted_address']?.toString() ?? '',
    );
  }
}

/// Backend proxy for Google Places (requires customer JWT).
class PlacesApiService {
  Future<List<PlacePrediction>> autocomplete(String input, {String? sessionToken}) async {
    if (input.trim().length < 2) return [];
    final q = Uri.encodeQueryComponent(input.trim());
    var path = '/places/autocomplete?input=$q';
    if (sessionToken != null && sessionToken.isNotEmpty) {
      path += '&session_token=${Uri.encodeQueryComponent(sessionToken)}';
    }
    final raw = await APIService().get(path, useCache: false);
    if (raw == null) return [];
    final items = raw['items'];
    if (items is! List) return [];
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => PlacePrediction.fromJson(e))
        .where((p) => p.placeId.isNotEmpty)
        .toList();
  }

  Future<PlaceDetailsResult> details(String placeId, {String? sessionToken}) async {
    var path =
        '/places/details?place_id=${Uri.encodeQueryComponent(placeId)}';
    if (sessionToken != null && sessionToken.isNotEmpty) {
      path += '&session_token=${Uri.encodeQueryComponent(sessionToken)}';
    }
    final raw = await APIService().get(path, useCache: false);
    if (raw is! Map<String, dynamic>) {
      throw Exception('Invalid place details response');
    }
    return PlaceDetailsResult.fromJson(raw);
  }
}
