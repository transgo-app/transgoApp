import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String hexIconColor;
  final String hexColorBG;
  final String hexBorder;
  final String hexBG;
  final String title;

  const InfoCard({super.key, required this.icon, required this.hexIconColor, required this.hexColorBG, required this.title, required this.hexBorder, required this.hexBG});

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
    marginVertical: 10,
    stringHexBorder: hexBorder,
    paddingHorizontal: 10,
    paddingVertical: 10,
    stringHexBG: hexBG,
    body: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 10),
          child: Icon(
            icon,
            color: HexColor(hexIconColor),
          ),
          decoration: BoxDecoration(
              color: HexColor(hexColorBG),
              borderRadius:
                  BorderRadius.circular(10)),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: gabaritoText(
          text: title,
          fontSize: 14,
        )),
      ],
    ));
  }
}