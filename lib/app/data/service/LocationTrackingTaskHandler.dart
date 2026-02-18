import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Task handler that runs in a separate isolate for background location updates.
/// Reads baseUrl, token, endpoint from saved data; every 45s gets position and POSTs.
@pragma('vm:entry-point')
class LocationTrackingTaskHandler extends TaskHandler {
  String? _baseUrl;
  String? _token;
  String? _endpoint;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _baseUrl = await FlutterForegroundTask.getData<String>(key: 'location_tracking_base_url');
    _token = await FlutterForegroundTask.getData<String>(key: 'location_tracking_token');
    _endpoint = await FlutterForegroundTask.getData<String>(key: 'location_tracking_endpoint');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _sendLocationOnce();
  }

  Future<void> _sendLocationOnce() async {
    if (_baseUrl == null || _token == null || _token!.isEmpty || _endpoint == null) return;

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
          if (address != null && address.isEmpty) address = p.country;
        }
      } catch (_) {}

      final body = <String, dynamic>{
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      if (address != null && address.isNotEmpty) body['address'] = address;

      final url = Uri.parse('$_baseUrl$_endpoint');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      debugPrint('LocationTrackingTaskHandler: send failed $e');
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onReceiveData(Object data) {}
}
