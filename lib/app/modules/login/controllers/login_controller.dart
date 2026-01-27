import 'dart:convert';
import 'dart:io';
import 'package:transgomobileapp/app/data/helper/SharedPrefsHelper.dart';
import 'package:transgomobileapp/app/routes/Navbar.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
import '../../../services/google_auth_service.dart';
class LoginController extends GetxController {

  
  @override
  void onInit() {
    super.onInit();
    emailC.addListener(() {
      validateInput();
    },);
    passwordC.addListener(() {
      validateInput();
    },);
    
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController lupaPasswordC = TextEditingController();
  RxBool passwordHint = true.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingLupaPassword = false.obs;
  RxString loginData = ''.obs;
  RxString errorTextEmail = ''.obs;
  RxString errorTextPassword = ''.obs;
  RxString aktifTabPage = 'Masuk'.obs;
  Color get buttonColor => lupaPasswordC.value.text.isEmpty ? Colors.grey : Colors.blue;

  void validateInput() {
    if (emailC.text.isEmpty) {
      errorTextEmail.value = 'Email Tidak Boleh Kosong';
    } else {
      errorTextEmail.value = '';
    }

    if (passwordC.text.isEmpty) {
      errorTextPassword.value = 'Password Tidak Boleh Kosong';
    } else {
      errorTextPassword.value = '';
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final idToken =
          await GoogleAuthService.instance.getIdToken(forceAccountSelection: true);
      if (idToken == null) {
        // User batal memilih akun atau terjadi error, diam saja sesuai requirement.
        return;
      }

      final data = {
        'id_token': idToken,
        'token': GlobalVariables.fcmToken.value,
      };

      final response =
          await APIService().post('/auth/login/google', data);

      if (response != null && response['data'] != null) {
        final responseData = response['data'];

        // Jika backend mengindikasikan bahwa user harus registrasi dulu
        if (responseData['requires_register'] == true) {
          final email = responseData['email'] as String? ?? '';
          final name = responseData['name'] as String? ?? '';

          CustomSnackbar.show(
            title: "Perhatian",
            message:
                "Akun dengan email tersebut tidak tersedia, silahkan daftar terlebih dahulu.",
            backgroundColor: Colors.orange,
          );

          final arguments = {
            'paramPost': {},
            'detailKendaraan': null,
            'prefillFromGoogle': {
              'name': name,
              'email': email,
            },
          };

          Get.toNamed('/register', arguments: arguments);
          return;
        }

        final dataUser = responseData['user'];

        await saveUserDataToPrefs(
          dataUser,
          response,
          tokenKey: 'data.token',
        );

        CustomSnackbar.show(
          title: "Berhasil",
          message: "Berhasil masuk dengan Google",
          icon: Icons.check,
          backgroundColor: Colors.green,
        );

        Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => NavigationPage(selectedIndex: 0),
          ),
        );
      }
    } catch (e) {
      print('Error during Google login: $e');
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal masuk dengan Google. Silakan coba lagi.",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser() async {
  isLoading.value = true;

  var data = {
    'email': emailC.value.text,
    'password': passwordC.value.text,
    'token': GlobalVariables.fcmToken.value,
  };

  print('ini data $data');

  try {
    final user = await APIService().post('/auth/login/customer', data);

    if (user != null) {
      print('Login berhasil, data user: ${user['data']}');
      loginData.value = user.toString();

      var dataUser = user['data']['user'];

      await saveUserDataToPrefs(dataUser, user, tokenKey: 'data.token');

      Navigator.pushReplacement(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => NavigationPage(selectedIndex: 0),
        ),
      );
    } else {
      print('Login gagal, data user: $user');
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Email atau password anda salah. Silahkan coba lagi",
      );
    }
  } catch (e) {
    print('Error during login: $e');
    CustomSnackbar.show(
      title: "Terjadi Kesalahan",
      message: "Email atau password salah. Silakan coba lagi",
    );
  } finally {
    isLoading.value = false;
  }
}

  Future<void> lupaPassword() async {
    try {
      if (lupaPasswordC.value.text.isEmpty) {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Email Tidak Boleh Kosong",
          backgroundColor: Colors.red,
        );
      } else {
        isLoadingLupaPassword.value = true;
        try {
          var data = await APIService().post('/auth/password/forgot',{
              'email': lupaPasswordC.value.text,
          });          
          if (data != null) {
            CustomSnackbar.show(
              title: "Berhasil Kirim Email",
              message: "Cek Email Anda Untuk Mendapatkan Informasi Login Terbaru",
              icon: Icons.check,
              backgroundColor: Colors.green,
            );
            NotificationService().showNotification(title: '🔐 Permintaan Reset Password Berhasil Dikirim', body: 'Kami telah mengirimkan tautan untuk mereset kata sandi Anda ke email yang terdaftar. Silakan periksa kotak masuk atau folder Spam jika tidak menemukan email dari kami dalam beberapa menit.');
            lupaPasswordC.text = '';
          } 
        } catch (e) {
         
        }
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Terjadi kesalahan sistem. Coba lagi.",
        backgroundColor: Colors.red,
      );
    } finally {
      await Future.delayed(Duration(seconds: 2));
      print("DIJALANI");
      Navigator.pop(Get.context!);
      isLoadingLupaPassword.value = false;
    }
  }
}


