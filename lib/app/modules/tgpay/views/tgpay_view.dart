import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/data.dart';
import '../../../data/theme.dart';
import '../../../widget/widgets.dart';
import '../controllers/tgpay_controller.dart';

class TgPayView extends StatefulWidget {
  const TgPayView({super.key});

  @override
  State<TgPayView> createState() => _TgPayViewState();
}

class _TgPayViewState extends State<TgPayView> {
  final ScrollController _scrollController = ScrollController();
  bool _showBanner = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShowBanner = _scrollController.offset < 100;
    if (shouldShowBanner != _showBanner) {
      setState(() {
        _showBanner = shouldShowBanner;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TgPayController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconsaxPlusBold.arrow_left_1),
          onPressed: () => Get.back(),
          color: textHeadline,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Top Banner - fill width and use more vertical space
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _showBanner ? 200 : 0,
            child: _showBanner
                ? Image.asset(
                    'assets/tg_pay/tg-pay-banner.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
          // Tab Navigation - sticky at top
          _buildTabNavigation(controller),
          // PageView Content with scroll detection
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.onPageChanged(index);
                // Reset scroll position when switching tabs
                if (index == 0) {
                  _scrollController.jumpTo(0);
                  setState(() {
                    _showBanner = true;
                  });
                }
              },
              children: [
                _buildTopUpTab(controller, _scrollController),
                _buildTopUpHistoryTab(controller),
                _buildUsageHistoryTab(controller),
                _buildCashbackHistoryTab(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(TgPayController controller) {
    final tabs = [
      {'label': 'Isi Saldo', 'icon': Icons.arrow_upward},
      {'label': 'Riwayat Top Up', 'icon': Icons.receipt},
      {'label': 'Riwayat Pemakaian', 'icon': IconsaxPlusBold.clock},
      {'label': 'Riwayat Cashback', 'icon': IconsaxPlusBold.gift},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => Obx(() {
              final isActive = controller.currentTabIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tabs[index]['icon'] as IconData,
                        size: 18,
                        color: isActive ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      gabaritoText(
                        text: tabs[index]['label'] as String,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: isActive ? Colors.white : Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpTab(TgPayController controller, ScrollController scrollController) {
    // Listen for QR and VA modal triggers using Obx
    return Obx(() {
      final qrUrl = controller.qrImageUrl.value;
      if (qrUrl != null && qrUrl.isNotEmpty) {
        // Reset trigger and show modal after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.qrImageUrl.value = null;
          _showQrModal(context, qrUrl, controller.currentAmount);
        });
      }

      final vaDetails = controller.vaDetails.value;
      if (vaDetails != null && (vaDetails['number']?.isNotEmpty ?? false)) {
        // Reset trigger and show modal after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.vaDetails.value = null;
          _showVaModal(context, vaDetails!, controller.currentAmount);
        });
      }

      return SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            _buildBalanceCard(controller),
            const SizedBox(height: 24),
            // Top Up Form
            _buildTopUpForm(controller),
          ],
        ),
      );
    });
  }
  
  void _showQrModal(BuildContext context, String qrUrl, int amount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                gabaritoText(
                  text: 'Scan QRIS untuk Membayar',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: textHeadline,
                ),
                const SizedBox(height: 8),
                gabaritoText(
                  text: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(amount),
                  fontSize: 14,
                  textColor: Colors.grey.shade700,
                ),
                const SizedBox(height: 24),
                // QR Image
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Image.network(
                    qrUrl,
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error_outline, size: 48),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Download Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final uri = Uri.parse(qrUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          CustomSnackbar.show(
                            title: 'Gagal',
                            message: 'Tidak dapat membuka URL QR',
                          );
                        }
                      } catch (e) {
                        CustomSnackbar.show(
                          title: 'Gagal',
                          message: 'Terjadi kesalahan saat membuka QR',
                        );
                      }
                    },
                    icon: const Icon(Icons.download, size: 20),
                    label: gabaritoText(
                      text: 'Download QR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Close Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: gabaritoText(
                    text: 'Tutup',
                    fontSize: 14,
                    textColor: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVaModal(BuildContext context, Map<String, String> vaDetails, int amount) {
    final vaNumber = vaDetails['number'] ?? '';
    final vaName = vaDetails['name'] ?? '';
    final bankCode = vaDetails['bank'] ?? '';
    final expiry = vaDetails['expiry'];

    // Map bank code to display name
    final Map<String, String> bankNames = {
      'BCA': 'BCA',
      'BRI': 'BRI',
      'MANDIRI': 'Mandiri',
      'BNI': 'BNI',
      'CIMB': 'CIMB',
      'PERMATA': 'Permata',
      'BSI': 'BSI',
      'BNC': 'BNC',
      'DANAMON': 'Danamon',
    };
    final bankName = bankNames[bankCode] ?? bankCode;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                gabaritoText(
                  text: 'Transfer ke Virtual Account',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: textHeadline,
                ),
                const SizedBox(height: 8),
                gabaritoText(
                  text: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(amount),
                  fontSize: 14,
                  textColor: Colors.grey.shade700,
                ),
                const SizedBox(height: 24),
                // Bank Name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: gabaritoText(
                    text: 'Bank $bankName',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                // VA Number - Tap to Copy
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: vaNumber));
                    if (context.mounted) {
                      CustomSnackbar.show(
                        title: 'Berhasil',
                        message: 'Nomor VA berhasil disalin',
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.content_copy,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            gabaritoText(
                              text: 'Ketuk untuk menyalin',
                              fontSize: 11,
                              textColor: Colors.grey.shade600,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          vaNumber,
                          style: gabaritoTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (vaName.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          gabaritoText(
                            text: 'a.n. $vaName',
                            fontSize: 12,
                            textColor: Colors.grey.shade700,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (expiry != null && expiry.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  gabaritoText(
                    text: 'Berlaku hingga: $expiry',
                    fontSize: 11,
                    textColor: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: gabaritoText(
                      text: 'Tutup',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(TgPayController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gabaritoText(
                  text: 'Saldo Anda',
                  fontSize: 12,
                  textColor: Colors.grey,
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final balance = controller.balance.value;
                  final formattedBalance = NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(balance);
                  return gabaritoText(
                    text: formattedBalance,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: textHeadline,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpForm(TgPayController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(
          text: 'PILIH NOMINAL TOP UP',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          textColor: textHeadline,
        ),
        const SizedBox(height: 16),
        // Predefined Amounts Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: controller.predefinedAmounts.length,
          itemBuilder: (context, index) {
            final amount = controller.predefinedAmounts[index];
            return Obx(() {
              final isSelected = controller.selectedAmount.value == amount.toString();
              return GestureDetector(
                onTap: () => controller.selectPredefinedAmount(amount),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      gabaritoText(
                        text: 'Transgo Pay ${(amount / 1000).toStringAsFixed(0)}K',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: isSelected ? primaryColor : textHeadline,
                      ),
                      const SizedBox(height: 4),
                      gabaritoText(
                        text: NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(amount),
                        fontSize: 11,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 16),
        // Custom Amount Input
        gabaritoText(
          text: 'Atau masukkan nominal custom',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          textColor: textHeadline,
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Input Nominal',
            prefixText: 'Rp ',
            prefixStyle: gabaritoTextStyle.copyWith(
              fontSize: 14,
              color: textHeadline,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: controller.setCustomAmount,
        ),
        const SizedBox(height: 24),
        // Payment Method Selection
        gabaritoText(
          text: 'Metode Pembayaran',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          textColor: textHeadline,
        ),
        const SizedBox(height: 16),
        // QRIS Option
        Obx(() {
          final isSelected = controller.selectedPaymentMethod.value == 'QRIS';
          return GestureDetector(
            onTap: () => controller.selectPaymentMethod('QRIS'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.1) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.qr_code,
                      size: 24,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: gabaritoText(
                      text: 'QRIS',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: textHeadline,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: primaryColor,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        // Virtual Account Options
        Obx(() {
          final isVaSelected =
              controller.selectedPaymentMethod.value == 'VIRTUAL_ACCOUNT';
          final currentAmount = controller.currentAmount;
          final isVaAvailable =
              controller.vaEnabled.value && currentAmount >= controller.vaMinAmount.value;

          if (!isVaAvailable) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: gabaritoText(
                      text:
                          'Virtual Account hanya tersedia untuk nominal minimal Rp ${NumberFormat.decimalPattern('id').format(controller.vaMinAmount.value)}',
                      fontSize: 12,
                      textColor: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return Obx(() {
            if (controller.availableBanks.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: gabaritoText(
                        text: controller.isLoadingMethods.value
                            ? 'Memuat metode pembayaran...'
                            : 'Virtual Account tidak tersedia saat ini',
                        fontSize: 12,
                        textColor: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gabaritoText(
                  text: 'Virtual Account',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: textHeadline,
                ),
                const SizedBox(height: 12),
                ...controller.availableBanks.map((bank) {
                final code = bank['code']!;
                final name = bank['name']!;
                final isBankSelected =
                    isVaSelected && controller.selectedBank.value == code;

                // Map available bank icons to existing assets
                String? iconPath;
                switch (code) {
                  case 'BCA':
                    iconPath = 'assets/icon_bca.png';
                    break;
                  case 'MANDIRI':
                    iconPath = 'assets/mandiri.png';
                    break;
                  case 'BRI':
                    iconPath = 'assets/icon_bri.png';
                    break;
                  case 'BNI':
                    iconPath = 'assets/icon_bni.png';
                    break;
                  case 'CIMB':
                    iconPath = 'assets/icon_cimb.png';
                    break;
                  case 'PERMATA':
                    iconPath = 'assets/icon_permata.jpg';
                    break;
                  case 'BSI':
                    iconPath = 'assets/icon_bsi.png';
                    break;
                  case 'BNC':
                    iconPath = 'assets/icon_bnc.png';
                    break;
                  case 'DANAMON':
                    iconPath = 'assets/icon_danamon.png';
                    break;
                  default:
                    iconPath = null;
                }

                return GestureDetector(
                  onTap: () {
                    controller.selectPaymentMethod('VIRTUAL_ACCOUNT');
                    controller.selectBank(code);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBankSelected
                          ? primaryColor.withOpacity(0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isBankSelected ? primaryColor : Colors.grey.shade300,
                        width: isBankSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: iconPath != null
                              ? Image.asset(
                                  iconPath,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(
                                  Icons.account_balance,
                                  size: 20,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: gabaritoText(
                            text: 'VA $name',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            textColor: textHeadline,
                          ),
                        ),
                        if (isBankSelected)
                          Icon(
                            Icons.check_circle,
                            color: primaryColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              ],
            );
          });
        }),
        const SizedBox(height: 32),
        // Submit Button
        Obx(() {
          final canSubmit = controller.canSubmitTopup;
          final isSubmitting = controller.isSubmittingTopup.value;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  canSubmit && !isSubmitting ? () => controller.submitTopup() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : gabaritoText(
                      text: 'Bayar sekarang',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
            ),
          );
        }),
        const SizedBox(height: 24),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTopUpHistoryTab(TgPayController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/iconapp.png',
            width: 64,
            height: 64,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Belum ada transaksi',
            fontSize: 14,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageHistoryTab(TgPayController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/iconapp.png',
            width: 64,
            height: 64,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Belum ada riwayat pemakaian saldo',
            fontSize: 14,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildCashbackHistoryTab(TgPayController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/iconapp.png',
            width: 64,
            height: 64,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Belum ada riwayat cashback',
            fontSize: 14,
            textColor: Colors.grey,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: gabaritoText(
              text: 'Cashback akan diberikan saat Anda melakukan pembayaran full dengan Transgo Pay',
              fontSize: 12,
              textColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
