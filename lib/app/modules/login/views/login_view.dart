import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/widget/General/newTextfFieldComponent.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

import '../controllers/login_controller.dart';
import '../../../data/data.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: HexColor("#F4F5F6"),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/man.png', scale: 6,)),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: HexColor("#FAFAFA"),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tabPage(true, "Masuk"),
                    GestureDetector(
                      onTap: () {
                      Get.toNamed('/register', arguments: {
                      'paramPost': {},
                      'detailKendaraan':{}
                      }
                      );
                      },
                      child: tabPage(false, "Register")),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  gabaritoText(text: 'Yuk, lanjutkan perjalananmu!', textColor: textHeadline, fontSize: 20,),
                  gabaritoText(text: 'Tinggal login, dan kita langsung jalan bareng lagi!', textColor: textSecondary, fontSize: 14, fontWeight: FontWeight.w400,),
                  const SizedBox(height: 20,),
                    newReusableTextField(
                      title: "Email*",
                      hintText: "Masukan Email...",
                      controller: controller.emailC,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15,),
                    Obx(() => newReusableTextField(
                    title: "Password*",
                    hintText: "Masukan password...",
                    icon: IconButton(
                  icon: Icon(controller.passwordHint.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    controller.passwordHint.toggle();
                  },
                ),
                    obscureText: controller.passwordHint.value,
                    controller: controller.passwordC,
                    ),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomTextButton(
                        textColor: textPrimary,
                        title: "Lupa Password?",
                        ontap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                                padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom,
                              ),
                              child: BottomSheetComponent(
                                widget: 
                                Container(
                                  color: Colors.white,
                                padding: EdgeInsets.symmetric( vertical: 20),
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Silahkan Masukkan Email Anda",
                                      style: gabaritoTextStyle.copyWith(
                                          fontSize: 16, color: textHeadline),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Email yang Anda berikan akan digunakan untuk mengirimkan detail tentang proses pergantian kata sandi.",
                                      style: gabaritoTextStyle.copyWith(
                                        fontSize: 12,
                                        color: textPrimary
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    newReusableTextField(
                                      title: "Masukkan Email",
                                      controller: controller.lupaPasswordC,
                                      hintText: "Masukkan Email Valid Anda",
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Obx(() =>  ReusableButton(
                                        widget: controller.isLoadingLupaPassword.value ? Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ) : poppinsText(text: "Kirim Email", textColor: Colors.white, fontWeight: FontWeight.w600,),
                                        bgColor: primaryColor,
                                        ontap: () {
                                          controller.lupaPassword();
                                        }),),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),),
                            );
                          },
                        );
                      },
                      )
                    ),
                    const SizedBox(height: 10,),
                    Obx(() => ReusableButton(
                      height: 55,
                      bgColor: solidPrimary,
                      widget: Center(
                        child: controller.isLoading.value ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ) : gabaritoText(text: "Masuk Sekarang", textColor: Colors.white, fontSize: 16,),
                      ),
                      ontap: () {
                        controller.loginUser();
                      },
                    ),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                      children: <Widget>[
                          Expanded(
                              child: Divider()
                          ),       
                          gabaritoText(text: "Atau", fontSize: 14, textColor: textPrimary,),
                          Expanded(
                              child: Divider()
                          ),
                      ]
                      ),
                    ),
                     ReusableButton(
                      height: 55,
                      bgColor: Colors.white,
                      borderSideColor: Colors.grey,
                      textColor: solidPrimary,
                      title: "Mode Tamu",
                      ontap: () {
                          Get.toNamed('/dashboard', preventDuplicates: false); 
                      },
                    ),
                    const SizedBox(height: 100,)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget tabPage(bool isActive, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
          color: isActive ? HexColor('#1F61D9') : null,
          borderRadius: BorderRadius.circular(40)),
      child: gabaritoText(
        text: title,
        textColor: isActive ? Colors.white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}