import 'package:flutter/material.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class SectionGuestInfo extends StatelessWidget {
  final DetailitemsController controller;

  const SectionGuestInfo({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
        BackgroundCard(
          stringHexBG: "#FAFAFA",
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const gabaritoText(
                text: "Data Diri Penyewa (Guest)",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 5),
              const gabaritoText(
                text: "Silakan lengkapi data diri Anda untuk melanjutkan pesanan tanpa login.",
                textColor: Colors.black54,
                fontSize: 13,
              ),
              const SizedBox(height: 15),
              reusableTextField(
                title: 'Nama Lengkap*',
                controller: controller.guestNameC,
              ),
              const SizedBox(height: 10),
              reusableTextField(
                title: 'Email*',
                controller: controller.guestEmailC,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              reusableTextField(
                title: 'Nomor HP (WhatsApp)*',
                controller: controller.guestPhoneC,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              reusableTextField(
                title: 'Nomor Telepon Darurat*',
                controller: controller.guestEmergencyPhoneC,
                inputType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
