import 'dart:io';
import 'package:transgomobileapp/app/data/helper/SharedPrefsHelper.dart';
import 'package:transgomobileapp/app/routes/Navbar.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
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
  RxBool isLoadingGoogle = false.obs;
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


  Future<void> loginWithGoogle() async {
    // Check if running on iOS
    if (Platform.isIOS) {
      CustomSnackbar.show(
        title: "Fitur Belum Tersedia",
        message: "Login dengan Google belum tersedia untuk iOS. Silakan gunakan email dan password untuk login.",
        icon: Icons.info_outline,
        backgroundColor: Colors.orange,
      );
      return;
    }

    isLoadingGoogle.value = true;

    try {
      // Sign in with Google
      final googleUser = await GoogleSignInService.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoadingGoogle.value = false;
        return;
      }

      // Validate that we have the ID token
      if (googleUser['idToken'] == null || googleUser['idToken']!.isEmpty) {
        print('ERROR: ID Token is missing!');
        print('Google User data: ${googleUser.keys}');
        print('Email: ${googleUser['email']}');
        print('Name: ${googleUser['name']}');
        
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Tidak dapat memperoleh token dari Google. Pastikan konfigurasi Google Sign-In sudah benar.",
          icon: Icons.error,
        );
        isLoadingGoogle.value = false;
        return;
      }
      
      print('ID Token retrieved successfully, length: ${googleUser['idToken']!.length}');

      // Prefill email from Google
      emailC.text = googleUser['email']!;
      
      // Use Google ID token to authenticate with backend
      // Backend endpoint: POST /auth/login/google
      // Backend will verify the token and create user if doesn't exist
      var data = {
        'id_token': googleUser['idToken']!, // Google ID Token (JWT) - required
        'token': GlobalVariables.fcmToken.value, // FCM token - optional
      };

      print('Google login - sending ID token to backend');

      try {
        // Use the dedicated Google login endpoint
        final user = await APIService().post('/auth/login/google', data);

        if (user != null) {
          print('Google login berhasil, data user: ${user['data']}');
          loginData.value = user.toString();

          var dataUser = user['data']['user'];

          await saveUserDataToPrefs(dataUser, user, tokenKey: 'data.token');

          Navigator.pushReplacement(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => NavigationPage(selectedIndex: 0),
            ),
          );
        }
      } catch (e) {
        print('Error during Google login: $e');
        // Handle different error cases
        // Backend will return 401 for invalid token, unverified email, etc.
        CustomSnackbar.show(
          title: "Gagal Login dengan Google",
          message: "Tidak dapat melakukan login dengan Google. Pastikan email Google Anda sudah terverifikasi.",
          icon: Icons.error,
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Gagal melakukan login dengan Google. Silakan coba lagi.",
        icon: Icons.error,
      );
    } finally {
      isLoadingGoogle.value = false;
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


