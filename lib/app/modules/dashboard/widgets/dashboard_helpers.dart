import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../../widget/widgets.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';

Widget titleInfoWidget({String? title}) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: HexColor('#F0F2F9'),
          border: Border.all(color: primaryColor)),
      child: gabaritoText(
        text: title ?? '',
        fontSize: 14,
        textColor: primaryColor,
      ));
}

Widget infoCaraSewa(String title, String subtitle, IconData icon,
    {bool withLine = true}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor('#EEF2F8')),
            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),
          if (withLine)
            Container(
              width: 1,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(10, (index) {
                  return Container(height: 5, color: primaryColor);
                }),
              ),
            )
        ],
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gabaritoText(text: title, textColor: textHeadline),
            const SizedBox(height: 5),
            gabaritoText(text: subtitle, textColor: textSecondary),
          ],
        ),
      )
    ],
  );
}

Widget expansionTileDashboard({String title = '', String subtitle = ''}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      title: gabaritoText(
        text: title,
        textColor: solidPrimary,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: gabaritoText(
            text: subtitle,
            textColor: textSecondary,
          ),
        ),
        const SizedBox(height: 10)
      ],
    ),
  );
}

Widget cardInformationDashboard({
  String imagePath = 'car.png',
  double scale = 1,
  String title = '',
  String subtitle = '',
  double? width,
  double? height,
}) {
  return BackgroundCard(
      height: height,
      width: width ?? MediaQuery.of(Get.context!).size.width,
      marginVertical: 10,
      stringHexBG: '#FAFAFA',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/$imagePath', scale: scale),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: gabaritoText(
                text: '$title',
                fontSize: 16,
                textColor: textHeadline,
              )),
          gabaritoText(text: '$subtitle', textColor: textPrimary)
        ],
      ));
}
