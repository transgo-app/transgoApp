import 'package:flutter/material.dart';
import '../../controllers/dashboard_controller.dart';
import 'intro_section.dart';
import 'cara_sewa_section.dart';
import 'why_transgo_section.dart';
import 'layanan_section.dart';
import 'testimoni_section.dart';
import 'faq_section.dart';
import 'media_logos_section.dart';
import 'client_section.dart';
import 'fleet_partner.dart';
import 'package:transgomobileapp/app/widget/Card/CardKeunggulan.dart';
import 'chatbot_section.dart';

class EmptyStateSection extends StatelessWidget {
  final DashboardController controller;
  const EmptyStateSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntroSection(controller: controller),
                  CaraSewaSection(controller: controller),
                  WhyTransgoSection(controller: controller),
                  ClientSection(),
                  LayananSection(controller: controller),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: CardKeunggulanTransgo()),
            FleetPartnerSection(),
            TestimoniSection(controller: controller),
            FAQSection(controller: controller),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HelpAISection(),
                ],
              ),
            ),
            MediaLogosSection(controller: controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
