import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                  : CachedNetworkImage(
                      imageUrl: controller.getImageUrl(fileName),
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                      memCacheWidth: 200,
                      memCacheHeight: 100,
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }
}