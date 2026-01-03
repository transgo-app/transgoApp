import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/profile_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalHapusAkun.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalLogout.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F6F7F9"),
      body: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileHeader(),
                const SizedBox(height: 24),
                _accountSection(),
                const SizedBox(height: 16),
                _helpSection(),
                const SizedBox(height: 16),
                _supportSection(),
                const SizedBox(height: 16),
                if (GlobalVariables.isShowStatusAccount.value)
                  _statusAccountSection(),
                const SizedBox(height: 30),
                _logoutButton(context),
                const SizedBox(height: 16),
                _deleteAccountButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: solidPrimary.withOpacity(0.1),
            ),
            child: Icon(
              IconsaxPlusBold.user,
              color: solidPrimary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gabaritoText(
                  text: GlobalVariables.namaUser.value,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                gabaritoText(
                  text: GlobalVariables.emailUser.value,
                  fontSize: 13,
                  textColor: textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountSection() {
    return _sectionCard(
      children: [
        _menuItem(
          icon: IconsaxPlusBold.security_user,
          title: "Data Pribadi",
          subtitle: "Lihat dan kelola informasi akun kamu",
          onTap: () => Get.toNamed("/detailuser", arguments: true),
        ),
        _divider(),
        _menuItem(
          icon: IconsaxPlusBold.document_1,
          title: "Dokumen Pribadi",
          subtitle: "Cek dokumen penting yang tersimpan",
          onTap: () => Get.toNamed("/detailuser", arguments: false),
        ),
      ],
    );
  }

  Widget _helpSection() {
    return _sectionCard(
      children: [
        _menuItem(
          icon: IconsaxPlusBold.book_1,
          title: "Panduan Transgo",
          subtitle: "Pelajari cara menggunakan Transgo",
          onTap: () {
            Get.toNamed('/panduantransgo');
          },
        ),
        _divider(),
        _menuItem(
          icon: IconsaxPlusBold.magic_star,
          title: "Gogo AI",
          subtitle: "Asisten pintar untuk bantu kebutuhanmu",
          onTap: () {
            Get.toNamed('/chatbot');
          },
        ),
        _divider(),
        _menuItem(
          icon: IconsaxPlusBold.document_text,
          title: "Syarat dan Ketentuan",
          subtitle: "Ketentuan penggunaan layanan Transgo",
          onTap: () {
            Get.toNamed('/syaratdanketentuan');
          },
        ),
      ],
    );
  }

  Widget _supportSection() {
    return _sectionCard(
      children: [
        _menuItem(
          icon: IconsaxPlusBold.call_calling,
          title: "Hubungi Admin",
          subtitle: "Terhubung langsung dengan tim Transgo",
          onTap: () {
            launchUrl(
              Uri.parse(
                'https://wa.me/$whatsAppNumberAdmin?text=Halo Admin Transgo',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _statusAccountSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HexColor("#FB4141"),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () {
          if (GlobalVariables.isNeedAdditionalData.value) {
            Get.toNamed('/additionaldata');
          }
        },
        child: Row(
          children: [
            Icon(
              IconsaxPlusBold.profile_circle,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(
                    text: GlobalVariables.statusAccount.value,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  if (GlobalVariables.isNeedAdditionalData.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: gabaritoText(
                        text:
                            "Klik untuk melengkapi data tambahan akun kamu",
                        textColor: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            if (GlobalVariables.isNeedAdditionalData.value)
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ReusableButton(
      bgColor: Colors.white,
      borderSideColor: HexColor("#E0E0E0"),
      ontap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => const ModalLogout(),
        );
      },
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusBold.logout, color: Colors.red),
          const SizedBox(width: 10),
          gabaritoText(
            text: "Keluar",
            fontWeight: FontWeight.w600,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _deleteAccountButton(BuildContext context) {
    return Center(
      child: CustomTextButton(
        title: "Hapus Akun",
        textColor: Colors.red,
        ontap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const ModalHapusAkun(),
          );
        },
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: solidDefaultSecondary, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(
                    text: title,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  gabaritoText(
                    text: subtitle,
                    fontSize: 13,
                    textColor: textSecondary,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 26,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: HexColor("#EEEEEE")),
    );
  }
}
