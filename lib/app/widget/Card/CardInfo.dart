
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ContainerInfo extends StatelessWidget {
  final Widget widget;
  const ContainerInfo({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(vertical: 8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor('#EEF6FF'),
            border: Border.all(
              color: Colors.blue
            )
          ),
          child: widget,
        );
  }
}