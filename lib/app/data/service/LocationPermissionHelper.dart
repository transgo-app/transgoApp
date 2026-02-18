import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/Dialog/MandatoryLocationDialog.dart';

/// Helper for mandatory location access when using "Pilih Lokasi Pengambilan"
/// or "Pilih Lokasi Pengembalian" on Form Sewa.
///
/// 1. If permission already granted → returns true.
/// 2. If denied → shows system permission request.
/// 3. If user grants → returns true.
/// 4. If user rejects → shows non-dismissible modal with "Buka pengaturan aplikasi";
///    when user grants in settings and returns, modal auto-closes and returns true.
class LocationPermissionHelper {
  /// Ensures location permission for the form. Shows system request first;
  /// if still denied, shows mandatory modal that opens app settings and
  /// auto-closes when permission is granted.
  /// Returns true when permission is granted (now or after user returns from settings).
  static Future<bool> ensureLocationForForm(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showMandatoryAndWait(context);
      final granted = await _hasPermission();
      if (granted) _startTrackingIfLoggedIn();
      return granted;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startTrackingIfLoggedIn();
      return true;
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startTrackingIfLoggedIn();
      return true;
    }

    await _showMandatoryAndWait(context);
    final granted = await _hasPermission();
    if (granted) _startTrackingIfLoggedIn();
    return granted;
  }

  /// Start 45s location tracking when user is logged in (e.g. after granting permission anywhere in app).
  static void _startTrackingIfLoggedIn() {
    if (GlobalVariables.token.value.isNotEmpty) {
      LocationTrackingService.instance.start();
    }
  }

  static Future<bool> _hasPermission() async {
    final p = await Geolocator.checkPermission();
    return p == LocationPermission.whileInUse ||
        p == LocationPermission.always;
  }

  static Future<void> _showMandatoryAndWait(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const MandatoryLocationDialog(),
    );
  }
}
