import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/webViewGmaps.dart';

class SectionMaps extends StatelessWidget {
  final DetailitemsController controller;
  const SectionMaps({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.detailData['item'] ?? {};
    final locationName = item["location"] ?? "-";
    final String redirectUrl = item['redirect_url'] ?? '';
    final String mapEmbedUrl = controller.googleMapEmbed.value;

    return BackgroundCard(
      paddingHorizontal: 10,
      paddingVertical: 10,
      marginVertical: 8,
      stringHexBG: '#FAFAFA',
      height: 200,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  print("Map tapped");
                },
                child: GoogleMapsEmbedPage(
                  iframeUrl: mapEmbedUrl,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: gabaritoText(
                  text: locationName,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(redirectUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    print("Tidak bisa membuka URL: $redirectUrl");
                  }
                },
                child: Row(
                  children: [
                    gabaritoText(
                      text: "Lihat Maps",
                      fontSize: 14,
                      textColor: solidPrimary,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      IconsaxPlusBold.send_sqaure_2,
                      color: solidPrimary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
