import 'package:transgomobileapp/app/data/data.dart';

class WhatsAppLinksService {
  // Fallback hardcoded links (in case API fails)
  static const String fallbackSerahTerimaLink = 'https://chat.whatsapp.com/GZsmV1yRkJe9I3pBWk6mHI';
  static const String fallbackPusatBantuanLink = 'https://chat.whatsapp.com/GL5iTEjYcFz8TJDK0NYLqo';

  // Cache for links
  static String? _serahTerimaLink;
  static String? _pusatBantuanLink;

  /// Fetch WhatsApp links from API
  /// Returns a map with 'serahTerima' and 'pusatBantuan' keys
  static Future<Map<String, String>> fetchLinks() async {
    try {
      final response = await APIService().get('/whatsapp-links');

      if (response != null && response['items'] != null) {
        final List<dynamic> items = response['items'];
        
        // Find links by ID
        // ID 1 = Grup Serah Terima
        // ID 2 = Pusat Bantuan Rental
        String? serahTerimaLink;
        String? pusatBantuanLink;

        for (var item in items) {
          if (item['is_active'] == true) {
            final id = item['id'];
            final link = item['link'] as String?;

            if (id == 1 && link != null && link.isNotEmpty) {
              serahTerimaLink = link;
            } else if (id == 2 && link != null && link.isNotEmpty) {
              pusatBantuanLink = link;
            }
          }
        }

        // Use fetched links or fallback to hardcoded
        _serahTerimaLink = serahTerimaLink ?? fallbackSerahTerimaLink;
        _pusatBantuanLink = pusatBantuanLink ?? fallbackPusatBantuanLink;

        return {
          'serahTerima': _serahTerimaLink!,
          'pusatBantuan': _pusatBantuanLink!,
        };
      } else {
        // API returned null or invalid response, use fallback
        return _getFallbackLinks();
      }
    } catch (e) {
      print('Error fetching WhatsApp links: $e');
      // On error, use fallback links
      return _getFallbackLinks();
    }
  }

  /// Get fallback links
  static Map<String, String> _getFallbackLinks() {
    _serahTerimaLink = fallbackSerahTerimaLink;
    _pusatBantuanLink = fallbackPusatBantuanLink;
    return {
      'serahTerima': fallbackSerahTerimaLink,
      'pusatBantuan': fallbackPusatBantuanLink,
    };
  }

  /// Get cached Serah Terima link (or fallback)
  static String getSerahTerimaLink() {
    return _serahTerimaLink ?? fallbackSerahTerimaLink;
  }

  /// Get cached Pusat Bantuan link (or fallback)
  static String getPusatBantuanLink() {
    return _pusatBantuanLink ?? fallbackPusatBantuanLink;
  }
}
