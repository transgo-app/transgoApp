import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/transgoreward_controller.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class ReferralSection extends StatelessWidget {
  final Color primaryColor;
  final TransGoRewardController controller;

  const ReferralSection({
    super.key,
    required this.primaryColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const gabaritoText(
                  text: "Undang Teman",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: gabaritoText(
                          text: controller.referralCode.value,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: controller.referralCode.value,
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share(
                      'Hai! Coba sewa mobil/motor di TransGo dengan kode referral saya: ${controller.referralCode.value}. '
                      'Dapatkan diskon khusus! https://transgo.id/sewa?ref=${controller.referralCode.value}',
                    );
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const gabaritoText(
                    text: "Bagikan Kode Referral",
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const gabaritoText(
                  text: "Cara Ajak Teman & Bonus Referral",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStepIcon(primaryColor, Icons.share, "Salin & Bagikan Kode"),
                    _buildStepIcon(primaryColor, Icons.person_add, "Teman Memasukkan Kode"),
                    _buildStepIcon(primaryColor, Icons.schedule, "Teman Menyelesaikan Sewa"),
                    _buildStepIcon(primaryColor, Icons.card_giftcard, "Dapat Voucher Rp50.000"),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 1),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFE0F2FF),
                      child: Icon(
                        Icons.info,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(
                            text: "Cara Mendapatkan Bonus Referral",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4),
                          gabaritoText(
                            text:
                                "Teman yang diundang harus sewa minimal 2 hari untuk mendapatkan discount voucher 50K. "
                                "Setiap hari sewa dari teman yang diundang akan berkontribusi pada progress bonus Anda.",
                            fontSize: 12,
                            textColor: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Obx(() {
          if (controller.referralUsers.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const gabaritoText(
                  text: "Teman yang sudah diundang",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                Column(
                  children: controller.referralUsers
                      .map((user) => _buildReferralUserCard(user, primaryColor))
                      .toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStepIcon(Color primaryColor, IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          radius: 24,
          child: Icon(icon, color: primaryColor, size: 28),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: gabaritoText(
            text: label,
            fontSize: 12,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildReferralUserCard(ReferralUser user, Color primaryColor) {
    int maxRentalDays = 2;
    double progress = (user.totalRentalDays / maxRentalDays).clamp(0.0, 1.0);

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryColor.withOpacity(0.2),
              child: gabaritoText(
                text: user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : "?",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                textColor: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gabaritoText(
                    text: user.name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  gabaritoText(
                    text: user.memberTier,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: primaryColor,
                  ),
                  const SizedBox(height: 4),
                  gabaritoText(
                    text: "${user.totalRentalDays} / $maxRentalDays hari disewa",
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
