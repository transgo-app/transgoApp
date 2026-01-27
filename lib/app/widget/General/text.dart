import 'package:flutter/material.dart';
import '../../data/theme.dart';

class poppinsText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final double heightText;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? useFittedBox;

  const poppinsText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.textAlign,
      this.heightText = 1.0,
      this.maxLines,
      this.overflow,
      this.useFittedBox = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: poppinsTextStyle.copyWith(
        fontSize: fontSize ?? 11,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor,
        height: heightText == 1.0 ? null : heightText
      ),
    );

    if (useFittedBox == true) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: textAlign == null 
            ? Alignment.centerLeft 
            : (textAlign == TextAlign.center 
                ? Alignment.center 
                : (textAlign == TextAlign.right 
                    ? Alignment.centerRight 
                    : Alignment.centerLeft)),
        child: textWidget,
      );
    }

    return textWidget;
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
  final bool? useFittedBox;

  const gabaritoText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.textAlign,
      this.heightText = 1.0,
      this.Maxlines,
      this.overflow,
      this.useFittedBox = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: Maxlines,
      overflow: overflow ?? (Maxlines != null ? TextOverflow.ellipsis : null),
      style: gabaritoTextStyle.copyWith(
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor,
        height: heightText == 1.0 ? null : heightText
      ),
    );

    if (useFittedBox == true) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: textAlign == null 
            ? Alignment.centerLeft 
            : (textAlign == TextAlign.center 
                ? Alignment.center 
                : (textAlign == TextAlign.right 
                    ? Alignment.centerRight 
                    : Alignment.centerLeft)),
        child: textWidget,
      );
    }

    return textWidget;
  }
}
