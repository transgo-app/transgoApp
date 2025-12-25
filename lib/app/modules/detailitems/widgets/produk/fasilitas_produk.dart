import 'package:flutter/material.dart';
import '../../controllers/detailitems_controller.dart';

class FasilitasWidget extends StatelessWidget {
  final DetailitemsController controller;

  const FasilitasWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final category = controller.detailData['item']?['category'] ?? '';
    final fasilitas = controller.detailData['fasilitas'] != null
        ? List<String>.from(controller.detailData['fasilitas'])
        : <String>[
            "Pouch",
            "iPhone",
            "Kabel Charger (type c to lightning)",
            "Tempered Glass",
            "Casing",
            "Buku Panduan Syarat dan Ketentuan",
          ];
    if (category != "iphone") {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Fasilitas yang didapat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xfff1f6ff),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...fasilitas.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,
                            size: 8, color: Color(0xff2e6bff)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3A8DFF),
                    width: 1.4,
                  ),
                ),
                child: const Text(
                  "Jika kamu membutuhkan kepala charge, powerbank, dan kabel usb to lightning "
                  "bisa dibantu untuk konfirmasi ke admin ya untuk pemesanan add on-nya",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
