import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../../../widget/widgets.dart';

class HeaderWidget extends StatelessWidget {
  final DashboardController controller;
  const HeaderWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/background.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.black.withOpacity(0.2),
              ),
              Positioned(
                left: 20,
                top: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gabaritoText(
                      text: controller.getGreetingText(),
                      textColor: Colors.white,
                      fontSize: 20,
                    ),
                    gabaritoText(
                      text:
                          "Hari yang baru, rencana baru! Siapin kendaraan\nfavoritmu bareng Transgo.",
                      textColor: Colors.white,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
