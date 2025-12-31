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
      image: 'assets/panduan/panduan_1.jpeg',
      title: 'Pencarian Layanan',
      description:
          'Lakukan pencarian layanan sesuai dengan kebutuhan perjalanan Anda.',
    ),
    const PanduanItem(
      image: 'assets/panduan/panduan_2.jpeg',
      title: 'Pilih Kendaraan',
      description:
          'Pilih jenis kendaraan yang tersedia dan sesuai dengan kebutuhan Anda.',
    ),
    const PanduanItem(
      image: 'assets/panduan/panduan_3.jpeg',
      title: 'Konfirmasi Pesanan',
      description:
          'Periksa kembali seluruh detail pesanan sebelum melanjutkan.',
    ),
    const PanduanItem(
      image: 'assets/panduan/panduan_4.jpeg',
      title: 'Isi Formulir Pesanan',
      description:
          'Lengkapi data yang diperlukan pada formulir pemesanan dengan benar.',
    ),
    const PanduanItem(
      image: 'assets/panduan/panduan_5.jpeg',
      title: 'Pesanan Berhasil',
      description:
          'Pesanan berhasil dibuat. Silakan menunggu konfirmasi dari admin sebelum melanjutkan ke tahap pembayaran.',
    ),
  ].obs;
}
