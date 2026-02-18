import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

/// A non-dismissible dialog that informs the user that location access is mandatory.
/// Shows a button to open app permission settings. Auto-closes when the user
/// grants location permission (e.g. after returning from settings).
class MandatoryLocationDialog extends StatefulWidget {
  const MandatoryLocationDialog({super.key});

  @override
  State<MandatoryLocationDialog> createState() => _MandatoryLocationDialogState();
}

class _MandatoryLocationDialogState extends State<MandatoryLocationDialog>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndClose();
    }
  }

  Future<void> _checkPermissionAndClose() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (mounted) {
        Navigator.of(context).pop(true);
        // Auto-start 45s location tracking when user grants permission
        if (GlobalVariables.token.value.isNotEmpty) {
          LocationTrackingService.instance.start();
        }
      }
    }
  }

  Future<void> _openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 56,
                color: Colors.orange.shade700,
              ),
              const SizedBox(height: 16),
              gabaritoText(
                text: "Akses lokasi wajib",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                textColor: textHeadline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              gabaritoText(
                text:
                    "Untuk memilih lokasi pengambilan dan pengembalian, Transgo membutuhkan akses lokasi. Silakan aktifkan izin lokasi di pengaturan aplikasi.",
                fontSize: 14,
                textColor: textSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ReusableButton(
                height: 50,
                title: "Buka pengaturan aplikasi",
                bgColor: primaryColor,
                ontap: _openAppSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
