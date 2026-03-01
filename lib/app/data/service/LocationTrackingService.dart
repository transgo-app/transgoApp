import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/data/service/APIService.dart';

/// Sends the logged-in customer's location to the backend for dashboard tracking maps.
/// Requests location permission on start; runs a periodic update while the app is in use.
class LocationTrackingService {
  LocationTrackingService._();
  static final LocationTrackingService _instance = LocationTrackingService._();
  static LocationTrackingService get instance => _instance;

  static const String _endpoint = '/customer-locations';
  static const Duration _interval = Duration(seconds: 45);

  Timer? _timer;
  bool _isRunning = false;
  String? _currentToken; // Track the token used when starting

  bool get isRunning => _isRunning;

  /// Request location permission (when-in-use or always for background).
  /// Returns true if we have at least when-in-use (or always) permission.
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('LocationTracking: location service disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint('LocationTracking: permission denied forever');
      return false;
    }
    if (permission == LocationPermission.denied) {
      debugPrint('LocationTracking: permission denied');
      return false;
    }

    // On Android, optionally prompt for "always" for background. On iOS we use
    // foreground-only (Option A), so "while in use" is sufficient.
    if (!Platform.isIOS && permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Start tracking: request permission, then send location every [_interval].
  /// No-op if not logged in (no token).
  /// If already running with a different token, stops and restarts with new token.
  Future<void> start() async {
    if (GlobalVariables.token.value.isEmpty) {
      debugPrint('LocationTracking: not started (not logged in)');
      return;
    }

    final newToken = GlobalVariables.token.value;
    
    // If already running, check if token changed
    if (_isRunning) {
      if (_currentToken == newToken) {
        debugPrint('LocationTracking: already running with same token');
        return;
      }
      // Token changed - stop and restart with new token
      debugPrint('LocationTracking: token changed, restarting...');
      stop();
    }

    final allowed = await requestPermission();
    if (!allowed) {
      debugPrint('LocationTracking: not started (no permission)');
      return;
    }

    _currentToken = newToken;
    _isRunning = true;
    debugPrint('LocationTracking: started, interval ${_interval.inSeconds}s');

    // Foreground service for background (Android): save data and start service
    if (!kIsWeb && Platform.isAndroid) {
      await FlutterForegroundTask.saveData(key: 'location_tracking_base_url', value: APIService.apiBaseUrl);
      await FlutterForegroundTask.saveData(key: 'location_tracking_token', value: newToken);
      await FlutterForegroundTask.saveData(key: 'location_tracking_endpoint', value: _endpoint);
      await FlutterForegroundTask.startService(
        notificationTitle: 'Transgo',
        notificationText: 'Mengirim lokasi untuk peta dashboard',
        serviceTypes: [ForegroundServiceTypes.location],
      );
    }

    // Send once immediately, then on interval (foreground)
    _sendLocationOnce();
    _timer = Timer.periodic(_interval, (_) => _sendLocationOnce());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _currentToken = null; // Clear token when stopping
    if (!kIsWeb && Platform.isAndroid) {
      FlutterForegroundTask.stopService();
    }
    debugPrint('LocationTracking: stopped');
  }

  Future<void> _sendLocationOnce() async {
    final currentToken = GlobalVariables.token.value;
    
    // Check if token is empty or changed
    if (currentToken.isEmpty) {
      stop();
      return;
    }
    
    // If token changed while running, restart with new token
    if (_currentToken != null && _currentToken != currentToken) {
      debugPrint('LocationTracking: token changed during tracking, restarting...');
      stop();
      await start();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          address = [
            p.street,
            p.subLocality,
            p.locality,
            p.administrativeArea,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          if (address.isEmpty) address = p.country;
        }
      } catch (_) {
        // optional; continue without address
      }

      final body = <String, dynamic>{
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      if (address != null && address.isNotEmpty) body['address'] = address;

      await APIService().post(_endpoint, body);
      debugPrint('LocationTracking: sent ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('LocationTracking: send failed $e');
    }
  }
}
