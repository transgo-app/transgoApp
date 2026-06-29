import 'package:transgomobileapp/app/data/data.dart';

class WhatsAppLinksService {
  // Fallback hardcoded links (in case API fails)
  static const String fallbackSerahTerimaLink = 'https://chat.whatsapp.com/GZsmV1yRkJe9I3pBWk6mHI';
  static const String fallbackPusatBantuanLink = 'https://chat.whatsapp.com/GL5iTEjYcFz8TJDK0NYLqo';

  // Cache for links
  static String? _serahTerimaLink;
  static String? _pusatBantuanLink;

  static Future<Map<String, String>> fetchLinks({int? locationId, String? category}) async {
    try {
      String url = '/whatsapp-links?is_active=true&limit=10';
      if (locationId != null) {
        url += '&location_id=$locationId';
      }
      if (category != null && category.isNotEmpty) {
        url += '&category=${category.toLowerCase()}';
      }

      final response = await APIService().get(url);

      if (response != null && response['items'] != null) {
        final List<dynamic> items = response['items'];
        
        String? serahTerimaLink;
        String? pusatBantuanLink;

        // Try to match by type first
        for (var item in items) {
          if (item['is_active'] == true) {
            final type = item['type'] as String?;
            final link = item['link'] as String?;

            if (type == 'serah_terima' && link != null && link.isNotEmpty) {
              serahTerimaLink = link;
            } else if (type == 'pusat_bantuan' && link != null && link.isNotEmpty) {
              pusatBantuanLink = link;
            }
          }
        }

        // Fallback to name or id if type didn't match
        if (serahTerimaLink == null || pusatBantuanLink == null) {
          for (var item in items) {
            if (item['is_active'] == true) {
              final id = item['id'];
              final name = (item['name'] as String?)?.toLowerCase() ?? '';
              final link = item['link'] as String?;

              if (link != null && link.isNotEmpty) {
                if (id == 1 || name.contains('serah terima')) {
                  serahTerimaLink ??= link;
                } else if (id == 2 || name.contains('pusat bantuan') || name.contains('bantuan')) {
                  pusatBantuanLink ??= link;
                }
              }
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
