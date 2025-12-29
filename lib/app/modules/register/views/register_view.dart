import 'package:hexcolor/hexcolor.dart';
import '../controllers/register_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../widgets/register_form.dart';
import '../widgets/register_upload_form.dart';
import '../widgets/register_step.dart';
import '../../login/views/auth_header.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: HexColor("#F4F5F6"),
                height: size.height / 3,
                width: size.width,
                child: Image.asset(
                  'assets/woman-register.png',
                  scale: 4.5,
                ),
              ),
              const SizedBox(height: 20),
              const AuthTabHeader(isLogin: false),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(
                      text: 'Daftar dulu, biar makin gampang sewa kendaraan',
                      fontSize: 19,
                      textColor: textHeadline,
                    ),
                    const SizedBox(height: 4),
                    gabaritoText(
                      text:
                          'Buat akunmu dan nikmati kemudahan sewa kendaraan kapan aja, di mana aja.',
                      fontSize: 14,
                      textColor: textSecondary,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RegisterStep(
                        isVerified: controller.isUploadFile.value,
                      ),
                    ),
                    if (!controller.isUploadFile.value) const RegisterForm(),
                    if (controller.isUploadFile.value) const RegisterUploadForm(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
