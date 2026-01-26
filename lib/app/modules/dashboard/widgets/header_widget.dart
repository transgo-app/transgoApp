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
                right: 20,
                top: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: gabaritoText(
                        text: controller.getGreetingText(),
                        textColor: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return gabaritoText(
                          text: "Hari yang baru, rencana baru! Siapin kendaraan favoritmu bareng Transgo.",
                          textColor: Colors.white,
                          fontSize: 14,
                          Maxlines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
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
