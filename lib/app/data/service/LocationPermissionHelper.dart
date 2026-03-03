import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/Dialog/MandatoryLocationDialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper for mandatory location access when using "Pilih Lokasi Pengambilan"
/// or "Pilih Lokasi Pengembalian" on Form Sewa.
///
/// 1. Shows an in-app prominent disclosure explaining how location (including
///    background) is used for safety and vehicle security. If the user chooses
///    "Nanti", no system permission dialog is shown and this returns false.
/// 2. If the user chooses "Izinkan & Lanjutkan", proceeds to request system
///    permission and start tracking when granted.
/// 3. If permission is denied or disabled, shows a non-dismissible modal with
///    "Buka pengaturan aplikasi"; when the user grants in settings and returns,
///    the modal auto-closes and this returns true.
class LocationPermissionHelper {
  /// Shows the Google Play–compliant, prominent disclosure dialog
  /// before the OS location permission dialog.
  static Future<bool> _showPrePermissionDisclosure(
      BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Lokasi untuk Keamanan & Kendaraan'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk membuat pengalaman sewa lebih aman dan lancar, Transgo menggunakan lokasi Anda selama masa sewa aktif, '
                'Informasi lokasi ini membantu menampilkan posisi Anda di peta bagi tim Transgo dan mendukung keamanan kendaraan bila dibutuhkan bantuan. '
                'Data lokasi tidak digunakan untuk keperluan iklan atau dijual ke pihak lain.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse('https://transgo.id/sewa/privacy-policy'),
                );
              },
              child: const Text('Kebijakan Privasi'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Izinkan & Lanjutkan'),
            ),
          ],
        );
      },
    );

    // Only proceed when user explicitly taps "Izinkan & Lanjutkan".
    return result == true;
  }

  /// Ensures location permission for the form.
  /// - If permission is already granted (whileInUse/always), it starts tracking
  ///   and returns true without showing the disclosure dialog.
  /// - If permission is not yet granted, it first shows the in-app disclosure,
  ///   then requests system permission. If the user still denies, this returns
  ///   false and the caller should block submission until lokasi pengambilan is
  ///   filled some other way.
  static Future<bool> ensureLocationForForm(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // User has disabled location services. Do not force them into settings;
      // just return false so the form can show a validation error.
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startTrackingIfLoggedIn();
      return true;
    }

    // Permission not yet granted: show the prominent disclosure once,
    // then proceed to the system dialog only if the user agrees.
    final acceptedDisclosure = await _showPrePermissionDisclosure(context);
    if (!acceptedDisclosure) {
      return false;
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startTrackingIfLoggedIn();
      return true;
    }

    // Permission denied or restricted after system dialog; respect the choice
    // and return false without showing an extra mandatory dialog.
    return false;
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
