import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

const String baseUrl = 'https://develop.transgo.id/api/v1';
const username = 'admin';
const password = 'admin';
// const String baseUrl = 'https://api.transgo.id/api/v1';
// const username = 'LINhzGdEo9';
// const password ='l5vEiYS7HO';
String whatsAppNumberAdmin = '6281389292879';

class APIService {
  String generateBasicAuth(String username, String password) {
  String credentials = '$username:$password';
  String encoded = base64Encode(utf8.encode(credentials));
  return 'Basic $encoded';
}


dynamic _handleResponse(http.Response response, String endpoint) {
  print(response.statusCode);
  print(response.body);
  print("${baseUrl}${endpoint}");
  final decodedBody = jsonDecode(response.body); 
  if(response.statusCode == 403){
    CustomSnackbar.show(title: "Terjadi Kesalahan", message: "Silahkan Login Kembali", icon: Icons.account_circle);
    GlobalVariables.resetData();
    Get.offAndToNamed('/login');
  }

  if(response.statusCode == 409){
    return CustomSnackbar.show(
      title: "Terjadi Kesalahan",
      message: "${decodedBody['message']}",
      icon: Icons.person_2,
    );
  }
  
  if (response.statusCode == 404 && endpoint == '/auth/login/customer') {
    return CustomSnackbar.show(
      title: "Terjadi Kesalahan",
      message: "${decodedBody['message']}",
      icon: Icons.person_2,
    );
  }
  
  if (response.statusCode == 404 && endpoint == '/auth/password/forgot') {
    return CustomSnackbar.show(
      title: "Terjadi Kesalahan",
      message: "Email Tidak Ditemukan. Silahkan Gunakan Email Valid Anda",
      icon: Icons.person_2,
    );
  }

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    try {
      final errorResponse = jsonDecode(response.body);
      final errorCode = errorResponse['code'] ?? '';

      switch (errorCode) {
        case 'user_email_unique':
          CustomSnackbar.show(
            title: 'Email sudah terdaftar sebelumnya',
            message: "Coba lakukan Lupa Password",
            icon: Icons.mail,
            backgroundColor: Colors.red,
          );
          break;
        case 'fleet_already_booked':
          CustomSnackbar.show(
            title: 'Armada sudah terbooking',
            message: "Silahkan cari armada/jadwal lain",
            icon: Icons.car_crash_outlined,
            backgroundColor: Colors.red,
          );
          break;
        case 'cannot_deactivate_account':
          CustomSnackbar.show(
            title: 'Terjadi Kesalahan',
            message: "${decodedBody['message']}",
            icon: Icons.car_rental_rounded,
            backgroundColor: Colors.red,
          );
          break;
        default:
            CustomSnackbar.show(
            title: 'Terjadi Kesalahan $endpoint',
            message: "${decodedBody['message']}",
            icon: Icons.car_crash_outlined,
            backgroundColor: Colors.red,
          );
      }
    } catch (e) {
      throw Exception({
        'title': 'Kesalahan parsing respons',
        'description': 'Tidak dapat memproses respons: ${response.body}'
      });
    }
  }

}


  // GET request
  Future<dynamic> get(String endpoint) async {
    print(endpoint);
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
    'Content-Type': 'application/json',
    'Authorization': '${GlobalVariables.token.value == '' ? generateBasicAuth('$username', '$password') : 'Bearer ${GlobalVariables.token.value}'}'
    };
    print(headersAuth);
    try {
      final response = await http.get(url, headers: headersAuth );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
        print(data);
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
    'Content-Type': 'application/json',
    'Authorization': '${GlobalVariables.token.value == '' ? generateBasicAuth('$username', '$password') : 'Bearer ${GlobalVariables.token.value}'}'
    };
    print(headersAuth);
    try {
      final response = await http.post(
        url,
        headers: headersAuth,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var headersAuth = {
    'Content-Type': 'application/json',
    'Authorization': '${GlobalVariables.token.value == '' ? generateBasicAuth('$username', '$password') : 'Bearer ${GlobalVariables.token.value}'}'
    };
    try {
      final response = await http.put(
        url,
        headers: headersAuth,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    print(endpoint);
    print('delete dijalankan');
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': '${GlobalVariables.token.value == '' ? generateBasicAuth('$username', '$password') : 'Bearer ${GlobalVariables.token.value}'}'
      });
      return _handleResponse(response, endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
