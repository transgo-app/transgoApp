import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_helpers.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class TestimoniSection extends StatelessWidget {
  final DashboardController controller;
  const TestimoniSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              titleInfoWidget(title: "Testimoni"),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: gabaritoText(
                      text: 'Banyak yang Udah Coba, dan Mereka Suka!',
                      fontSize: 20,
                      textColor: textHeadline,
                      textAlign: TextAlign.center)),
              const SizedBox(height: 10),
              gabaritoText(
                  text:
                      'Transgo udah dipakai banyak orang dan dapet rating 4.8 dari 5, lho! Berdasarkan 850+ penilaian, mereka puas dengan layanan kami yang cepat, ramah, dan tanpa ribet.',
                  textAlign: TextAlign.center,
                  textColor: textSecondary),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < controller.testimoni.length; i++)
                BackgroundCard(
                    height: 350,
                    marginVertical: 20,
                    marginHorizontal: 10,
                    width: MediaQuery.of(context).size.width / 1.5,
                    body: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: primaryColor,
                              child: Icon(
                                IconsaxPlusBold.profile,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            gabaritoText(
                                text: controller.testimoni[i]['author'] ?? ''),
                          ],
                        ),
                        Divider(),
                        gabaritoText(
                            text: controller.testimoni[i]['title'] ?? '',
                            textColor: textPrimary),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Icon(IconsaxPlusBold.quote_down,
                                color: textPrimary, size: 38))
                      ],
                    )),
            ],
          ),
        ),
      ],
    );
  }
}
