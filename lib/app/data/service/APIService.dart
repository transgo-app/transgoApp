import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

// const String baseUrl = 'https://develop.transgo.id/api/v1';
// const username = 'admin';
// const password = 'admin';
const String baseUrl = 'https://api.transgo.id/api/v1';
const username = 'LINhzGdEo9';
const password = 'l5vEiYS7HO';
String whatsAppNumberAdmin = '6281389292879';

/// Cache entry for HTTP responses
class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration ttl;

  _CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl = const Duration(minutes: 5),
  });

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

class APIService {
  // HTTP response cache
  static final Map<String, _CacheEntry> _cache = {};
  
  /// Check if endpoint should be cached
  bool _shouldCache(String endpoint) {
    // Don't cache auth endpoints, orders, or dynamic endpoints
    final noCacheEndpoints = [
      '/auth/',
      '/auth', // Also match without trailing slash
      '/orders/', // Match with trailing slash
      '/orders', // Match without trailing slash (e.g., /orders?page=1)
      '/topup/',
      '/topup', // Also match without trailing slash
      '/flash-sales', // Flash sales change frequently
    ];
    return !noCacheEndpoints.any((pattern) => endpoint.contains(pattern));
  }
  
  /// Clear cache for specific endpoint or all cache
  static void clearCache([String? endpoint]) {
    if (endpoint != null) {
      _cache.remove(endpoint);
    } else {
      _cache.clear();
    }
  }
  
  /// Clear expired cache entries
  static void _clearExpiredCache() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }
  String generateBasicAuth(String username, String password) {
    String credentials = '$username:$password';
    String encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  /// Check if endpoint requires Basic Auth (always use Basic Auth for auth endpoints)
  bool _requiresBasicAuth(String endpoint) {
    final authEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/password/forgot',
      '/auth/password/reset',
    ];
    return authEndpoints.any((authEndpoint) => endpoint.contains(authEndpoint));
  }

  /// Get authorization header based on endpoint and token availability
  String _getAuthorizationHeader(String endpoint) {
    // Always use Basic Auth for authentication endpoints
    if (_requiresBasicAuth(endpoint)) {
      return generateBasicAuth(username, password);
    }
    // For other endpoints, use Bearer token if available, otherwise Basic Auth
    return GlobalVariables.token.value == ''
        ? generateBasicAuth(username, password)
        : 'Bearer ${GlobalVariables.token.value}';
  }

  dynamic _handleResponse(http.Response response, String endpoint) {
    print(response.statusCode);
    print(response.body);
    print("${baseUrl}${endpoint}");
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 403) {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan Login Kembali",
          icon: Icons.account_circle);
      GlobalVariables.resetData();
      Get.offAndToNamed('/login');
    }

    if (response.statusCode == 409) {
      return CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "${decodedBody['message']}",
        icon: Icons.person_2,
      );
    }

    if (response.statusCode == 404 && endpoint == '/auth/login/customer') {
      return CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "${decodedBody['message']}",
        icon: Icons.person_2,
      );
    }

    if (response.statusCode == 404 && endpoint == '/auth/password/forgot') {
      return CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Email Tidak Ditemukan. Silahkan Gunakan Email Valid Anda",
        icon: Icons.person_2,
      );
    }

    // Handle 422 Unprocessable Entity errors
    if (response.statusCode == 422) {
      final message = decodedBody['message'] ?? 'Data tidak valid';
      if (message.toString().toLowerCase().contains('customer')) {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Akun Anda belum terdaftar sebagai customer. Silakan lengkapi profil Anda terlebih dahulu atau hubungi admin.",
          icon: Icons.person_2,
          backgroundColor: Colors.red,
        );
      } else {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: message.toString(),
          icon: Icons.error,
          backgroundColor: Colors.red,
        );
      }
      throw Exception(message);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        final errorCode = errorResponse['code'] ?? '';

        switch (errorCode) {
          case 'user_email_unique':
            CustomSnackbar.show(
              title: 'Email sudah terdaftar sebelumnya',
              message: "Coba lakukan Lupa Password",
              icon: Icons.mail,
              backgroundColor: Colors.red,
            );
            break;
          case 'fleet_already_booked':
            CustomSnackbar.show(
              title: 'Armada sudah terbooking',
              message: "Silahkan cari armada/jadwal lain",
              icon: Icons.car_crash_outlined,
              backgroundColor: Colors.red,
            );
            break;
          case 'cannot_deactivate_account':
            CustomSnackbar.show(
              title: 'Terjadi Kesalahan',
              message: "${decodedBody['message']}",
              icon: Icons.car_rental_rounded,
              backgroundColor: Colors.red,
            );
            break;
          default:
            CustomSnackbar.show(
              title: 'Terjadi Kesalahan $endpoint',
              message: "${decodedBody['message']}",
              icon: Icons.car_crash_outlined,
              backgroundColor: Colors.red,
            );
        }
      } catch (e) {
        throw Exception({
          'title': 'Kesalahan parsing respons',
          'description': 'Tidak dapat memproses respons: ${response.body}'
        });
      }
    }
  }

  // GET request with caching
  Future<dynamic> get(String endpoint, {bool useCache = true}) async {
    print(endpoint);
    
    // Check cache first
    if (useCache && _shouldCache(endpoint)) {
      _clearExpiredCache();
      final cached = _cache[endpoint];
      if (cached != null && !cached.isExpired) {
        print('Cache hit for: $endpoint');
        return cached.data;
      }
    }
    
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
      'Content-Type': 'application/json',
      'Authorization': _getAuthorizationHeader(endpoint),
    };
    print(headersAuth);
    try {
      final response = await http.get(url, headers: headersAuth);
      final data = _handleResponse(response, endpoint);
      
      // Cache successful GET responses
      if (useCache && _shouldCache(endpoint) && data != null) {
        // Use longer TTL for static data like locations, brands
        Duration ttl = const Duration(minutes: 10);
        if (endpoint.contains('/locations') || 
            endpoint.contains('/fleets/?') ||
            endpoint.contains('/brands')) {
          ttl = const Duration(minutes: 30);
        }
        
        _cache[endpoint] = _CacheEntry(
          data: data,
          timestamp: DateTime.now(),
          ttl: ttl,
        );
        print('Cached response for: $endpoint');
      }
      
      return data;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    print(data);
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
      'Content-Type': 'application/json',
      'Authorization': _getAuthorizationHeader(endpoint),
    };
    print(headersAuth);
    try {
      final response = await http.post(
        url,
        headers: headersAuth,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
      'Content-Type': 'application/json',
      'Authorization': _getAuthorizationHeader(endpoint),
    };
    try {
      final response = await http.put(
        url,
        headers: headersAuth,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<dynamic> patch(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
      'Content-Type': 'application/json',
      'Authorization': _getAuthorizationHeader(endpoint),
    };
    try {
      final response = await http.patch(
        url,
        headers: headersAuth,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }
  String getWhatsAppAdminUrl() {
    const message =
        'Halo admin Transgo, saya ingin bertanya terkait layanan yang tersedia. Terima kasih.';
    final encodedMessage = Uri.encodeComponent(message);

    return 'https://wa.me/$whatsAppNumberAdmin?text=$encodedMessage';
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    print(endpoint);
    print('delete dijalankan');
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': _getAuthorizationHeader(endpoint),
      });
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
