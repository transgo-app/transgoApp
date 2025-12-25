import 'package:flutter/material.dart';
import '../../data/theme.dart';

class ReusableButton extends StatelessWidget {
  final Widget? widget;
  final VoidCallback? ontap;
  final String? title;
  final double? height;
  final double? width;
  final Color? bgColor;
  final Color? borderSideColor;
  final Color? textColor;
  const ReusableButton(
      {super.key,
      this.widget,
      this.ontap,
      this.title,
      this.height = 60,
      this.width,
      this.bgColor,
      this.borderSideColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(color: borderSideColor ?? Colors.transparent),
        minimumSize: Size(
            width == null ? MediaQuery.of(context).size.width : width!,
            height!),
      ),
      child: widget ??
          Text(
            title ?? '',
            style: gabaritoTextStyle.copyWith(
              fontSize: 18,
              color: textColor ?? Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
    );
  }
}
