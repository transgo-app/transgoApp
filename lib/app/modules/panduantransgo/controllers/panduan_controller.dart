import 'package:get/get.dart';

class PanduanItem {
  final String image;
  final String title;
  final String description;

  const PanduanItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class PanduanController extends GetxController {
  final panduanList = <PanduanItem>[
    const PanduanItem(
      image: 'assets/images/panduan_1.png',
      title: 'Pilih Lokasi',
      description:
          'Tentukan lokasi penjemputan dan tujuan sesuai kebutuhan kamu.',
    ),
    const PanduanItem(
      image: 'assets/images/panduan_2.png',
      title: 'Konfirmasi Pesanan',
      description:
          'Periksa kembali detail pesanan sebelum melanjutkan.',
    ),
  ].obs;
}
