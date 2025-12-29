import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class AuthTabHeader extends StatelessWidget {
  final bool isLogin;

  const AuthTabHeader({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: HexColor("#FAFAFA"),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tab(
            title: "Masuk",
            isActive: isLogin,
            onTap: () {
              if (!isLogin) {
                Get.offNamed('/login');
              }
            },
          ),
          _tab(
            title: "Register",
            isActive: !isLogin,
            onTap: () {
              if (isLogin) {
                Get.offNamed(
                  '/register',
                  arguments: {
                    'paramPost': {},
                    'detailKendaraan': {}
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? HexColor('#1F61D9') : null,
          borderRadius: BorderRadius.circular(40),
        ),
        child: gabaritoText(
          text: title,
          textColor: isActive ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
