import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../widget/widgets.dart';
import '../../../data/theme.dart';
import 'package:hexcolor/hexcolor.dart';

class FlashSaleWidget extends StatelessWidget {
  final DashboardController controller;
  
  const FlashSaleWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Debug: Print current state
      print('FlashSaleWidget - activeFlashSale: ${controller.activeFlashSale.value != null}');
      print('FlashSaleWidget - isDismissed: ${controller.isFlashSaleDismissed.value}');
      print('FlashSaleWidget - showFlashSale: ${controller.showFlashSale.value}');
      
      // Show widget if there's an active flash sale
      if (controller.activeFlashSale.value == null) {
        print('FlashSaleWidget - No active flash sale');
        return const SizedBox.shrink();
      }
      
      // Always show widget if activeFlashSale exists, even if showFlashSale is false
      // (showFlashSale might be false temporarily during countdown updates)

      final isDismissed = controller.isFlashSaleDismissed.value;
      print('FlashSaleWidget - Building widget, dismissed: $isDismissed');
      print('FlashSaleWidget - Will show: ${isDismissed ? "collapsed" : "expanded"}');

      // Show widget directly without animation for testing
      if (isDismissed) {
        return _buildCollapsedState(context);
      } else {
        return _buildExpandedState(context);
      }
    });
  }

  Widget _buildCollapsedState(BuildContext context) {
    return Align(
      key: const ValueKey('collapsed'),
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, top: 8),
        child: GestureDetector(
          onTap: () {
            controller.expandFlashSale();
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedState(BuildContext context) {
    final flashSale = controller.activeFlashSale.value!;
    final isActive = controller.isFlashSaleActive.value;
    final saleName = flashSale['name'] ?? 'Flash Sale';
    
    print('FlashSaleWidget - Building expanded state');
    print('FlashSaleWidget - Sale name: $saleName');
    print('FlashSaleWidget - Is active: $isActive');
    print('FlashSaleWidget - Countdown: ${controller.countdownDays.value}d ${controller.countdownHours.value}h ${controller.countdownMinutes.value}m ${controller.countdownSeconds.value}s');

    return Container(
      key: const ValueKey('expanded'),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HexColor("#E3F2FD"), // Light blue background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor, // Blue stroke
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Lightning icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    RichText(
                      text: TextSpan(
                        style: gabaritoTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textHeadline,
                        ),
                        children: [
                          const TextSpan(text: 'Flash Sale '),
                          TextSpan(
                            text: saleName,
                            style: gabaritoTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: isActive ? ' sedang berlangsung' : ' akan dimulai',
                            style: gabaritoTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textHeadline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Countdown label
                    gabaritoText(
                      text: isActive ? 'Berakhir dalam:' : 'Mulai dalam:',
                      fontSize: 12,
                      textColor: textSecondary,
                    ),
                    const SizedBox(height: 8),
                    // Countdown timer - using Wrap to prevent overflow
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 4),
                        _buildTimeBox(
                          controller.countdownDays.value.toString().padLeft(2, '0'),
                          'h',
                        ),
                        Text(
                          ' : ',
                          style: gabaritoTextStyle.copyWith(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        _buildTimeBox(
                          controller.countdownHours.value.toString().padLeft(2, '0'),
                          'j',
                        ),
                        Text(
                          ' : ',
                          style: gabaritoTextStyle.copyWith(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        _buildTimeBox(
                          controller.countdownMinutes.value.toString().padLeft(2, '0'),
                          'm',
                        ),
                        Text(
                          ' : ',
                          style: gabaritoTextStyle.copyWith(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        _buildTimeBox(
                          controller.countdownSeconds.value.toString().padLeft(2, '0'),
                          'd',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // X button
              GestureDetector(
                onTap: () {
                  controller.dismissFlashSale();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // LIHAT PROMO button - full width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.showFlashSaleItems();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: gabaritoText(
                text: 'LIHAT PROMO',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: HexColor("#E0E0E0"),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          gabaritoText(
            text: value,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            textColor: primaryColor,
          ),
          const SizedBox(width: 2),
          gabaritoText(
            text: unit,
            fontSize: 10,
            textColor: textSecondary,
          ),
        ],
      ),
    );
  }
}
