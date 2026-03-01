import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches a URL externally. Uses platformDefault on iOS to avoid
/// LaunchMode.externalApplication issues; uses externalApplication on Android.
Future<bool> launchExternalUrl(Uri uri) async {
  if (!await canLaunchUrl(uri)) return false;
  try {
    await launchUrl(
      uri,
      mode: defaultTargetPlatform == TargetPlatform.iOS
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
    return true;
  } catch (_) {
    return false;
  }
}
