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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shield_outlined, size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 6),
                              gabaritoText(
                                text: 'Keamanan Data Pribadi',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.blue.shade700,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          gabaritoText(
                            text:
                                'Data Anda terlindungi sepenuhnya berdasarkan UU No. 27 Tahun 2022 tentang Perlindungan Data Pribadi (PDP).',
                            fontSize: 12,
                            textColor: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 8),
                          gabaritoText(
                            text:
                                'Lengkapi data di bawah untuk melanjutkan proses sewa. Pengisian cukup dilakukan satu kali saja untuk transaksi pertama Anda.',
                            fontSize: 12,
                            textColor: Colors.blue.shade700,
                          ),
                        ],
                      ),
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
