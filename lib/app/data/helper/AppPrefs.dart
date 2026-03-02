import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction over SharedPreferences so we can use an in-memory fallback on iOS
/// when the native SharedPreferencesPlugin is disabled (to avoid cold-start crash).
abstract class AppPrefs {
  String? getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
}

/// In-memory implementation used when SharedPreferences plugin is not available (e.g. iOS).
/// Data is lost when the app process is killed.
class InMemoryPrefs implements AppPrefs {
  final Map<String, String> _map = {};

  @override
  String? getString(String key) => _map[key];

  @override
  Future<bool> setString(String key, String value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _map.remove(key);
    return true;
  }
}

/// Wraps the real SharedPreferences to implement AppPrefs.
class _SharedPreferencesAdapter implements AppPrefs {
  _SharedPreferencesAdapter(this._prefs);
  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);
}

/// Returns AppPrefs: real SharedPreferences on platforms where the plugin works,
/// or in-memory fallback on iOS when the plugin is disabled.
Future<AppPrefs> getAppPrefs() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return _SharedPreferencesAdapter(prefs);
  } catch (_) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('AppPrefs: SharedPreferences not available, using in-memory fallback (e.g. iOS with plugin disabled)');
    }
    return InMemoryPrefs();
  }
}
