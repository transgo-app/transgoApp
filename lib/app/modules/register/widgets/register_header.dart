import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'register_tab.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: HexColor("#F4F5F6"),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/woman-register.png',
              scale: 4.5,
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              color: HexColor("#FAFAFA"),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.offAndToNamed('/login');
                  },
                  child: RegisterTab(isActive: false, title: "Masuk")),
              RegisterTab(isActive: true, title: "Register")
            ],
          ),
        ),
      ],
    );
  }
}
