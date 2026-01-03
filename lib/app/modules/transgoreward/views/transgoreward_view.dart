import '../controllers/transgoreward_controller.dart';
import '../widgets/benefit.dart';
import '../widgets/referral.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class TransGoRewardView extends GetView<TransGoRewardController> {
  const TransGoRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransGoRewardController(), permanent: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRewards();
      controller.fetchReferralProgress();
      controller.fetchReferralInfo();
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final topHeight = constraints.maxHeight * 0.2;

        return Stack(
          children: [
            Column(
              children: [
                Container(height: topHeight, color: primaryColor),
                Container(
                  height: constraints.maxHeight - topHeight,
                  color: Colors.white,
                ),
              ],
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topHeight * 0.6,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainCard(primaryColor, controller),
                  const SizedBox(height: 16),
                  const gabaritoText(
                    text: 'Tingkatkan level dan nikmati hadiahnya',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 4),
                  const gabaritoText(
                    text:
                        'Terus berkendara untuk unlock benefit premium dan layanan spesial!',
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final validBenefits = controller.benefits
                        .where((b) => b.remainingCount > 0)
                        .toList();
                    if (validBenefits.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: validBenefits
                          .map(
                            (b) => BenefitCard(
                              benefit: b,
                              primaryColor: primaryColor,
                            ),
                          )
                          .toList(),
                    );
                  }),
                  const SizedBox(height: 16),
                  ReferralSection(
                    primaryColor: primaryColor,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainCard(
    Color primaryColor,
    TransGoRewardController controller,
  ) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const gabaritoText(
              text: "TransGo Reward Program",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Obx(() {
              final hasTier = controller.memberTier.value.isNotEmpty;
              return gabaritoText(
                text: hasTier
                    ? controller.memberTier.value.toUpperCase()
                    : "Dapatkan reward eksklusif setiap kali Anda melakukan transaksi!",
                fontSize: 16,
                fontWeight: hasTier ? FontWeight.bold : FontWeight.normal,
                textColor: primaryColor,
                textAlign: TextAlign.center,
              );
            }),
            const SizedBox(height: 24),
            Obx(() {
              final progress = controller.nextThreshold.value > 0
                  ? controller.totalRentalAmount.value /
                      controller.nextThreshold.value
                  : 0.0;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      gabaritoText(
                        text:
                            "Rp ${formatRupiah(controller.totalRentalAmount.value)}",
                        fontSize: 14,
                      ),
                      gabaritoText(
                        text:
                            "Rp ${formatRupiah(controller.nextThreshold.value)}",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    color: primaryColor,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
