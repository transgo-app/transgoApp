import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalHapusAkun.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalLogout.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/profile_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F6F6F6"),
      body: Obx(() => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(IconsaxPlusBold.user, color: primaryColor,),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(text: "${GlobalVariables.namaUser.value}", fontSize: 16,),
                          gabaritoText(text: "${GlobalVariables.emailUser.value}", fontSize: 14, textColor: textSecondary,),
                        ],
                      ),
                    ),
                  ],
                ),
                BackgroundCard(
                  paddingHorizontal: 18,
                  paddingVertical: 18,
                  marginVertical: 20,
                  body: Column(
                    children: [
                      profileSection(IconsaxPlusBold.security_user, "Data Pribadi", 'Lihat info akun kamu di sini.',() {
                        Get.toNamed("/detailuser", arguments: true, );
                      },),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider()),
                      profileSection(IconsaxPlusBold.document_1, "Dokumen Pribadi", 'Cek dokumen penting kamu yang udah tersimpan', () {
                        Get.toNamed("/detailuser", arguments: false);
                      },),
                    ],
                  )),
                  BackgroundCard(
                  paddingHorizontal: 18,
                  paddingVertical: 18,
                  body: Column(
                    children: [
                      profileSection(IconsaxPlusBold.call_calling, "Hubungi Admin Sekarang", 'Klik di sini buat langsung terhubung sama tim kami.', () {
                        launchUrl(Uri.parse('https://wa.me/$whatsAppNumberAdmin?text=Halo Admin Transgo'));
                      },),
                    ],
                  )),
                  const SizedBox(height: 10,),
                if(GlobalVariables.isShowStatusAccount.value)
                  BackgroundCard(
                    ontap: () {
                      Get.toNamed('/additionaldata');
                    },
                  stringHexBG: "#FB4141",
                  stringHexBorder: "#FB4141",
                  paddingHorizontal: 18,
                  paddingVertical: 18,
                  body: Column(
                    children: [
                      GestureDetector(
                      onTap: () {
                        if(GlobalVariables.isNeedAdditionalData.value)
                        Get.toNamed('/additionaldata');
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(IconsaxPlusBold.profile_circle, color: Colors.white, size: 30,),
                              const SizedBox(width: 12,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    gabaritoText(text: "${GlobalVariables.statusAccount.value}", textColor: Colors.white,),
                                    if(GlobalVariables.isNeedAdditionalData.value)
                                    gabaritoText(text: "Klik disini untuk upload data tambahan kamu", textColor: Colors.white, fontSize: 13,),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10,),
                              if(GlobalVariables.isNeedAdditionalData.value)
                              Icon(Icons.chevron_right_sharp, size: 30, color: Colors.white,),
                            ],
                          ),
                      ),
                    )
                    ],
                  )),
                const SizedBox(height: 20,),
                ReusableButton(
                  bgColor: HexColor('#F6F6F6') ,
                  ontap: () {
                    showModalBottomSheet(context: context, builder: (context) {
                      return ModalLogout();
                    },);
                  },
                  borderSideColor: Colors.grey[500],
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusBold.logout, color: Colors.red,),
                      const SizedBox(width: 10,),
                      gabaritoText(text: "Keluar", fontWeight: FontWeight.w600, textColor: Colors.red,)
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                CustomTextButton(
                  textColor: Colors.red,
                  title: "Hapus Akun", ontap: () {
                  showModalBottomSheet(context: context, builder: (context) {
                      return ModalHapusAkun();
                    },);
                },)
              ],
            ),
          )
        ),
      ),)
    );
  }
  Widget profileSection (IconData icon, String title, String subtitle, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: solidDefaultSecondary, size: 30,),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(text: title, textColor: textPrimary,),
                    gabaritoText(text: subtitle, textColor: textSecondary, fontSize: 13,),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Icon(Icons.chevron_right_sharp, size: 30,),
            ],
          ),
      ),
    );
  }
}

class ShimmerGlow extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color glowColor;

  const ShimmerGlow({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 5),
    this.glowColor = Colors.white,
  });

  @override
  State<ShimmerGlow> createState() => _ShimmerGlowState();
}

class _ShimmerGlowState extends State<ShimmerGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: widget.duration)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            final animationValue = _controller.value;

            final gradient = LinearGradient(
              colors: [
                widget.glowColor.withOpacity(0.1),
                widget.glowColor.withOpacity(0.6),
                widget.glowColor.withOpacity(0.3),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + 2.0 * animationValue, 0),
              end: Alignment(-0.2 + 2.0 * animationValue, 0),
            );

            return gradient.createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
