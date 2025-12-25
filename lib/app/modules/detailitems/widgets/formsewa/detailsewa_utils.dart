import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widget/widgets.dart';
import 'package:transgomobileapp/app/data/theme.dart';

Widget rowJamBiaya(String jam, String biaya) {
  return Padding(
    padding: EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(Get.context!).size.width / 3.2,
            child: gabaritoText(
              text: '🕒 $jam',
              fontSize: 15,
            )),
        SizedBox(width: 8),
        Expanded(
          child: gabaritoText(
            text: '→ $biaya',
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

Widget iconWithDetailSewa(IconData icon, String title) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: solidPrimary,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: gabaritoText(
          text: title,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ))
      ],
    ),
  );
}
