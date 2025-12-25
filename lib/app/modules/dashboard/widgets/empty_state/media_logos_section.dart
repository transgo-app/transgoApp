import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/dashboard_controller.dart';

class MediaLogosSection extends StatelessWidget {
  final DashboardController controller;
  const MediaLogosSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: SingleChildScrollView(
        controller: controller.scrollContentController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.logos.map((fileName) {
            bool isSvg = fileName.toLowerCase().endsWith(".svg");
            return Container(
              margin: EdgeInsets.only(right: 64),
              height: 48,
              width: 96,
              child: isSvg
                  ? SvgPicture.network(
                      controller.getImageUrl(fileName),
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : Image.network(
                      controller.getImageUrl(fileName),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[300], child: Icon(Icons.image_not_supported));
                      },
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }
}