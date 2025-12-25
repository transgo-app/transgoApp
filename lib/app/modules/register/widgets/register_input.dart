import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/General/newTextfFieldComponent.dart';

class RegisterInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final RxString errText;
  final TextInputType? inputType;

  const RegisterInput({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.errText,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: newReusableTextField(
          title: title,
          hintText: hintText,
          controller: controller,
          errorText: errText.value,
          inputType: inputType,
        ),
      ),
    );
  }
}
