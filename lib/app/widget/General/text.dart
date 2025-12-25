import 'package:flutter/material.dart';
import '../../data/theme.dart';

class poppinsText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final double heightText;

  const poppinsText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.textAlign,
      this.heightText = 1.0
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: poppinsTextStyle.copyWith(
        fontSize: fontSize ?? 11,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor,
        height: heightText == 1.0 ? null : heightText
      ),
    );
  }
}


class gabaritoText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final double heightText;
  final int? Maxlines;
  final TextOverflow? overflow;

  const gabaritoText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.textAlign,
      this.heightText = 1.0,
      this.Maxlines,
      this.overflow
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      
      text,
      textAlign: textAlign,
      maxLines: Maxlines,
      overflow: overflow,
      style: gabaritoTextStyle.copyWith(
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor,
        height: heightText == 1.0 ? null : heightText
      ),
    );
  }
}
