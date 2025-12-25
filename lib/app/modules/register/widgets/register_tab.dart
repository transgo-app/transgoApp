import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../widget/widgets.dart';

class RegisterTab extends StatelessWidget {
  final bool isActive;
  final String title;

  const RegisterTab({super.key, required this.isActive, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
          color: isActive ? HexColor('#1F61D9') : null,
          borderRadius: BorderRadius.circular(40)),
      child: gabaritoText(
        text: title,
        textColor: isActive ? Colors.white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}