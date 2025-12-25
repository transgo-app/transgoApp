import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transgomobileapp/app/data/data.dart';

Future<void> saveUserDataToPrefs(
  Map<String, dynamic> dataUser,
  Map<String, dynamic> user, {
  required String tokenKey,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String token = getValueFromKeyPath(user, tokenKey);

  await prefs.setString('namaUser', dataUser['name'] ?? '');
  await prefs.setString('emailUser', dataUser['email'] ?? '');
  await prefs.setString('role', dataUser['role'] ?? '');
  await prefs.setString('noTelp', dataUser['phone_number'] ?? '');
  await prefs.setString('noTelpDarurat', dataUser['emergency_phone_number'] ?? '');
  await prefs.setString('jenisKelamin', dataUser['gender'] ?? '');
  await prefs.setString('tanggalLahir', dataUser['date_of_birth'] ?? '');
  await prefs.setString('accessToken', token);
  await prefs.setString('idCards', dataUser['id_cards'] != null ? jsonEncode(dataUser['id_cards']) : '');

  GlobalVariables.namaUser.value = dataUser['name'] ?? '';
  GlobalVariables.emailUser.value = dataUser['email'] ?? '';
  GlobalVariables.nomorTelepon.value = dataUser['phone_number'] ?? '';
  GlobalVariables.nomorDarurat.value = dataUser['emergency_phone_number'] ?? '';
  GlobalVariables.jenisKelamin.value = dataUser['gender'] ?? '';
  GlobalVariables.tanggalLahir.value = dataUser['date_of_birth'] ?? '';
  GlobalVariables.idCards.value = dataUser['id_cards'] != null ? jsonEncode(dataUser['id_cards']) : '';
  GlobalVariables.token.value = token;
}

String getValueFromKeyPath(Map<String, dynamic> map, String path) {
  try {
    dynamic current = map;
    for (final part in path.split('.')) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return '';
      }
    }
    return current?.toString() ?? '';
  } catch (_) {
    return '';
  }
}
