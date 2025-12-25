import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../widget/widgets.dart';
import '../../../data/theme.dart';

class RegisterStep extends StatelessWidget {
  final bool isVerified;

  const RegisterStep({super.key, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: isVerified ? primaryColor : Colors.white,
              border: Border.all(
                  color: isVerified ? primaryColor : HexColor('#B1C8F2')),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
              child: isVerified
                  ? Icon(
                      IconsaxPlusBold.tick_circle,
                      color: Colors.white,
                    )
                  : gabaritoText(
                      text: "1",
                      textColor: primaryColor,
                      fontWeight: FontWeight.w600,
                    )),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: gabaritoText(
              text: "Data Diri",
              textColor: primaryColor,
              fontSize: 14,
            )),
        Container(
          width: 50,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: List.generate(
                  10,
                  (index) => Expanded(
                    child: Container(
                      color: index.isEven ? Colors.grey : Colors.transparent,
                      height: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: HexColor('#B1C8F2')),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
              child: gabaritoText(
            text: "2",
            textColor: primaryColor,
            fontWeight: FontWeight.w600,
          )),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: gabaritoText(
              text: "Dokumen",
              textColor: primaryColor,
              fontSize: 14,
            )),
      ],
    );
  }
}