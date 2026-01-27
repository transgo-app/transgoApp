import 'dart:convert';
import 'package:transgomobileapp/app/data/helper/SharedPrefsHelper.dart';
import '../../../data/data.dart';

class ProfileController extends GetxController {
  final count = 0.obs;
  RxString namaUser = 'Selamat Datang di Transgo!'.obs;
  RxString emailUser = 'Layanan Rental Mobil & Motor Terbaik untuk Anda'.obs;
  RxInt userId = 0.obs;

  TextEditingController namaUserC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nomorTelpC = TextEditingController();
  TextEditingController nomorDaruratC = TextEditingController();
  TextEditingController jenisKelaminC = TextEditingController();
  TextEditingController tanggalLahirC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  RxString jenisKelamin = ''.obs;
  RxString tanggalLahir = ''.obs;
  RxList detailFileUser = [].obs;
  RxList idCards = [].obs;
  RxList additionalData = [].obs;
  RxString dataUserTeks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDetailUser();
    getCheckAdditional();
  }

  Future<void> getDetailUser() async {
    try {
      var data = await APIService().get('/auth');
      var dataUser = data['user'];
      print('ini response auth ${data}');
      await saveUserDataToPrefs(dataUser, data, tokenKey: 'token');
      userId.value = dataUser['id'];
      print("INI DATA USER ${dataUser['id'].runtimeType}");
      namaUserC.text = GlobalVariables.namaUser.value;
      emailC.text = GlobalVariables.emailUser.value;
      nomorTelpC.text = dataUser['phone_number'] ?? '';
      nomorDaruratC.text = dataUser['emergency_phone_number'] ?? dataUser['phone_number'] ?? '';
      jenisKelaminC.text = GlobalVariables.jenisKelamin.value;
      tanggalLahirC.text = GlobalVariables.tanggalLahir.value; 
      nikC.text = dataUser['nik'] ?? '';

      GlobalVariables.additional_data_status.value = dataUser['additional_data_status'];
      GlobalVariables.statusVerificationAccount.value = dataUser['status'];
      
      if (GlobalVariables.idCards.isNotEmpty) {
        idCards.value = jsonDecode(GlobalVariables.idCards.value);
      }
      additionalData.value = dataUser['additional_data'];
      dataUserTeks.value = dataUser.toString();
    } catch (e) {
      print('Error: $e');
    } finally {}
  }


  Future<void> getCheckAdditional() async {
    try {
      var data = await APIService().get('/customers/status/additional');
      print('butuh data tambahan ga $data');
      GlobalVariables.statusAccount.value = data['message'];
      GlobalVariables.hexStatusAccount.value = data['hexcolor'];
      GlobalVariables.isShowStatusAccount.value = data['show_card'];
      GlobalVariables.isNeedAdditionalData.value = data['need_verification'];
    } catch (e) {
      print('Error: $e');
  } finally {}
  }
  
   Future<void> requestDeleteAccount() async {
    try {
      var data = await APIService().put('/orders/request-delete/${userId.value}', {});
      print("INI DATA $data");
    } catch (e) {
      print('Error: $e');
    } finally {}
  }
}
