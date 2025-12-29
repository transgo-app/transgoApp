import 'package:flutter_popup/flutter_popup.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/Card/InfoCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBatalkanSewa.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalPenganggungJawab.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/detailriwayat_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class DetailriwayatView extends GetView<DetailriwayatController> {
  const DetailriwayatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(IconsaxPlusBold.arrow_left_1, size: 33),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: gabaritoText(
          text: "Detail Riwayat Sewa",
          fontSize: 16,
          textColor: textHeadline,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        } else if (controller.detaiItemsID.isNotEmpty) {
          var fleet = controller.detaiItemsID['fleet'];
          var product = controller.detaiItemsID['product'];
          var startReq = controller.detaiItemsID['start_request'] ?? {};
          var endReq = controller.detaiItemsID['end_request'] ?? {};
          var insurance = controller.detaiItemsID['insurance'] ?? {};
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: primaryColor,
                  color: Colors.white,
                  onRefresh: () => controller.getDataById(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(minHeight: 200),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                fleet?['photo']?['photo'] ??
                                    product?['photo']?['photo'] ??
                                    '',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StatusRiwayatStyle(
                                    orderStatus: controller
                                            .detaiItemsID['order_status'] ??
                                        '',
                                    paymentStatus: controller
                                            .detaiItemsID['payment_status'] ??
                                        '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: gabaritoText(
                              text: fleet?['name'] ?? product?['name'] ?? '',
                              fontSize: 15,
                              textColor: textHeadline,
                            ),
                          ),
                          iconWithDetailSewa(
                            IconsaxPlusBold.calendar_edit,
                            formatTanggalSewa(
                                controller.detaiItemsID['start_date'],
                                controller.detaiItemsID['duration']),
                          ),
                          iconWithDetailSewa(
                            (fleet?['type'] ?? 'car') == 'car'
                                ? IconsaxPlusBold.car
                                : Icons.motorcycle,
                            fleet?['type_label'] ??
                                product?['category_label'] ??
                                '',
                          ),
                          iconWithDetailSewa(
                              IconsaxPlusBold.color_swatch,
                              fleet?['color'] ??
                                  product?['specifications']?['color'] ??
                                  ''),
                          const SizedBox(height: 15),
                          const gabaritoText(text: "Estimasi Total Pembayaran"),
                          Text(
                            "Rp ${formatRupiah(controller.detailKendaraan['grand_total'])}",
                            style: gabaritoTextStyle.copyWith(
                                fontSize: 16, color: primaryColor),
                          ),
                          if (controller.detailKendaraan['weekend_days']
                                  ?.isNotEmpty ??
                              false)
                            BackgroundCard(
                                marginVertical: 10,
                                stringHexBorder: '#A8F2FC',
                                paddingHorizontal: 10,
                                paddingVertical: 10,
                                body: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: HexColor('#F2FDFF'),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(IconsaxPlusBold.info_circle,
                                          color: HexColor('#03AEC4')),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: gabaritoText(
                                      text:
                                          'Karena sewa kamu jatuh di hari Sabtu atau Minggu, akan ada tambahan biaya weekend: Rp50.000/hari untuk mobil dan Rp30.000/hari untuk motor, dihitung per 24 jam dari total durasi sewa.',
                                      fontSize: 14,
                                    )),
                                  ],
                                )),
                          BackgroundCard(
                              paddingHorizontal: 10,
                              paddingVertical: 10,
                              marginVertical: 8,
                              stringHexBG: '#FAFAFA',
                              height: 200,
                              body: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: GoogleMapsEmbedPage(
                                          iframeUrl: fleet?['location']
                                                  ?['map_url'] ??
                                              '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: gabaritoText(
                                              text: fleet?['location']
                                                      ?['location'] ??
                                                  '',
                                              fontSize: 13)),
                                      const SizedBox(width: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          gabaritoText(
                                              text: "Lihat Maps",
                                              fontSize: 14,
                                              textColor: solidPrimary),
                                          const SizedBox(width: 5),
                                          Icon(IconsaxPlusBold.send_sqaure_2,
                                              color: solidPrimary, size: 16)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          detailSewaCard(
                              "Pemakaian",
                              "Kalau kamu pakai kendaraannya ke luar kota, ada biaya tambahan harian, ya.",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gabaritoText(
                                    text: controller.detaiItemsID[
                                                'is_out_of_town'] ==
                                            false
                                        ? "Dalam Kota"
                                        : "Luar Kota",
                                    fontSize: 16,
                                    textColor: textHeadline,
                                  )
                                ],
                              )),
                          detailSewaCard(
                              "Lokasi Pengambilan",
                              "Pilih lokasi kendaraan bakal kamu ambil di hari pertama sewa.",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gabaritoText(
                                    text: startReq['is_self_pickup'] == true
                                        ? "Garasi Transgo"
                                        : "Kami Antar Ke Tempat Kamu",
                                    fontSize: 16,
                                  ),
                                  gabaritoText(
                                    textColor: textPrimary,
                                    text: (startReq['is_self_pickup'] == true
                                            ? fleet?['location']?['location'] ??
                                                ''
                                            : startReq['address'] ?? '')
                                        .trim(),
                                  )
                                ],
                              )),
                          detailSewaCard(
                              "Lokasi Pengembalian",
                              "Pilih lokasi tempat kamu bakal balikin kendaraan di hari terakhir sewa.",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gabaritoText(
                                    text: endReq['is_self_pickup'] == true
                                        ? "Garasi Transgo"
                                        : "Kami Jemput Ke Tempat Kamu",
                                    fontSize: 16,
                                  ),
                                  gabaritoText(
                                    textColor: textPrimary,
                                    text: (endReq['is_self_pickup'] == true
                                            ? fleet?['location']?['location'] ??
                                                ''
                                            : endReq['address'] ?? '')
                                        .trim(),
                                  )
                                ],
                              )),
                          detailSewaCard(
                              "Asuransi",
                              "Pilih perlindungan yang paling pas biar perjalanan makin aman.",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gabaritoText(
                                      text: insurance['name'] ?? 'Tidak Ada'),
                                  gabaritoText(
                                      text: insurance['description'] ??
                                          'Bawa kendaraan dengan hati-hati ya!'),
                                  gabaritoText(
                                      text:
                                          "+Rp. ${formatRupiah("${insurance['price'] ?? 0}")}",
                                      textColor: Colors.red),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider()),
                                  const InfoCard(
                                      icon: IconsaxPlusBold.info_circle,
                                      hexIconColor: "#03AEC4",
                                      hexBorder: '#03AEC4',
                                      hexColorBG: "#A8F2FC",
                                      hexBG: "#F2FDFF",
                                      title:
                                          "Asuransi ini bantu lindungi kamu dari risiko finansial kalau ada kejadian tak terduga.")
                                ],
                              )),
                          IgnorePointer(
                            ignoring: true,
                            child: Opacity(
                              opacity: 0.8,
                              child: BackgroundCard(
                                  stringHexBG: "#FFFFFF",
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const gabaritoText(text: "Permintaan Khusus"),
                                      gabaritoText(
                                        text:
                                            "Tulis kebutuhan sewa kamu di sini.",
                                        textColor: textPrimary,
                                        fontSize: 13,
                                      ),
                                      const SizedBox(height: 10),
                                      reusableTextField(
                                        title:
                                            'Tuliskan permintaan khususmu disini',
                                        maxLines: 3,
                                        controller:
                                            controller.permintaanKhususC,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ReusableButton(
                            ontap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => const ModalPenanggungJawab(),
                              );
                            },
                            bgColor: Colors.green,
                            widget: Row(
                              children: [
                                Image.asset('assets/wa_white.png', scale: 15),
                                const SizedBox(width: 10),
                                const Expanded(
                                    child: gabaritoText(
                                  text:
                                      "Klik untuk lihat detail penanggung jawab antar & ambil kendaraan rental kamu",
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      const InfoCard(
                          icon: IconsaxPlusBold.info_circle,
                          hexIconColor: "#03AEC4",
                          hexBorder: '#03AEC4',
                          hexColorBG: "#A8F2FC",
                          hexBG: "#F2FDFF",
                          title:
                              "Ada kendala atau mau perpanjang sewa? Hubungi Admin."),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomPopup(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextButton(
                                  title: "Detail Sewa",
                                  ontap: () {
                                    Get.bottomSheet(
                                      BottomSheetKonfirmasiPemesanan(
                                        data: controller.detailKendaraan,
                                        buttonConfirmation: Container(),
                                        duration: controller
                                            .dataArguments['duration'],
                                      ),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                  },
                                  textColor: textHeadline,
                                ),
                                CustomTextButton(
                                  title: "Penanggung Jawab Antar & Ambil",
                                  ontap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                         const ModalPenanggungJawab(),
                                    );
                                  },
                                  textColor: textHeadline,
                                ),
                                if (!controller.isCancelOrderDisabled.value)
                                  CustomTextButton(
                                    title: "Batalkan Sewa",
                                    ontap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => const Wrap(
                                            children: [ModalBatalkanSewa()]),
                                      );
                                    },
                                    textColor: textHeadline,
                                  )
                              ],
                            ),
                            child: const BackgroundCard(
                              width: 50,
                              height: 50,
                              stringHexBorder: "#686D76",
                              body: Icon(Icons.more_vert_outlined),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (controller.detaiItemsID['payment_status'] ==
                                  'pending' &&
                              controller.dataArguments['payment_pdf_url'] !=
                                  null)
                            Expanded(
                              child: ReusableButton(
                                height: 50,
                                ontap: () {
                                  launchUrl(Uri.parse(
                                      'https://${controller.dataArguments['payment_link']}'));
                                },
                                bgColor: primaryColor,
                                title: "Bayar Sekarang",
                              ),
                            ),
                          if (controller.detaiItemsID['payment_status'] !=
                                  'pending' ||
                              controller.dataArguments['payment_pdf_url'] ==
                                  null)
                            Expanded(
                              child: ReusableButton(
                                height: 50,
                                ontap: () {
                                  launchUrl(Uri.parse(
                                      'https://wa.me/$whatsAppNumberAdmin?text=Halo Admin Transgo, saya sudah order di aplikasi.'));
                                },
                                bgColor: primaryColor,
                                title: "Hubungi Admin Sekarang",
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        } else {
          return Center(child: Container());
        }
      }),
    );
  }

  Widget iconWithDetailSewa(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: solidPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: gabaritoText(
              text: title,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget detailSewaCard(String title, String subtitle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gabaritoText(text: title),
              const SizedBox(height: 5),
              gabaritoText(
                  text: subtitle, fontSize: 13, textColor: textPrimary),
              const SizedBox(height: 12),
              BackgroundCard(height: 20, body: content),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
      ],
    );
  }
}
