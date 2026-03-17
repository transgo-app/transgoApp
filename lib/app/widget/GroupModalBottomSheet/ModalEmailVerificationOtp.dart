import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class ModalEmailVerificationOtp extends StatelessWidget {
  const ModalEmailVerificationOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return BottomSheetComponent(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            IconsaxPlusBold.sms_edit,
            color: solidPrimary,
            size: 48,
          ),
          const SizedBox(height: 16),
          gabaritoText(
            text: 'Verifikasi Email',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            textColor: textHeadline,
          ),
          const SizedBox(height: 8),
          gabaritoText(
            text: 'Kode OTP telah dikirim ke email Anda. Masukkan 6 digit kode di bawah ini.',
            fontSize: 13,
            textAlign: TextAlign.center,
            textColor: textSecondary,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: gabaritoTextStyle.copyWith(
              fontSize: 22,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              hintText: '000000',
              counterText: '',
              filled: true,
              fillColor: HexColor('#F5F5F5'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: solidPrimary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final cooldown = controller.resendCooldownSec.value;
            final sending = controller.isSendingOtp.value;
            return Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: (cooldown > 0 || sending)
                        ? null
                        : () => controller.resendEmailOtp(),
                    child: gabaritoText(
                      text: cooldown > 0
                          ? 'Kirim ulang dalam ${cooldown}s'
                          : 'Kirim ulang email',
                      fontSize: 13,
                      textColor: (cooldown > 0 || sending)
                          ? textSecondary
                          : solidPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Obx(() => ReusableButton(
                        height: 48,
                        title: controller.isVerifyingOtp.value
                            ? 'Memverifikasi...'
                            : 'Konfirmasi',
                        bgColor: solidPrimary,
                        textColor: Colors.white,
                        ontap: controller.isVerifyingOtp.value
                            ? null
                            : () => controller.verifyEmailOtp(),
                      )),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
