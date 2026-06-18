import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../../../routes/app_pages.dart';
import '../controllers/verification_queue_controller.dart';

class VerificationQueueView extends GetView<VerificationQueueController> {
  const VerificationQueueView({Key? key}) : super(key: key);

  void _contactWhatsAppAdmin() async {
    final name = GlobalVariables.namaUser.value;
    final email = GlobalVariables.emailUser.value;
    final isPendingOrder = controller.hasPendingOrder.value;

    final message = isPendingOrder
        ? "Halo Admin Transgo, saya ingin menanyakan status verifikasi akun dan pesanan saya. Nama: $name, Email: $email"
        : "Halo Admin Transgo, saya ingin menanyakan status verifikasi akun saya. Nama: $name, Email: $email";

    final encodedMessage = Uri.encodeComponent(message);
    final number = whatsAppNumberAdmin;
    final url = "https://wa.me/$number?text=$encodedMessage";
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F9FAFB"),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: gabaritoText(
          text: "Status Verifikasi",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textColor: textHeadline,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: HexColor("#F3F4F6")),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: HexColor("#EFF6FF"),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            IconsaxPlusBold.shield_security,
                            size: 80,
                            color: HexColor("#3B82F6"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(() => gabaritoText(
                            text: controller.hasPendingOrder.value
                                ? "Akun & Pesanan Anda Sedang Diverifikasi!"
                                : "Akun Anda Sedang Diverifikasi!",
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            textAlign: TextAlign.center,
                            textColor: textHeadline,
                          )),
                      const SizedBox(height: 12),
                      Obx(() => gabaritoText(
                            text: controller.hasPendingOrder.value
                                ? "Mohon tunggu sebentar, tim kami sedang memproses verifikasi berkas akun serta pesanan unit sewa Anda demi keamanan transaksi."
                                : "Mohon tunggu sebentar, tim kami sedang memproses verifikasi berkas dan akun Anda demi keamanan transaksi.",
                            fontSize: 13,
                            textColor: textSecondary,
                            textAlign: TextAlign.center,
                            heightText: 1.5,
                          )),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor("#F9FAFB"),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: HexColor("#F3F4F6")),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconsaxPlusBold.layer,
                                      size: 18,
                                      color: HexColor("#3B82F6"),
                                    ),
                                    const SizedBox(width: 8),
                                    Obx(() => gabaritoText(
                                          text: controller.hasPendingOrder.value
                                              ? "Estimasi Verifikasi Akun & Order"
                                              : "Estimasi Waktu Verifikasi",
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          textColor: textHeadline,
                                        )),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: HexColor("#E0F2FE"),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: gabaritoText(
                                    text: "Antrean Aktif",
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    textColor: HexColor("#0369A1"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Obx(() {
                                final progress = controller.timeLeft.value / 900.0;
                                return SizedBox(
                                  height: 8,
                                  child: LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: HexColor("#E5E7EB"),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      HexColor("#3B82F6"),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconsaxPlusBold.clock,
                                      size: 16,
                                      color: HexColor("#3B82F6"),
                                    ),
                                    const SizedBox(width: 6),
                                    Obx(() => RichText(
                                          text: TextSpan(
                                            style: gabaritoTextStyle.copyWith(
                                              fontSize: 12,
                                              color: textSecondary,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Sisa waktu estimasi: "),
                                              TextSpan(
                                                text: controller.formatTime(
                                                    controller.timeLeft.value),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                                gabaritoText(
                                  text: "Maks. 15 Menit",
                                  fontSize: 12,
                                  textColor: textSecondary,
                                ),
                              ],
                            ),
                            Obx(() {
                              if (controller.timeLeft.value == 0 &&
                                  !controller.isOutsideHours.value) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: HexColor("#FEF3C7"),
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: HexColor("#FDE68A")),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: gabaritoText(
                                    text:
                                        "Proses verifikasi membutuhkan waktu lebih lama dari biasanya. Silakan hubungi admin WhatsApp kami untuk mempercepat proses verifikasi.",
                                    fontSize: 12,
                                    textColor: HexColor("#92400E"),
                                    fontWeight: FontWeight.w600,
                                    heightText: 1.4,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                            Obx(() {
                              if (controller.isOutsideHours.value) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: HexColor("#F3F4F6"),
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: HexColor("#E5E7EB")),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: gabaritoText(
                                    text:
                                        "Layanan verifikasi saat ini berada di luar jam operasional kerja (23:00 - 07:00 WIB). Proses verifikasi Anda akan dibekukan sementara dan dilanjutkan kembali secara otomatis mulai pukul 07:00 WIB besok pagi.",
                                    fontSize: 12,
                                    textColor: HexColor("#374151"),
                                    fontWeight: FontWeight.w600,
                                    heightText: 1.4,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await GlobalVariables.setBypassVerificationQueue(true);
                    Get.offAllNamed(Routes.DEFAULT);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 52),
                    elevation: 0,
                  ),
                  icon: const Icon(IconsaxPlusBold.search_normal_1, size: 20),
                  label: gabaritoText(
                    text: "Cari Kendaraan",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _contactWhatsAppAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#10B981"),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 52),
                    elevation: 0,
                  ),
                  icon: const Icon(IconsaxPlusBold.call, size: 20),
                  label: gabaritoText(
                    text: "Hubungi Admin (WhatsApp)",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => OutlinedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.logout(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HexColor("#EF4444"),
                        side: BorderSide(color: HexColor("#FCA5A5")),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : const Icon(IconsaxPlusBold.logout_1, size: 18),
                      label: gabaritoText(
                        text: "Keluar Akun",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        textColor: HexColor("#EF4444"),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
