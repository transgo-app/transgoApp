import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class DialogSuccessUploadRegister extends StatefulWidget {
  final String kategori;
  const DialogSuccessUploadRegister({super.key, required this.kategori});

  @override
  State<DialogSuccessUploadRegister> createState() => _DialogSuccessUploadRegisterState();
}

class _DialogSuccessUploadRegisterState extends State<DialogSuccessUploadRegister> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        if (mounted) Navigator.of(context).pop();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/successpemesanan.json'),
            const SizedBox(height: 20,),
            poppinsText(
              text: "Gambar ${widget.kategori} Telah Ditambahkan", 
              fontWeight: FontWeight.w600, 
              fontSize: 16, 
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            poppinsText(
              text: "Dialog akan ditutup dalam $_countdown detik",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
