import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/dashboard_controller.dart';
import 'dashboard_helpers.dart';
import '../../../widget/widgets.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/Card/CardKeunggulan.dart';


class EmptyStateSection extends StatelessWidget {
  final DashboardController controller;
  const EmptyStateSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/woman.png', scale: 2),
                  gabaritoText(
                    text: 'Yuk, Cari Kendaraan yang Cocok!',
                    fontSize: 18,
                    textColor: textHeadline,
                  ),
                  gabaritoText(
                    text:
                        'Pilih lokasi, tanggal, dan jenis kendaraan dulu ya. Abis itu tinggal klik tombol "Cari" biar kami tampilkan semua pilihan yang siap kamu sewa!',
                    fontSize: 14,
                    textColor: textSecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  titleInfoWidget(title: "Cara Sewa"),
                  gabaritoText(
                    text: 'Gak Ribet, Begini Langkah Sewa di Transgo',
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  infoCaraSewa(
                      "Pesan Kendaraan Sesuai Kebutuhanmu",
                      'Mulai dari website atau aplikasi, pilih unit kendaraan, lokasi penjemputan, dan tanggal sewa yang kamu inginkan. Gampang dan fleksibel, tinggal klik!',
                      IconsaxPlusBold.global_search),
                  infoCaraSewa(
                      'Pesanan Diproses, Tunggu Sebentar ya!',
                      'Setelah kamu memesan, tim Transgo akan memprosesnya. Kamu bakal dapat notifikasi lewat email atau WhatsApp soal status pesananmu. Tenang, kami gercep kok!',
                      IconsaxPlusBold.timer),
                  infoCaraSewa(
                      'Saatnya Bayar dengan Mudah',
                      'Kalau pesanan kamu sudah diverifikasi, invoice akan langsung dikirim lewat sistem paper.id. Kamu bisa bayar langsung di tempat sesuai panduan yang kami kirimkan.',
                      IconsaxPlusBold.money_time,
                      withLine: false),
                  const SizedBox(height: 20),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: titleInfoWidget(title: 'Why Transgo')),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: gabaritoText(
                        text: 'Kenapa Harus Transgo Buat Sewa Kendaraan?',
                        fontSize: 20,
                        textColor: textHeadline,
                        textAlign: TextAlign.center,
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: gabaritoText(
                        text:
                            'Kami hadir dengan layanan sewa mobil dan motor di Jakarta yang cepat, mudah, dan pastinya terpercaya. Armada kami selalu terawat, harga transparan, dan pelayanannya profesional. Transgo siap nemenin perjalanan kamu—buat kerja, liburan, atau keperluan harian',
                        textColor: textSecondary,
                      )),
                  expansionTileDashboard(
                      title: 'Bisa Sewa Kapan Aja',
                      subtitle:
                          'Layanan sewa mobil dan motor Transgo tersedia 24 jam. Fleksibel banget buat kamu yang punya jadwal padat atau mendadak butuh kendaraan.'),
                  expansionTileDashboard(
                      title: 'Tanpa DP atau Deposit',
                      subtitle:
                          'Sewa jadi lebih simpel tanpa perlu bayar uang muka. Tinggal pilih kendaraan, isi data, dan kamu siap jalan tanpa ribet.'),
                  expansionTileDashboard(
                      title: 'Unit Terlindungi & Gak Perlu Survey',
                      subtitle:
                          'Mulai dari Rp15.000, kendaraan kamu udah terlindungi asuransi. Gak perlu repot disurvei, cukup isi data, dan kami urus sisanya.'),
                  expansionTileDashboard(
                      title: 'Harga Mulai dari 40K per Hari',
                      subtitle:
                          'Motor bisa kamu sewa mulai dari Rp40.000/hari dan mobil dari Rp200.000/hari. Harganya transparan, tanpa biaya tambahan tersembunyi.'),
                  Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Image.asset('assets/totaluser.png', scale: 3)),
                  titleInfoWidget(title: "Layanan"),
                  gabaritoText(
                    text: 'Layanan Sewa Lengkap, Siap Temani Perjalananmu',
                    fontSize: 20,
                    textAlign: TextAlign.center,
                    textColor: textHeadline,
                  ),
                  const SizedBox(height: 10),
                  gabaritoText(
                    text:
                        'Kami menawarkan berbagai layanan sewa mobil & motor di Jakarta yang fleksibel dan nyaman. Semua dirancang buat memenuhi kebutuhan perjalanan kamu, kapan pun dan ke mana pun tujuannya.',
                    textColor: textSecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: controller.cardDataLayanan.map((data) {
                      return cardInformationDashboard(
                        imagePath: data['imagePath']!,
                        scale: 3.0,
                        title: data['title']!,
                        subtitle: data['subtitle']!,
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: gabaritoText(
                          text:
                              'Transgo nggak cuma soal sewa mobil dan motor di Jakarta, lho — masih banyak layanan seru lainnya yang bisa kamu pakai!',
                          textColor: textHeadline,
                          fontSize: 16,
                        )),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: controller.scrollLeft,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: HexColor('#FAFAFA'),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(IconsaxPlusBold.arrow_left_1),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: controller.scrollRight,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: HexColor('#FAFAFA'),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(IconsaxPlusBold.arrow_right),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: controller.scrollControllerLayanan,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < controller.cardDataLayananLainnya.length; i++)
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: cardInformationDashboard(
                              imagePath: controller.cardDataLayananLainnya[i]['imagePath']!,
                              scale: 4.0,
                              title: controller.cardDataLayananLainnya[i]['title']!,
                              subtitle: controller.cardDataLayananLainnya[i]['subtitle']!,
                              width: 300,
                              height: 300)),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10), child: CardKeunggulanTransgo()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  titleInfoWidget(title: "Testimoni"),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: gabaritoText(text: 'Banyak yang Udah Coba, dan Mereka Suka!', fontSize: 20, textColor: textHeadline, textAlign: TextAlign.center)),
                  const SizedBox(height: 10),
                  gabaritoText(text: 'Transgo udah dipakai banyak orang dan dapet rating 4.8 dari 5, lho! Berdasarkan 850+ penilaian, mereka puas dengan layanan kami yang cepat, ramah, dan tanpa ribet.', textAlign: TextAlign.center, textColor: textSecondary),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < controller.testimoni.length; i++)
                    BackgroundCard(
                        height: 350,
                        marginVertical: 20,
                        marginHorizontal: 10,
                        width: MediaQuery.of(context).size.width / 1.5,
                        body: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(
                                    IconsaxPlusBold.profile,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                gabaritoText(text: controller.testimoni[i]['author'] ?? ''),
                              ],
                            ),
                            Divider(),
                            gabaritoText(text: controller.testimoni[i]['title'] ?? '', textColor: textPrimary),
                            const SizedBox(height: 10),
                            Align(alignment: Alignment.centerRight, child: Icon(IconsaxPlusBold.quote_down, color: textPrimary, size: 38))
                          ],
                        )),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), child: Column(children: [
              titleInfoWidget(title: 'FAQ'),
              gabaritoText(text: 'Pertanyaan yang Sering Ditanyakan', fontSize: 25, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              gabaritoText(text: 'Temukan jawaban dari pertanyaan-pertanyaan yang sering ditanyain sama pengguna Transgo. Siapa tahu kamu juga lagi nyari info yang sama', textColor: textSecondary, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              for (var i = 0; i < controller.faqContent.length; i++) expansionTileDashboard(title: controller.faqContent[i]['title'] ?? '', subtitle: controller.faqContent[i]['subtitle'] ?? ''),
              const SizedBox(height: 20),
              gabaritoText(text: 'Diliput di Berbagai Media', fontSize: 25),
              const SizedBox(height: 10),
              gabaritoText(text: 'Transgo udah dipercaya banyak pengguna, dan juga pernah diliput oleh beberapa media keren berikut. Yuk, intip siapa aja yang udah bahas layanan sewa mobil & motor terdekat dari Transgo!', textColor: textSecondary, textAlign: TextAlign.center),
              const SizedBox(height: 25),
            ])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: SingleChildScrollView(
                controller: controller.scrollContentController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.logos.map((fileName) {
                    bool isSvg = fileName.toLowerCase().endsWith(".svg");
                    return Container(
                      margin: EdgeInsets.only(right: 64),
                      height: 48,
                      width: 96,
                      child: isSvg
                          ? SvgPicture.network(
                              controller.getImageUrl(fileName),
                              fit: BoxFit.contain,
                              placeholderBuilder: (context) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                            )
                          : Image.network(
                              controller.getImageUrl(fileName),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey[300], child: Icon(Icons.image_not_supported));
                              },
                            ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
