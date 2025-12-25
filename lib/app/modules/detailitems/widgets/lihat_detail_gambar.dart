import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LihatDetailGambar extends StatelessWidget {
  final File imageUrl;

  const LihatDetailGambar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}